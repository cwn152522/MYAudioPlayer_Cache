//
//  NavigationView.h
//  GuDaShi
//
//  Created by songzhaojie on 17/1/12.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//
#import "MYImageButton.h"
#import <UIKit/UIKit.h>

@protocol  NavigationViewLeftDlegate<NSObject>
@optional
-(void)navigationViewLeftDlegate;
-(void)navigationViewReghtDlegate;
-(void)navigationViewCenterSegmentControlDelegate:(NSInteger)selectIndex;

@end

@interface NavigationView : UIView
@property(nonatomic,strong)MYImageButton *leftBtn;
@property(nonatomic,strong)UILabel *zHongJianlable;
@property(nonatomic,strong)UISegmentedControl *zHongJianSegment;
@property(nonatomic,strong)MYImageButton* reghtBtn;
@property(nonatomic,assign) CGSize leftImageSizeLimited;//在设置图片前设置有效
@property(nonatomic,weak)id  delegate;


//左边设置图片
-(void)leftBtnSheZhiImage:(NSString *)image withHidden:(BOOL)hidded DEPRECATED_ATTRIBUTE;//autolayout
-(void)leftBtnSheZhiImage:(NSString *)image withHidden:(BOOL)hidded withfloatX:(float)floatX withfloatY:(float)floatY withWidth:(float)width withHeight:(float)heightDEPRECATED_ATTRIBUTE DEPRECATED_ATTRIBUTE;

//中间设置lable
-(void)zhongJianLableSheZhiLable:(NSString *)lable withZiShiYing:(BOOL)ZiShiYing  withFont:(float)font DEPRECATED_ATTRIBUTE;//autolayout
-(void)zhongJianLableSheZhiLable:(NSString *)lable withZiShiYing:(BOOL)ZiShiYing  withFont:(float)font withfloatX:(float)floatX withfloatY:(float)floatY withWidth:(float)width withHeight:(float)height DEPRECATED_ATTRIBUTE;//文本框标题
-(void)zhongJianSegmentSheZhiSegmentItems:(NSArray <NSString *>*)titles withFont:(float)font DEPRECATED_ATTRIBUTE;//分段控件标题

//右边设置图片
-(void)reghtBtnSheZhiImage:(NSString *)image withText:(NSString *)text withHidden:(BOOL)hidded DEPRECATED_ATTRIBUTE;//autolayout
-(void)reghtBtnSheZhiImage:(NSString *)image withText:(NSString *)text withHidden:(BOOL)hidded withfloatX:(float)floatX withfloatY:(float)floatY withWidth:(float)width withHeight:(float)height withImageWidth:(float)imageWidth withImageHeight:(float)imageHeight DEPRECATED_ATTRIBUTE;




/**
 设置文字标题，两标题：xxx-xxx

 @param title 标题
 @param leftImg 左图片
 @param rightImg 右图片
 */
-(void)setTitle:(NSString*)title leftBtnImage:(NSString*)leftImg rightBtnImage:(NSString *)rightImg;


/**
 设置segment

 @param titles 标题数组
 */
-(void)setSegmentItems:(NSArray<NSString*>*)titles;



@end
