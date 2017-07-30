//
//  AVPlayer_PlayListTableViewCell.m
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/28.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "AVPlayer_PlayListTableViewCell.h"

@implementation AVPlayer_PlayListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)startAnimation{
    [self.isPlayImage startAnimation];
}

@end
