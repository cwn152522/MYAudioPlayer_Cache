//
//  AVPlayer_PlayListViewController.h
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/28.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MYVisualEffectView.h"
#import "MusicModel.h"
#import "AVPlayer_Plus/AVPlayer_Plus.h"
@class AVPlayer_PlayListViewController;
@protocol AVPlayer_PlayListDelegate;


/**
 播放器列表页
 */
@interface AVPlayer_PlayListViewController : UIViewController

@property (strong, nonatomic) NSMutableArray <MusicModel *> *data;
@property (assign, nonatomic) id<AVPlayer_PlayListDelegate> delegate;

- (void)musicWillStartToPlay:(NSInteger)index;//某首音乐即将播放通知，接收到后修改列表播放状态

@end






@protocol AVPlayer_PlayListDelegate <NSObject>

- (void)playList_onClickClose;
- (void)playList_didSelectRecycleType:(AVPlayerPlayMode)playMode;
- (void)playList:(AVPlayer_PlayListViewController *)playList didSelectItem:(MusicModel *)model atRow:(NSInteger)row;

@end
