//
//  AVPlayer_URLSessionTask.h
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/12.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVPlayer_CacheFileHandler.h"
#import <CoreGraphics/CoreGraphics.h>
@class AVPlayer_URLSessionTask;
/*
 说明：负责某一首音频的缓存任务(音频下载)
 */

@protocol AVPlayer_URLSessionTaskDelegate <NSObject>

@required
- (void)sessionTask:(AVPlayer_URLSessionTask *)task didUpdataPartOfCacheDatas:(CGFloat)progress;//请求任务已经更新了部分cache数据
- (void)sessionTask:(AVPlayer_URLSessionTask *)task completedSuccessfully:(NSString *)cacheFilePath; //请求任务已经完成
- (void)sessionTask:(AVPlayer_URLSessionTask *)task didFailed:(NSError *)error; //请求任务已经失败

@end


@interface AVPlayer_URLSessionTask : NSObject

@property (assign, nonatomic) id<AVPlayer_URLSessionTaskDelegate> delegate;

@property (strong, nonatomic) NSURL * requestURL; //请求音频的url
@property (strong, nonatomic) NSMutableData *cacheData;//已缓存data
@property (assign, nonatomic) NSUInteger responseCacheLength; //已缓冲的长度
@property (nonatomic, assign) long long fileLength; //待缓存音频文件的总长度


/**
 开始缓存任务
 */
- (void)start;

/**
 取消缓存任务
 */
- (void)cancel;

@end
