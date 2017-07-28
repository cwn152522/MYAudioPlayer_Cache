//
//  MusicModel.m
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/28.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "MusicModel.h"

@implementation MusicModel

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if (self  = [super initWithDictionary:dic]) {
        [self setParam:@"music_url" ofDic:dic];
        [self setParam:@"music_title" ofDic:dic];
        [self setParam:@"music_album" ofDic:dic];
        [self setParam:@"musc_singer" ofDic:dic];
    }
    return self;
}

@end
