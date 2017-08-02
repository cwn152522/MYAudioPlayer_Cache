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

@end

@implementation AVPlayer_URLSessionTask

- (instancetype)init{
    if(self = [super init]){
        [AVPlayer_CacheFileHandler createTempFile];
        self.cacheData = [NSMutableData data];
    }
    return self;
}

#pragma mark - 任务

- (void)start{
    //TODO: 开始执行缓存任务
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:[self.requestURL originalSchemeURL] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:10.0];
    
    self.session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration] delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    self.task = [self.session dataTaskWithRequest:request];
    [self.task resume];
}

- (void)cancel{
    //TODO: 取消缓存任务
    [self.task cancel];
    [self.session invalidateAndCancel];
}

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveResponse:(NSURLResponse *)response completionHandler:(void (^)(NSURLSessionResponseDisposition))completionHandler{
    //TODO: 请求接收到服务器响应
    completionHandler(NSURLSessionResponseAllow);
    NSHTTPURLResponse * httpResponse = (NSHTTPURLResponse *)response;
    NSString * contentRange = [[httpResponse allHeaderFields] objectForKey:@"Content-Range"];
    NSString * fileLength = [[contentRange componentsSeparatedByString:@"/"] lastObject];
    self.fileLength = fileLength.integerValue > 0 ? fileLength.integerValue : response.expectedContentLength;
    
    [AVPlayer_CacheFileHandler createTempFile];
    self.responseCacheLength = 0;
    self.cacheData = [NSMutableData data];
}

- (void)URLSession:(NSURLSession *)session dataTask:(NSURLSessionDataTask *)dataTask didReceiveData:(NSData *)data{
    //TODO: 服务器返回数据，可能会调用多次
    self.responseCacheLength += data.length;
    [self.cacheData appendData:data];
    NSLog(@"总字节数：%ld, 已缓存字节数：%ld", self.fileLength, self.responseCacheLength);
    if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTask:didUpdataPartOfCacheDatas:)]) {
        [self.delegate sessionTask:self didUpdataPartOfCacheDatas:1.0 * self.responseCacheLength / self.fileLength];
    }
}

//请求完成会调用该方法，请求失败则error有值
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task didCompleteWithError:(NSError *)error {
        if (error) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTask:didFailed:)]) {
                [self.delegate sessionTask:self didFailed:error];
                [AVPlayer_CacheFileHandler createTempFile];
            }
        }else {//请求成功
            [AVPlayer_CacheFileHandler writeTempFileData:self.cacheData];
            NSString *fileName = [[self.requestURL.absoluteString componentsSeparatedByString:@"/"] lastObject];
            [AVPlayer_CacheFileHandler saveTempFileIntoCacheFolderWithFileName:fileName];
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(sessionTask:completedSuccessfully:)]) {//不管缓存的是不是整首，都得通知出去
                [self.delegate sessionTask:self completedSuccessfully:[AVPlayer_CachePreference sharedPreference].tmpFilePath];
            }
        }
}

@end
