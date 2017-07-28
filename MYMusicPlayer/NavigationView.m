//
//  NavigationView.m
//  GuDaShi
//
//  Created by songzhaojie on 17/1/12.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import "NavigationView.h"
#import "UIView+CWNView.h"
//#import "GuDaShiHeader.h"
//#import "UIImage+ImageEffects.h"

#define ShiPei(a)  [UIScreen mainScreen].bounds.size.width/375.0*(a)

@implementation NavigationView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        
        _leftBtn=[MYImageButton buttonWithType:UIButtonTypeCustom];
        
        [_leftBtn addTarget:self action:@selector(Leftbtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBtn];
        _zHongJianlable=[[UILabel alloc]init];
        [self addSubview:_zHongJianlable];
        _reghtBtn=[MYImageButton buttonWithType:UIButtonTypeCustom];
        [_reghtBtn addTarget:self action:@selector(reghtBtn1) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_reghtBtn];

    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    self=[super initWithFrame:frame];
    if (self){
        
        _leftBtn=[MYImageButton buttonWithType:UIButtonTypeCustom];
        
        [_leftBtn addTarget:self action:@selector(Leftbtn) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftBtn];
        _zHongJianlable=[[UILabel alloc]init];
        [self addSubview:_zHongJianlable];
        _reghtBtn=[MYImageButton buttonWithType:UIButtonTypeCustom];
        [_reghtBtn addTarget:self action:@selector(reghtBtn1) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_reghtBtn];
    }
    
    return self;
}







-(void)setTitle:(NSString *)title leftBtnImage:(NSString *)leftImg rightBtnImage:(NSString *)rightImg{
    if (title&&title.length) {
        [self zhongJianLableSheZhiLable:title withZiShiYing:NO withFont:17.0];
        NSArray *titles = [title componentsSeparatedByString:@","];
        if (titles.count==2) {
            NSMutableAttributedString *string1 = [[NSMutableAttributedString alloc] initWithString:titles.firstObject
                                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
            NSMutableAttributedString *string2 = [[NSMutableAttributedString alloc] initWithString:titles.lastObject
                                                                                        attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:10.0],NSForegroundColorAttributeName:[UIColor whiteColor]}];
            NSMutableAttributedString *tmp = [[NSMutableAttributedString alloc] initWithString:@"\n"];
            [string1 appendAttributedString:tmp];
            [string1 appendAttributedString:string2];
            _zHongJianlable.attributedText = string1;
        }
    }
    
    if (leftImg&&leftImg.length) {
        [self leftBtnSheZhiImage:leftImg withHidden:NO];
    }
    
    if (rightImg&&rightImg.length) {
        [self reghtBtnSheZhiImage:rightImg withText:nil withHidden:NO];
    }
}




-(void)setSegmentItems:(NSArray<NSString *> *)titles{
    
    [self zhongJianSegmentSheZhiSegmentItems:titles withFont:17.0];
}

















- (void)leftBtnSheZhiImage:(NSString *)image withHidden:(BOOL)hidded{
    UIImage *imageView = [UIImage imageNamed:image];
    //    _leftBtn.frame=CGRectMake(floatX, floatY, width, height);
    [_leftBtn cwn_makeConstraints:^(UIView *maker) {
        maker.leftToSuper(2.5).topToSuper(20).bottomToSuper(0).width(100);
    }];
    
    if(self.leftImageSizeLimited.width > 0){
        _leftBtn.imageBounds=CGRectMake(10, (self.frame.size.height - 20) / 2 - self.leftImageSizeLimited.height / 2,  self.leftImageSizeLimited.width, self.leftImageSizeLimited.height);
    }else{
        _leftBtn.imageBounds=CGRectMake(10, (self.frame.size.height - 20) / 2 - imageView.size.height / 2,  imageView.size.width, imageView.size.height);
    }
    [_leftBtn setImage:imageView forState:UIControlStateNormal];
    
    _leftBtn.hidden=hidded;
}
-(void)leftBtnSheZhiImage:(NSString *)image withHidden:(BOOL)hidded withfloatX:(float)floatX withfloatY:(float)floatY withWidth:(float)width withHeight:(float)height
{
    [self leftBtnSheZhiImage:image withHidden:hidded];
}

