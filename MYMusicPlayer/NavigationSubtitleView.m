//
//  NavigationSubtitleView.m
//  GuDaShi
//
//  Created by 伟南 陈 on 2017/4/10.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import "NavigationSubtitleView.h"
#import "UIView+CWNView.h"

@interface NavigationSubtitleView ()

@property (strong, nonatomic) UILabel *subTitleLabel;

@end

@implementation NavigationSubtitleView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        [self addSubview:self.subTitleLabel];
        [self.subTitleLabel setLayoutCenterX:self];
        [self.subTitleLabel setLayoutBottomFromSuperViewWithConstant:4];
    }
    return self;
}

- (void)setSubTitle:(NSString *)subTitle{
    _subTitle = subTitle;
    [self.subTitleLabel setText:subTitle];
}

- (void)zhongJianLableSheZhiLable:(NSString *)lable withZiShiYing:(BOOL)ZiShiYing withFont:(float)font{
    [super.zHongJianlable cwn_makeConstraints:^(UIView *maker) {
        maker.centerXtoSuper(0).topToSuper(10).bottomToSuper(0);
    }];
    
    super.zHongJianlable.adjustsFontSizeToFitWidth=ZiShiYing;
    super.zHongJianlable.textAlignment=NSTextAlignmentCenter;
    super.zHongJianlable.font=[UIFont systemFontOfSize:font];
    super.zHongJianlable.text=lable;
    super.zHongJianlable.textColor=[UIColor whiteColor];
    
}


#pragma mark 控件get方法

- (UILabel *)subTitleLabel{
    if(_subTitleLabel == nil){
        _subTitleLabel = [[UILabel alloc] init];
        [_subTitleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        _subTitleLabel.font = [UIFont systemFontOfSize:11];
        [_subTitleLabel setTextColor:[UIColor whiteColor]];
    }
    return _subTitleLabel;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
