//
//  AVPlayer_URLSessionTask.h
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/12.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVPlayer_CacheFileHandler.h"
@class AVPlayer_URLSessionTask;
/*
 说明：负责某一首音频的缓存任务(音频下载)
 */

@protocol AVPlayer_URLSessionTaskDelegate <NSObject>

@required
- (void)sessionTask:(AVPlayer_URLSessionTask *)task didUpdataPartOfCacheDatas:(NSString *)tmpFilePath;//请求任务已经更新了部分cache数据，通知外界可以来取最新的cache数据了
- (void)sessionTask:(AVPlayer_URLSessionTask *)task completedSuccessfully:(NSString *)cacheFilePath; //请求任务已经完成，注意，完成的不一定是整音乐，可能是拖拽后某个位置到结束的音乐
- (void)sessionTask:(AVPlayer_URLSessionTask *)task didFailed:(NSError *)error; //请求任务已经失败(已经将缓存文件存到了缓存目录)

@end


@interface AVPlayer_URLSessionTask : NSObject

@property (assign, nonatomic) id<AVPlayer_URLSessionTaskDelegate> delegate;

@property (strong, nonatomic) NSURL * requestURL; //请求音频的url
@property (assign, nonatomic) NSUInteger requestOffset; //请求缓冲的起始位置(比如拖拽到0.5进度的字节位置)，那就应该从那个地方开始缓存
@property (assign, nonatomic) NSUInteger responseCacheLength; //已缓冲的长度
@property (nonatomic, assign) NSUInteger fileLength; //待缓存音频文件的总长度
@property (nonatomic, assign) BOOL canCache; //是否允许缓存文件


/**
 开始缓存任务
 */
- (void)start;

/**
 取消缓存任务
 */
- (void)cancel;

@end
