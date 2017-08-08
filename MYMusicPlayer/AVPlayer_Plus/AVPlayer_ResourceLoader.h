//
//  AVPlayer_ResourceLoader.h
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/12.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "AVPlayer_URLSessionTask.h"

@class AVPlayer_ResourceLoader;
@protocol AVPlayer_ResourceLoaderDelegate <NSObject>

@optional
- (void)loader:(AVPlayer_ResourceLoader *)loader isLoading:(CGFloat)progress;//将缓存的进度传递出去
- (void)loader:(AVPlayer_ResourceLoader *)loader failLoadingWithError:(NSError *)error;

@end


@interface AVPlayer_ResourceLoader : NSObject

@property (nonatomic, weak) id<AVPlayer_ResourceLoaderDelegate> delegate;

/**
 缓存某个音频url(整首缓存)
 
 @param url 音频地址
 */
- (void)cacheUrl:(NSURL *)url;

/**
 取消当前缓存任务
 */
- (void)stopLoading;

@end
