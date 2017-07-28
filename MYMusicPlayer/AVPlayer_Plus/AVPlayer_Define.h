//
//  AVPlayer_Define.h
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/28.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#ifndef AVPlayer_Define_h
#define AVPlayer_Define_h

typedef NS_ENUM(NSInteger, AVPlayerPlayMode) {
    AVPlayerPlayModeSequenceList,//顺序播放，列表循环
    AVPlayerPlayModeRandomList,//随机播放
    AVPlayerPlayModeOnce, //单曲播放，播完结束
    AVPlayerPlayModeSingleLoop//单曲循环
};


#endif /* AVPlayer_Define_h */
