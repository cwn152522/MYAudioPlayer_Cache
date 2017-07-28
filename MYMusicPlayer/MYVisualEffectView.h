//
//  MYVIsualEffectView.h
//  MYDaPanSingalView
//
//  Created by 伟南 陈 on 2017/6/26.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import <UIKit/UIKit.h>// 蒙版视图

@protocol  MYVisualEffectViewDelegate<NSObject>

- (void)onclickEffectView;

@end


@interface MYVisualEffectView : UIControl

@property (assign, nonatomic) BOOL centerBtnHidden;//中间锁按钮是否显示
@property (assign, nonatomic) id <MYVisualEffectViewDelegate>delegate;

@end
