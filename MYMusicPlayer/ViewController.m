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
#import "AVPlayer_PlayListViewController.h"
#import "UIView+CWNView.h"
#import "NavigationSubtitleView.h"

@interface ViewController ()<AVPlayer_PlayListDelegate>

@property (strong, nonatomic) NavigationSubtitleView *navigationView;

@property (weak, nonatomic) IBOutlet UIButton *playBtn;//播放按钮
@property (weak, nonatomic) IBOutlet UIButton *listBtn;//播放列表按钮

@property (weak, nonatomic) IBOutlet UISlider *sliderBar;
@property (weak, nonatomic) IBOutlet UILabel *timeLeft;//时间左边文本
@property (weak, nonatomic) IBOutlet UILabel *timeRight;//时间右边文本

@property (strong, nonatomic) AVPlayer_PlayListViewController *playListVC;//播放列表
@property (strong, nonatomic) NSLayoutConstraint *playListTop;//播放列表顶部距离self.view底部距离，默认为0,即播放列表隐藏，需要显示的时候设为-播放列表的高度即可

@property (strong, nonatomic) NSArray <MusicModel *> *playListArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.playListArray = @[
                           [[MusicModel alloc] initWithDictionary:@{@"music_url":@"http://download.lingyongqian.cn/music/AdagioSostenuto.mp3", @"music_title":@"大盘急跌，贪婪与恐惧的较量", @"music_album":@"龙虎榜揭秘", @"musc_singer":@"林炜"}],
                                  [[MusicModel alloc] initWithDictionary:@{@"music_url":@"http://fjdx.sc.chinaz.com/Files/DownLoad/sound1/201707/8930.mp3", @"music_title":@"如何利用股东人数搭上机构顺风...", @"music_album":@"早间财经内线", @"musc_singer":@"林炜"}],
                                  [[MusicModel alloc] initWithDictionary:@{@"music_url":@"http://fjdx.sc.chinaz.com/Files/DownLoad/sound1/201707/8927.mp3", @"music_title":@"急跌放量捡红包", @"music_album":@"盘口摩丝密码", @"musc_singer":@"林炜"}],
                                  ];//设置播放列表
    NSMutableArray *array = [NSMutableArray array];
    [self.playListArray enumerateObjectsUsingBlock:^(MusicModel * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [array addObject:[NSURL URLWithString:obj.music_url]];
    }];
    self.player.playListArray = [array mutableCopy];
    self.playListVC.data =  [self.playListArray mutableCopy];
    
    
    self.playBtn.userInteractionEnabled = NO;
    [self.sliderBar setThumbImage:[UIImage imageNamed:@"sliderTracing"] forState:UIControlStateNormal];
    
    [self.sliderBar addTarget:self action:@selector(onSliderTouchedDown) forControlEvents:UIControlEventTouchDown];
    [self.sliderBar addTarget:self action:@selector(onSliderTouchedUp) forControlEvents:UIControlEventTouchUpInside];
    
    [self configNavigationView];
    [self configPlayList];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)configNavigationView{
    _navigationView=[[NavigationSubtitleView alloc]initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 64)];
    _navigationView.delegate=self;
    _navigationView.backgroundColor=[UIColor colorWithRed:201/255.0 green:8/255.0 blue:19/255.0 alpha:1];
    [_navigationView leftBtnSheZhiImage:@"zhiboLeft" withHidden:NO withfloatX:5 withfloatY:15 withWidth:70 withHeight:30];
    _navigationView.backgroundColor = [UIColor clearColor];
    [_navigationView zhongJianLableSheZhiLable:@"" withZiShiYing:NO withFont:17 withfloatX:([UIScreen mainScreen].bounds.size.width/2)-60 withfloatY:30 withWidth:120 withHeight:20];
    [self.view addSubview:_navigationView];
}

- (void)configPlayList{
    [self.view addSubview:self.playListVC.view];
    [self addChildViewController:self.playListVC];
    __weak typeof(self) weakSelf = self;
    
    [self.playListVC.view cwn_makeConstraints:^(UIView *maker) {
        weakSelf.playListTop = [maker.leftToSuper(0).rightToSuper(0).height(CGRectGetMaxY([UIScreen mainScreen].bounds) * 2  / 3).topTo(weakSelf.view, 1, 0) lastConstraint];
    }];
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
        [self.navigationView.zHongJianlable setText:[self.playListArray[self.player.currentIndex] music_title]];
        self.navigationView.subTitle = [self.playListArray[self.player.currentIndex] musc_singer];
        [self.playListVC musicWillStartToPlay:self.player.currentIndex];
    }
}

- (void)player:(AVPlayer_Plus *)player playingSateDidChanged:(BOOL)isPlaying{
    //TODO: 监听当前播放状态改变
//    [_playBtn setTitle:isPlaying == YES ? @"暂停": @"播放" forState:UIControlStateNormal];
    [_playBtn setSelected:isPlaying];
}

- (void)player:(AVPlayer_Plus *)player playerIsPlaying:(NSTimeInterval)currentTime restTime:(NSTimeInterval)restTime progress:(CGFloat)progress{
    //TODO: 获取当前播放进度
    NSLog(@"当前播放时间:%.0f\n剩余播放时间:%.0f\n当前播放进度:%.2f\n总时长为:%.0f", currentTime, restTime, progress, player.duration);
    self.sliderBar.value = progress;
    [self updateLockedScreenMusic];//更新锁屏音乐信息
}

