//
//  AVPlayer_ResourceLoader.m
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/12.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "AVPlayer_ResourceLoader.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface AVPlayer_ResourceLoader ()

@property (nonatomic, strong) NSMutableArray *requestList;
@property (nonatomic, strong) AVPlayer_URLSessionTask *requestTask;

@end

@implementation AVPlayer_ResourceLoader

- (instancetype)init {
    if (self = [super init]) {
        self.requestList = [NSMutableArray array];
    }
    return self;
}

- (void)stopLoading{
    [self.requestTask cancel];
}

#pragma mark - 代理方法处理

#pragma mark - AVAssetResourceLoaderDelegate
- (BOOL)resourceLoader:(AVAssetResourceLoader *)resourceLoader shouldWaitForLoadingOfRequestedResource:(AVAssetResourceLoadingRequest *)loadingRequest {
    //TODO: 拖拽后或播放中产生新的缓冲请求
    [self addLoadingRequest:loadingRequest];
    return YES;
}

- (void)resourceLoader:(AVAssetResourceLoader *)resourceLoader didCancelLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    //TODO: 拖拽导致上一个请求取消
    [self removeLoadingRequest:loadingRequest];
}

#pragma mark -AVPlayer_URLSessionTaskDelegate
- (void)sessionTask:(AVPlayer_URLSessionTask *)task didUpdataPartOfCacheDatas:(NSString *)tmpFilePath{
    //TODO: 请求任务已经更新了部分cache数据后事件处理
        [self processRequestList];//返回数据给avplayer进行播放
    if (self.delegate && [self.delegate respondsToSelector:@selector(loader:cacheProgress:)]) {
        CGFloat cacheProgress = (CGFloat)self.requestTask.responseCacheLength / (self.requestTask.fileLength - self.requestTask.requestOffset);
        [self.delegate loader:self cacheProgress:cacheProgress];//将缓存的进度传递出去
    }
}

- (void)sessionTask:(AVPlayer_URLSessionTask *)task completedSuccessfully:(NSString *)cacheFilePath{
    //TODO: 请求任务已经完成(已经将缓存文件存到了缓存目录)后事件处理
    self.cacheFinished = task.canCache;
}

- (void)sessionTask:(AVPlayer_URLSessionTask *)task didFailed:(NSError *)error{
    //TODO: 请求任务已经失败(已经将缓存文件存到了缓存目录)后事件处理
}

#pragma mark - LoadingRequest事件处理
- (void)addLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    //TODO: 新增缓冲任务
    @synchronized(self) {
        if (self.requestTask) {//说明非第一次请求
            if (loadingRequest.dataRequest.requestedOffset >= self.requestTask.requestOffset &&
                loadingRequest.dataRequest.requestedOffset <= self.requestTask.requestOffset + self.requestTask.responseCacheLength) {
                //新请求的起始位置大于上一个请求的起始位置，并且小于上一个请求已经返回的数据位置，说明当前待播放点的数据已经缓存，则直接完成
                NSLog(@"已有部分缓存数据可供avplayer使用");
                 [self.requestList addObject:loadingRequest];
                [self processRequestList];
            }else {//数据还没缓存，则等待数据下载；如果是Seek操作，则重新请求
                NSLog(@"没有缓存数据可供avplayer使用");
//                if (self.seekRequired == YES) {//请求期间用户进行了拖拽
                [self.requestList enumerateObjectsUsingBlock:^(AVAssetResourceLoadingRequest *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    [obj finishLoadingWithError:nil];
                }];
                    NSLog(@"拖拽操作，则重新请求");
                     [self.requestList addObject:loadingRequest];
                    [self newTaskWithLoadingRequest:loadingRequest cache:NO];//因为拖拽后会从结束点开始缓存，也就是说，之前未完成的缓存不需要了，还有因为拖拽了，肯定不能缓存整首，所以没必要进行本地化
//                }
            }
        }else {
             [self.requestList addObject:loadingRequest];
            [self newTaskWithLoadingRequest:loadingRequest cache:YES];//第一次缓存，肯定是刚点了某一首音乐，我们开始缓存，并且需要本地化
        }
    }
}

