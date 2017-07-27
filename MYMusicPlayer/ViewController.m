//
//  ViewController.m
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/11.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "ViewController.h"
#import "AVPlayer_Plus.h"
#import <MediaPlayer/MediaPlayer.h>

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *playBtn;//播放按钮
@property (weak, nonatomic) IBOutlet UISlider *sliderBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.player.playListArray = @[
                                       [NSURL URLWithString:@"http://download.lingyongqian.cn/music/AdagioSostenuto.mp3"],
                                      [NSURL URLWithString:@"http://fjdx.sc.chinaz.com/Files/DownLoad/sound1/201707/8930.mp3"],
                                     [NSURL URLWithString:@"http://fjdx.sc.chinaz.com/Files/DownLoad/sound1/201707/8927.mp3"],
                                  ];//设置播放列表
    self.playBtn.userInteractionEnabled = NO;
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - AVPlayer_PlusDelegate

- (void)player:(AVPlayer_Plus *)player playerSateDidChanged:(AVPlayerStatus)playerStatus{
    //TODO: 获取当前播放器状态
    if(playerStatus == AVPlayerStatusReadyToPlay){
        [self onClickButton:_playBtn];//开始播放
        self.playBtn.userInteractionEnabled = YES;
    }
}

- (void)player:(AVPlayer_Plus *)player playingSateDidChanged:(BOOL)isPlaying{
    //TODO: 监听当前播放状态改变
    [_playBtn setTitle:isPlaying == YES ? @"暂停": @"播放" forState:UIControlStateNormal];
}

- (void)player:(AVPlayer_Plus *)player playerIsPlaying:(NSTimeInterval)currentTime restTime:(NSTimeInterval)restTime progress:(CGFloat)progress{
    //TODO: 获取当前播放进度
    NSLog(@"当前播放时间:%.0f\n剩余播放时间:%.0f\n当前播放进度:%.2f\n总时长为:%.0f", currentTime, restTime, progress, player.duration);
    self.sliderBar.value = progress;
    [self updateLockedScreenMusic];//更新锁屏音乐信息
}

#pragma mark - 事件处理
- (IBAction)onClickButton:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [self.player turnLast];//播放上一首
            break;
        case 1:{
            if(self.player.isPlaying == YES){
                [self.player pause];
            }else{
                [self.player play];
            }
        }
            break;
        case 2:{
            if(self.player.currentMode == AVPlayerPlayModeSingleLoop){
                self.player.currentMode = AVPlayerPlayModeSequenceList;
            }else{
                self.player.currentMode ++;
            }
            
            switch (self.player.currentMode) {
                case AVPlayerPlayModeSingleLoop:
                    [sender setTitle:@"单曲循环" forState:UIControlStateNormal];
                    break;
                case AVPlayerPlayModeOnce:
                    [sender setTitle:@"单曲播放" forState:UIControlStateNormal];
                    break;
                case AVPlayerPlayModeRandomList:
                    [sender setTitle:@"随机播放" forState:UIControlStateNormal];
                    break;
                case AVPlayerPlayModeSequenceList:
                    [sender setTitle:@"顺序播放" forState:UIControlStateNormal];
                    break;
                default:
                    break;
            }
        }
            break;
        case 3:
            [self.player turnNext];//播放下一首
            break;
        default:
            break;
    }
}

- (IBAction)onSliderValueChanged:(UISlider *)sender {
//    self.resourceLoader.seekRequired = YES;
    [self.player seekToProgress:sender.value];
}

- (void)updateLockedScreenMusic{
    //TODO: 锁屏时候的音乐信息更新，建议1秒更新一次
    NSLog(@"当前播放的是第%ld首歌", self.player.currentIndex);//获取当前播放的歌曲，然后，取model数据，填充播放信息中心内容
    // 播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    
    // 初始化播放信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 专辑名称
    info[MPMediaItemPropertyAlbumTitle] = @"啊啊啊";
    // 歌手
    info[MPMediaItemPropertyArtist] = @"哈哈哈";
    // 歌曲名称
    info[MPMediaItemPropertyTitle] = @"呵呵呵";
    // 设置图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"Icon-58"]];
    // 设置持续时间（歌曲的总时间）
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.player.currentItem duration])] forKey:MPMediaItemPropertyPlaybackDuration];
    // 设置当前播放进度
    [info setObject:[NSNumber numberWithFloat:CMTimeGetSeconds([self.player.currentItem currentTime])] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    // 切换播放信息
    center.nowPlayingInfo = info;
}

@end
