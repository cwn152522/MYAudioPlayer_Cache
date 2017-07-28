//
//  AVPlayer_PlayListTableViewCell.h
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/28.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AVPlayer_PlayListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//音乐名称
@property (weak, nonatomic) IBOutlet UIImageView *isPlayImage;//正在播放图片

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nameLabelLeft;//音乐名称label左边约束，默认为-14，如果正在播放，需显示正在播放图片，并且把此约束设为5

@end