- (void)newTaskWithLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest cache:(BOOL)cacheable {
    //开启一个新的缓存任务
    NSUInteger fileLength = 0;
    if (self.requestTask) {//取消上一个缓存任务
        fileLength = self.requestTask.fileLength;
        [self.requestTask cancel];
    }
    
    //重新创建一个请求任务
    self.requestTask = [[AVPlayer_URLSessionTask alloc]initWithUrl:loadingRequest.request.URL.absoluteString];
    self.requestTask.requestURL = loadingRequest.request.URL;
    self.requestTask.requestLength = loadingRequest.dataRequest.requestedLength;
    self.requestTask.requestOffset = loadingRequest.dataRequest.requestedOffset;
    self.requestTask.canCache = cacheable;
    
    if (fileLength > 0) {
        self.requestTask.fileLength = fileLength;
    }
    
    self.requestTask.delegate = self;
    [self.requestTask start];
    self.seekRequired = NO;
}

- (void)processRequestList {//将缓存数据提交给avplayer进行播放
    @synchronized (self) {
        NSMutableArray * finishRequestList = [NSMutableArray array];
        for (AVAssetResourceLoadingRequest * loadingRequest in self.requestList) {
                [self fillInContentInformation:loadingRequest.contentInformationRequest]; //对每次请求加上长度，文件类型等信息
                if ([self ifLoadingRequestLoadingFinished:loadingRequest]) {//判断任务是否全部缓存结束，如果结束就从任务列表中移除
                    [finishRequestList addObject:loadingRequest];
                }
        }
        NSLog(@"当前任务数:%ld", [self.requestList count]);
        [self.requestList removeObjectsInArray:finishRequestList];
    }
}

- (void)fillInContentInformation:(AVAssetResourceLoadingContentInformationRequest *)contentInformationRequest
{
    //填充信息
    CFStringRef contentType = UTTypeCreatePreferredIdentifierForTag(kUTTagClassMIMEType, (__bridge CFStringRef)(@"video/mp3"), NULL);
    contentInformationRequest.contentType = CFBridgingRelease(contentType);
    contentInformationRequest.byteRangeAccessSupported = YES;
    contentInformationRequest.contentLength = self.requestTask.fileLength;
}

- (BOOL)ifLoadingRequestLoadingFinished:(AVAssetResourceLoadingRequest *)loadingRequest {    
    //读文件，填充数据
    NSUInteger cacheLength = self.requestTask.responseCacheLength;
    NSUInteger requestedOffset = loadingRequest.dataRequest.requestedOffset;
    if (loadingRequest.dataRequest.currentOffset != 0) {
        requestedOffset = loadingRequest.dataRequest.currentOffset;
    }
    
    if(requestedOffset < self.requestTask.requestOffset || requestedOffset > self.requestTask.requestOffset + cacheLength){
        return NO;
    }

    NSUInteger  offset = requestedOffset - self.requestTask.requestOffset;
    NSUInteger canReadLength = cacheLength - offset;
    NSUInteger respondLength = MIN(canReadLength, loadingRequest.dataRequest.requestedLength);
    
    NSData *data = [AVPlayer_CacheFileHandler readTempFileDataWithOffset:offset length:respondLength forUrl:loadingRequest.request.URL.absoluteString];
    [loadingRequest.dataRequest respondWithData:data];
    
    //如果完全响应了所需要的数据，则完成
    NSUInteger nowendOffset = requestedOffset + canReadLength;
    NSUInteger reqEndOffset = loadingRequest.dataRequest.requestedOffset + loadingRequest.dataRequest.requestedLength;
    if (nowendOffset >= reqEndOffset) {
        [loadingRequest finishLoading];
        return YES;
    }
    return NO;
}

- (void)removeLoadingRequest:(AVAssetResourceLoadingRequest *)loadingRequest {
    if(loadingRequest.isCancelled == YES)
        [self.requestList removeObject:loadingRequest];
}


@end
