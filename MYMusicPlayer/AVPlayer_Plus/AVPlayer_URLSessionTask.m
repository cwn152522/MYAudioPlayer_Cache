//
//  AVPlayer_URLSessionTask.m
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/12.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "AVPlayer_URLSessionTask.h"

@interface AVPlayer_URLSessionTask ()<NSURLSessionDataDelegate>

@property (nonatomic, strong) NSURLSession * session;
@property (nonatomic, strong) NSURLSessionDataTask * task;

@property (nonatomic, assign) BOOL didCancelled; //当前任务是否已被取消，取消了的话后续的一些完成操作也同步取消

@end

@implementation AVPlayer_URLSessionTask

- (instancetype)init{
    if(self = [super init]){
        [AVPlayer_CacheFileHandler createTempFile];
    }
    return self;
}

#pragma mark - 任务

- (void)start{
    //TODO: 开始执行缓存任务
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[self.requestURL originalSchemeURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    
    if (self.requestOffset > 0) {//http头部下载指定范围
        [request addValue:[NSString stringWithFormat:@"bytes=%ld-%ld", self.requestOffset, self.fileLength - 1] forHTTPHeaderField:@"Range"];
    }
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.task = [self.session dataTaskWithRequest:request];
    [self.task resume];
}

- (void)cancel{
    //TODO: 取消缓存任务
    _didCancelled = YES;
    [self.task cancel];
    [self.session invalidateAndCancel];
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    //TODO: 请求接收到服务器响应
    if (self.didCancelled)
        return;

    completionHandler(NSURLSessionResponseAllow);
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
    NSString * contentRange = [[httpResponse allHeaderFields] objectForKey:@"Content-Range"];
    NSString * fileLength = [[contentRange componentsSeparatedByString:@"/"] lastObject];
    self.fileLength = fileLength.integerValue > 0 ? fileLength.integerValue : response.expectedContentLength;
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    //TODO: 服务器返回数据，可能会调用多次
    if (self.didCancelled == YES)
        return;
    
    [AVPlayer_CacheFileHandler writeTempFileData:data];//将data写入文本
    self.responseCacheLength += data.length;
    NSLog(@"总字节数：%ld, 已缓存字节数：%ld，偏移量：%ld", self.fileLength, self.responseCacheLength, self.requestOffset);
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTask:didUpdataPartOfCacheDatas:)]) {
        [self.delegate sessionTask:self didUpdataPartOfCacheDatas:[AVPlayer_CachePreference sharedPreference].tmpFilePath];
    }
}

//请求完成会调用该方法，请求失败则error有值
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
    if (self.didCancelled) {
        NSLog(@"下载取消");
    }else {
        if (error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTask:didFailed:)]) {
                [self.delegate sessionTask:self didFailed:error];
            }
        }else {//请求成功
            if (self.canCache == YES) {//可以缓存，说明是整首音乐，将临时文件保存到缓存目录
                NSString *fileName = [[self.requestURL.absoluteString componentsSeparatedByString:@"/"] lastObject];
                [AVPlayer_CacheFileHandler saveTempFileIntoCacheFolderWithFileName:fileName];
            }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTask:completedSuccessfully:)]) {//不管缓存的是不是整首，都得通知出去
                [self.delegate sessionTask:self completedSuccessfully:[AVPlayer_CachePreference sharedPreference].tmpFilePath];
            }
        }
    }
}

@end
