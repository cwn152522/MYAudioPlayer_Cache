//
//  AVPlyar_ViewController.m
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/12.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "AVPlayer_BaseViewController.h"
#import "AVPlayer_ResourceLoader.h"

@interface AVPlayer_BaseViewController ()

@end

@implementation AVPlayer_BaseViewController

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPlayer];
    // Do any additional setup after loading the view.
}

- (void)initPlayer{
    self.player = [[AVPlayer_Plus alloc] init];
    self.player.delegate = self;
    
    //接收后台音频播放器的远程控制
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 远程控制事件处理

- (void)remoteControlReceivedWithEvent:(UIEvent *)receivedEvent {
    //TODO: 响应远程音乐播放控制消息
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause:{
                [self.player pause];
            }
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self.player turnNext];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self.player turnLast];
                break;
            case UIEventSubtypeRemoteControlPause:{
                [self.player pause];
            }
                break;
            case UIEventSubtypeRemoteControlPlay:{
                [self.player play];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark - AVPlayer_PlusDelegate

- (void)player:(AVPlayer_Plus *)player willPlayUrl:(NSURL *)music_url withResponse:(void (^)(AVURLAsset *asset, NSURL *fileUrl))response{
    if([[music_url absoluteString] hasPrefix:@"http"]){//网络音频，判断本地缓存
        NSString * cacheFilePath = [AVPlayer_CacheFileHandler cacheFileExistsWithURL:music_url];
        if ([cacheFilePath length] > 0) {//有本地缓存
            NSURL *fileUrl = [NSURL fileURLWithPath:cacheFilePath];
            response(nil, fileUrl);
        }else{//无本地缓存
            self.resourceLoader = [[AVPlayer_ResourceLoader alloc]init];
//            self.resourceLoader.delegate = self;
            AVURLAsset * asset = [AVURLAsset URLAssetWithURL:[music_url customSchemeURL] options:nil];
            [asset.resourceLoader setDelegate:self.resourceLoader queue:dispatch_get_main_queue()];
            response(asset, nil);
        }
    }else{//非网络音频，直接加载
        response(nil, nil);
    }
}

//#pragma mark - AVPlayer_ResourceLoaderDelegate



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
