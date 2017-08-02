//
//  AVPlayer_ResourceLoader.m
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/12.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "AVPlayer_ResourceLoader.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface AVPlayer_ResourceLoader ()<AVPlayer_URLSessionTaskDelegate>

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
    if(self.requestTask == nil){
        self.requestTask = [[AVPlayer_URLSessionTask alloc] init];
        self.requestTask.delegate = self;
    }else{
        [self stopLoading];//取消缓存任务
    }
    self.requestTask.requestURL = url;
    [self.requestTask start];//开启缓存任务
}

#pragma mark  - AVPlayer_URLSessionTaskDelegate

- (void)sessionTask:(AVPlayer_URLSessionTask *)task didUpdataPartOfCacheDatas:(CGFloat)progress{//请求任务已经更新了部分cache数据
    if([self.delegate respondsToSelector:@selector(loader:isLoading:)]){
        [self.delegate loader:self isLoading:progress];
    }
}

- (void)sessionTask:(AVPlayer_URLSessionTask *)task completedSuccessfully:(NSString *)cacheFilePath{ //请求任务已经完成
}

- (void)sessionTask:(AVPlayer_URLSessionTask *)task didFailed:(NSError *)error{ //请求任务已经失败
    if([self.delegate respondsToSelector:@selector(loader:failLoadingWithError:)]){
        [self.delegate loader:self failLoadingWithError:error];
    }
}

@end
