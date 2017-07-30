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
#import "AVPlayer_Define.h"
@class AVPlayer_PlayListViewController;


/**
 暂时先做固定播放列表封装，后面应该通过类似列表数据源、代理的方式来实现
 */
@protocol AVPlayer_PlayListDelegate <NSObject>

- (void)playList_onClickClose;
- (void)playList_didSelectRecycleType:(AVPlayerPlayMode)playMode;
- (void)playList:(AVPlayer_PlayListViewController *)playList didSelectItem:(MusicModel *)model atRow:(NSInteger)row;

@end

@interface AVPlayer_PlayListViewController : UIViewController

@property (strong, nonatomic) NSMutableArray <MusicModel *> *data;
@property (assign, nonatomic) id<AVPlayer_PlayListDelegate> delegate;

- (void)musicWillStartToPlay:(NSInteger)index;//某首音乐即将播放通知，接收到后修改列表播放状态

@end
