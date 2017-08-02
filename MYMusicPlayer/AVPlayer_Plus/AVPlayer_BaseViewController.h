//
//  AVPlyar_ViewController.h
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/12.
//  Copyright © 2017年 chenweinan. All rights reserved.
//
/*
 说明：拓展了AVPlayer_Plus的缓存功能。作为基类，本类实现了带缓存播放的播放器，并实现了音频的后台远程控制(锁屏下播放器的事件)，即AVPlayer_Plus头文件说明中所提的前2点，第3点需要子类具体去实现
 */

#import <UIKit/UIKit.h>
#import "AVPlayer_Plus.h"
#import "AVPlayer_ResourceLoader.h"

@interface AVPlayer_BaseViewController : UIViewController<AVPlayer_PlusDelegate, AVPlayer_ResourceLoaderDelegate>

/**
 拓展版的avplayer播放器，支持播放控制(播放、暂停、上下首、循环模式等)、播放进度监听等。
 */
@property (strong, nonatomic) AVPlayer_Plus *player;

/**
 avplayer数据流加载对象
 */
@property (strong, nonatomic) AVPlayer_ResourceLoader *resourceLoader;

- (void)player:(AVPlayer_Plus *)player willPlayUrl:(NSURL *)music_url withResponse:(void (^)(AVURLAsset *asset, NSURL *fileUrl))response;//当子类需要在音乐切换时做操作时，如：更新播放列表ui，可重写此方法，记得先调用[super player:willPlayUrl:withResponse:]

@end
