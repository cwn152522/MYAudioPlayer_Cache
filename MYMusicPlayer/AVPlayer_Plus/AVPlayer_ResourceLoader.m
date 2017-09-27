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

@property (nonatomic, strong) AVPlayer_URLSessionTask *requestTask;

@end

@implementation AVPlayer_ResourceLoader

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)stopLoading{
    [self.requestTask cancel];
}

- (void)cacheUrl:(NSURL *)url{
    self.requestTask = [[AVPlayer_URLSessionTask alloc]init];
    self.requestTask.requestURL = url;
    self.requestTask.requestOffset = 0;
    self.requestTask.canCache = YES;
    [self.requestTask start];
}

#pragma mark - 代理方法处理

#pragma mark -AVPlayer_URLSessionTaskDelegate
- (void)sessionTask:(AVPlayer_URLSessionTask *)task didUpdataPartOfCacheDatas:(NSString *)tmpFilePath{
    //TODO: 请求任务已经更新了部分cache数据后事件处理
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


@end
