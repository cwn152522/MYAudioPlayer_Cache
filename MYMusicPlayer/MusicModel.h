//
//  MusicModel.h
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/28.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MYBaseJsonModel.h"

@interface MusicModel : MYBaseJsonModel

@property (strong, nonatomic) NSString *music_url;//音乐路径
@property (strong, nonatomic) NSString *music_title;//音乐标题
@property (strong, nonatomic) NSString *music_album;//专辑名称
@property (strong, nonatomic) NSString *musc_singer;//歌手名称

@property (assign, nonatomic) BOOL isPlaying;//是否播放中

@end
