//
//  MYVIsualEffectView.m
//  MYDaPanSingalView
//
//  Created by 伟南 陈 on 2017/6/26.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "MYVisualEffectView.h"
#import "UIView+CWNView.h"

@interface MYVisualEffectView ()

@property (strong, nonatomic) UIVisualEffectView *effectView;
@property (strong, nonatomic) UIImageView *centerImage;

@end

@implementation MYVisualEffectView

- (instancetype)initWithFrame:(CGRect)frame{
    if(self = [super initWithFrame:frame]){
        
        [self addSubview:self.effectView];
        [self addSubview:self.centerImage];
        
        [self.effectView cwn_makeConstraints:^(UIView *maker) {
            maker.leftToSuper(0).topToSuper(0).rightToSuper(0).bottomToSuper(0);
        }];
        
        [self.centerImage cwn_makeConstraints:^(UIView *maker) {
            maker.centerXtoSuper(0).centerYtoSuper(0);
        }];

        self.userInteractionEnabled = YES;
        self.centerImage.userInteractionEnabled = NO;
        self.effectView.userInteractionEnabled = NO;
        self.centerImage.hidden = YES;
        [self addTarget:self action:@selector(onClickEffectView1) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [self addSubview:self.effectView];
        [self addSubview:self.centerImage];
        
        [self.effectView cwn_makeConstraints:^(UIView *maker) {
            maker.leftToSuper(0).topToSuper(0).rightToSuper(0).bottomToSuper(0);
        }];
        
        [self.centerImage cwn_makeConstraints:^(UIView *maker) {
            maker.centerXtoSuper(0).centerYtoSuper(0);
        }];
        
        self.userInteractionEnabled = YES;
        self.centerImage.userInteractionEnabled = NO;
        self.effectView.userInteractionEnabled = NO;
        self.centerImage.hidden = YES;
        [self addTarget:self action:@selector(onClickEffectView1) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)onClickEffectView1{
    if([self.delegate respondsToSelector:@selector(onclickEffectView)]){
        [self.delegate onclickEffectView];
    }
}

#pragma mark - 控件get方法

- (UIVisualEffectView *)effectView{
    if(!_effectView){
        UIBlurEffect *blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight ];
        _effectView = [[UIVisualEffectView alloc] initWithEffect:blur];
    }
    return _effectView;
}

- (UIImageView *)centerImage{
    if(!_centerImage){
        _centerImage = [[UIImageView alloc] init];
        _centerImage.image = [UIImage imageNamed:@"redSuo"];
    }
    return _centerImage;
}

- (void)setCenterBtnHidden:(BOOL)centerBtnHidden{
    _centerImage.hidden = centerBtnHidden;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
