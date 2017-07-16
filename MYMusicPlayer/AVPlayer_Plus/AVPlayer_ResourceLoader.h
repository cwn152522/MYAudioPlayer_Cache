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
/*
 说明：提供avplayer播放过程中的缓冲数据获取。注意，(1)如果音乐开始播放，并且没有拖拽过，就将缓存结束的整个完整音频文件本地化到缓存目录，下一次没有网络，就直接载本地音频了。(2)本类目前只对应一首音乐的缓存处理，也就是说，在音乐切换之后，本类实例记得注销，重新创建。
 */

@class AVPlayer_ResourceLoader;
@protocol AVPlayer_ResourceLoaderDelegate <NSObject>

@required
- (void)loader:(AVPlayer_ResourceLoader *)loader cacheProgress:(CGFloat)progress;//将缓存的进度传递出去

@optional
- (void)loader:(AVPlayer_ResourceLoader *)loader failLoadingWithError:(NSError *)error;

@end


@interface AVPlayer_ResourceLoader : NSObject<AVAssetResourceLoaderDelegate, AVPlayer_URLSessionTaskDelegate>

@property (nonatomic, weak) id<AVPlayer_ResourceLoaderDelegate> delegate;
@property (atomic, assign) BOOL seekRequired; //Seek标识，如果用户拖拽过，设为yes
@property (atomic, assign) BOOL cacheFinished;//缓存结束

/**
 停止加载
 */
- (void)stopLoading;

@end
