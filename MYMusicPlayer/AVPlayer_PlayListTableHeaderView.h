//
//  AVPlayer_PlayListTableHeaderView.h
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/28.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AVPlayer_Define.h"

@protocol AVPlayer_PlayListTableHeaderViewDelegate <NSObject>

- (void)playListHeaderView_didSelectRecycleType:(AVPlayerPlayMode)playMode;

@end

@interface AVPlayer_PlayListTableHeaderView : UIView

@property (assign, nonatomic) id <AVPlayer_PlayListTableHeaderViewDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *recyleStyleLabel;//循环方式文本
@property (weak, nonatomic) IBOutlet UIImageView *recycleStyleImage;//循环方式图片

@end
