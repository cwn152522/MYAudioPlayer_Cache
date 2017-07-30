//
//  ViewController.m
//  AVplayerDemo
//
//  Created by 陈伟南 on 2017/7/30.
//  Copyright © 2017年 陈伟南. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController


#pragma mark  - <**************** 页面生命周期 ****************>

- (void)viewDidLoad {
    [super viewDidLoad];
    self.player.playListArray = @[[NSURL URLWithString:@"http://download.lingyongqian.cn/music/AdagioSostenuto.mp3"]];
    
    [self.player play];
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark  - <**************** 代理事件处理 ****************>

#pragma mark AVPlayer_PlusDelegate

- (void)player:(AVPlayer_Plus *)player playerIsPlaying:(NSTimeInterval)currentTime restTime:(NSTimeInterval)restTime progress:(CGFloat)progress{
    //TODO: 播放进度监听
    [self updateLockedScreenMusic];
}


#pragma mark  - <**************** 其他事件处理 ****************>

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

- (void)didReceiveMemoryWarning {
    //TODO: 内存警告处理
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