#pragma mark AVPlayer_PlayListDelegate

- (void)playList_onClickClose{
    [self onClickListBtn:self.listBtn];
}

- (void)playList_didSelectRecycleType:(AVPlayerPlayMode)playMode{
    self.player.currentMode = playMode;
}

- (void)playList:(AVPlayer_PlayListViewController *)playList didSelectItem:(MusicModel *)model atRow:(NSInteger)row{
    [self.player playItem:row];
    [self.navigationView.zHongJianlable setText:model.music_title];
    self.navigationView.subTitle = model.musc_singer;
    [playList musicWillStartToPlay:row];
}

#pragma mark - 事件处理

- (IBAction)onClickButton:(UIButton *)sender {
    switch (sender.tag) {
        case 0:
            [self.player turnLast];//播放上一首
            self.sliderBar.enabled = NO;
            [self.playListVC musicWillStartToPlay:self.player.currentIndex];
            break;
        case 1:{
            if(self.player.isPlaying == YES){
                [self.player pause];
            }else{
                [self.player play];
            }
        }
            break;
        case 3:
            [self.player turnNext];//播放下一首
            self.sliderBar.enabled = NO;
            [self.playListVC musicWillStartToPlay:self.player.currentIndex];
            break;
        default:
            break;
    }
}

- (IBAction)onSliderValueChanged:(UISlider *)sender {
//    self.resourceLoader.seekRequired = YES;
    [self.player seekToProgress:sender.value];
}
- (void)onSliderTouchedDown{
        [self.player pause];
}
- (void)onSliderTouchedUp{
    [self.player play];
}

- (IBAction)onClickListBtn:(UIButton *)sender {
    CGFloat constant = 0;
    if(sender.selected == YES){//收起列表
        
    }else{//弹出列表
        self.playListVC.data =  [self.playListArray mutableCopy];
        constant = -CGRectGetMaxY([UIScreen mainScreen].bounds) * 2  / 3;
    }
    
    __weak typeof(self) weakSelf = self;
    self.playListTop.constant = constant;
    [UIView animateWithDuration:0.33 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [weakSelf.view layoutIfNeeded];
    }completion:^(BOOL finished) {
        
    }];
    
    sender.selected = !sender.selected;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    if(self.playListTop.constant != 0){
        [self onClickListBtn:self.listBtn];
    }
}

- (void)updateLockedScreenMusic{
    //TODO: 锁屏时候的音乐信息更新，建议1秒更新一次
    MusicModel *model = [self.playListArray objectAtIndex:self.player.currentIndex];
    self.sliderBar.enabled = YES;
    
    CGFloat leftSecondsTime = CMTimeGetSeconds([self.player.currentItem currentTime]);
    CGFloat rightSecondsTime = CMTimeGetSeconds([self.player.currentItem duration]);
    
    // 播放信息中心
    MPNowPlayingInfoCenter *center = [MPNowPlayingInfoCenter defaultCenter];
    
    // 初始化播放信息
    NSMutableDictionary *info = [NSMutableDictionary dictionary];
    // 专辑名称
    info[MPMediaItemPropertyAlbumTitle] = model.music_album;
    // 歌手
    info[MPMediaItemPropertyArtist] = model.musc_singer;
    // 歌曲名称
    info[MPMediaItemPropertyTitle] = model.music_title;
    // 设置图片
    info[MPMediaItemPropertyArtwork] = [[MPMediaItemArtwork alloc] initWithImage:[UIImage imageNamed:@"fengmian"]];
    // 设置持续时间（歌曲的总时间）
    [info setObject:[NSNumber numberWithFloat:rightSecondsTime] forKey:MPMediaItemPropertyPlaybackDuration];
    // 设置当前播放进度
    [info setObject:[NSNumber numberWithFloat:leftSecondsTime] forKey:MPNowPlayingInfoPropertyElapsedPlaybackTime];
    
    // 切换播放信息
    center.nowPlayingInfo = info;
    

    [self.timeLeft setText:[NSString stringWithFormat:@"%.2d:%.2d", (int)(leftSecondsTime / 60), ((int)leftSecondsTime % 60)]];
    [self.timeRight setText:[NSString stringWithFormat:@"%.2d:%.2d", (int)(rightSecondsTime / 60), ((int)rightSecondsTime % 60)]];
}

#pragma mark - 控件get方法

- (AVPlayer_PlayListViewController *)playListVC{
    if(!_playListVC){
        _playListVC = [[AVPlayer_PlayListViewController alloc] initWithNibName:@"AVPlayer_PlayListViewController" bundle:nil];
        _playListVC.delegate = self;
    }
    return _playListVC;
}

#pragma mark - 重写父类方法

- (void)player:(AVPlayer_Plus *)player willPlayUrl:(NSURL *)music_url withResponse:(void (^)(AVURLAsset *asset, NSURL *fileUrl))response{
    [super player:player willPlayUrl:music_url withResponse:response];
    [self.playListVC musicWillStartToPlay:player.currentIndex];
    [self.navigationView.zHongJianlable setText:[self.playListArray[player.currentIndex] music_title]];
    self.navigationView.subTitle = [self.playListArray[player.currentIndex] musc_singer];
}

@end
