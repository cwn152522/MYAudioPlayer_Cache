//
//  AVPlayer_PlayListTableHeaderView.m
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/28.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "AVPlayer_PlayListTableHeaderView.h"

@interface AVPlayer_PlayListTableHeaderView ()

@property (assign, nonatomic) AVPlayerPlayMode current_playMode;

@end

@implementation AVPlayer_PlayListTableHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

- (IBAction)onClickRecycleStyle:(UIControl *)sender {
    AVPlayerPlayMode nextMode = [self getNextRecycleStyle];
    switch (nextMode) {
        case AVPlayerPlayModeSequenceList:
            [self.recyleStyleLabel setText:@"顺序播放"];
            [self.recycleStyleImage setImage:[UIImage imageNamed:@"guping_shunxubofang"]];
            break;
        case AVPlayerPlayModeRandomList:
            [self.recyleStyleLabel setText:@"随机播放"];
            [self.recycleStyleImage setImage:[UIImage imageNamed:@"guping_suijibofang"]];
            break;
        case AVPlayerPlayModeSingleLoop:
            [self.recyleStyleLabel setText:@"单曲循环"];
            [self.recycleStyleImage setImage:[UIImage imageNamed:@"guping_danquxunhuan"]];
            break;
        default:
            break;
    }
    
    if([self.delegate respondsToSelector:@selector(playListHeaderView_didSelectRecycleType:)]){
        [self.delegate playListHeaderView_didSelectRecycleType:nextMode];
    }
    
    self.current_playMode = nextMode;
}

- (AVPlayerPlayMode)getNextRecycleStyle{
    AVPlayerPlayMode nextMode = AVPlayerPlayModeSequenceList;//顺序播放
    switch (self.current_playMode) {
        case AVPlayerPlayModeSequenceList:{
            nextMode = AVPlayerPlayModeRandomList;//随机播放
        }
            break;
        case AVPlayerPlayModeRandomList:{
            nextMode = AVPlayerPlayModeSingleLoop;//单曲循环
        }
            break;
        case AVPlayerPlayModeSingleLoop:{
            nextMode = AVPlayerPlayModeSequenceList;//顺序播放
        }
            break;
            
        default:
            break;
    }
    return nextMode;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