- (void)zhongJianLableSheZhiLable:(NSString *)lable withZiShiYing:(BOOL)ZiShiYing withFont:(float)font{
    [_zHongJianlable cwn_makeConstraints:^(UIView *maker) {
        maker.centerXtoSuper(0).topToSuper(20).bottomToSuper(0);
    }];
    
    _zHongJianlable.adjustsFontSizeToFitWidth=ZiShiYing;
    _zHongJianlable.textAlignment=NSTextAlignmentCenter;
    _zHongJianlable.font=[UIFont systemFontOfSize:font];
    _zHongJianlable.text=lable;
    _zHongJianlable.textColor=[UIColor whiteColor];
    _zHongJianlable.numberOfLines = 0;

}
-(void)zhongJianLableSheZhiLable:(NSString *)lable withZiShiYing:(BOOL)ZiShiYing  withFont:(float)font withfloatX:(float)floatX withfloatY:(float)floatY withWidth:(float)width withHeight:(float)height
{
    [self zhongJianLableSheZhiLable:lable withZiShiYing:ZiShiYing withFont:font];
}

- (void)zhongJianSegmentSheZhiSegmentItems:(NSArray<NSString *> *)titles withFont:(float)font{
    if([titles count] == 0)
        return;
    
    static NSLayoutConstraint *segmentWidth =nil;
    
    if(_zHongJianSegment == nil){
        _zHongJianSegment = [[UISegmentedControl alloc] init];
        _zHongJianSegment.tintColor = [UIColor whiteColor];
        [_zHongJianSegment addTarget:self action:@selector(onClickSegmentControl:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_zHongJianSegment];
        [_zHongJianSegment cwn_makeConstraints:^(UIView *maker) {
          segmentWidth =  maker.bottomToSuper(8).centerXtoSuper(0).height(30).width(ShiPei(140)).lastConstraint;
        }];
    }
    
    __weak typeof(self) weakSelf = self;
    [titles enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [weakSelf.zHongJianSegment insertSegmentWithTitle:obj atIndex:idx animated:NO];
    }];
    
    segmentWidth.constant = ShiPei(70) * [titles count];
    
    _zHongJianSegment.selectedSegmentIndex = 0;
}

- (void)reghtBtnSheZhiImage:(NSString *)image withText:(NSString *)text withHidden:(BOOL)hidded{
    [_reghtBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    _reghtBtn.titleLabel.font=[UIFont systemFontOfSize:15];
    _reghtBtn.titleLabel.textColor=[UIColor whiteColor];
    
    [_reghtBtn cwn_makeConstraints:^(UIView *maker) {
        maker.rightToSuper(2.5).topToSuper(20).bottomToSuper(0).width(100);
    }];
    
    if([image length]){//图片
        //    _reghtBtn.frame=CGRectMake(floatX, floatY, width, height);
        UIImage *imageView = [UIImage imageNamed:image];
        //    _leftBtn.frame=CGRectMake(floatX, floatY, width, height);
        _reghtBtn.imageBounds=CGRectMake(100 - imageView.size.width - 10, (self.frame.size.height - 20) / 2 - imageView.size.height / 2, imageView.size.width, imageView.size.height);
        [_reghtBtn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    
    if([text length]){//文字
        _reghtBtn.titleBounds = CGRectMake(0, 0, 90, self.frame.size.height - 20);
         [_reghtBtn setTitle:text forState:UIControlStateNormal];
        [_reghtBtn.titleLabel setTextAlignment:NSTextAlignmentRight];
    }
    
    
    _reghtBtn.hidden=hidded;
}
-(void)reghtBtnSheZhiImage:(NSString *)image withText:(NSString *)text withHidden:(BOOL)hidded withfloatX:(float)floatX withfloatY:(float)floatY withWidth:(float)width withHeight:(float)height withImageWidth:(float)imageWidth withImageHeight:(float)imageHeight
{
    [self reghtBtnSheZhiImage:image withText:text withHidden:hidded];
}

-(void)Leftbtn
{
    if ([_delegate respondsToSelector:@selector(navigationViewLeftDlegate)]) {
        [_delegate navigationViewLeftDlegate];
    }
    
    
}
-(void)reghtBtn1
{
    if ([_delegate respondsToSelector:@selector(navigationViewReghtDlegate)]) {
        [_delegate navigationViewReghtDlegate];
    }
    
    
    
}
- (void)onClickSegmentControl:(UISegmentedControl *)segment{
    if ([_delegate respondsToSelector:@selector(navigationViewCenterSegmentControlDelegate:)]) {
        [_delegate navigationViewCenterSegmentControlDelegate:segment.selectedSegmentIndex];
    }
    
    
}
@end
