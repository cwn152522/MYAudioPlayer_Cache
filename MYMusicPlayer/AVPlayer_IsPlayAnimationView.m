//
//  AVPlayer_IsPlayAnimationView.m
//  MYMusicPlayer
//
//  Created by 陈伟南 on 2017/7/30.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "AVPlayer_IsPlayAnimationView.h"

@interface AVPlayer_IsPlayAnimationView ()

@property CALayer *itemLayer;

@property BOOL isAnimating;

@end

@implementation AVPlayer_IsPlayAnimationView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if(self = [super initWithCoder:aDecoder]){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appWillBecomeActive) name:UIApplicationWillEnterForegroundNotification object:nil];
    }
    return self;
}

- (void)startAnimation{
    if(self.isAnimating == NO){
        self.layer.backgroundColor = [UIColor clearColor].CGColor;
        [self configAnimationLayer:self.layer withTintColor:[UIColor colorWithRed:201/255.0 green:8/255.0 blue:19/255.0 alpha:1] size:self.frame.size];
        self.isAnimating = YES;
    }
}

-(void)configAnimationLayer:(CALayer*)layer withTintColor:(UIColor*)color size:(CGSize)size
{
    CAReplicatorLayer *replicatorLayer = [CAReplicatorLayer layer];
    replicatorLayer.frame = CGRectMake(0, 0, size.width / 2, size.height);
    //    replicatorLayer.position = CGPointZero;
    replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
    [layer addSublayer:replicatorLayer];
    
    CAReplicatorLayer *replicatorLayer1 = [CAReplicatorLayer layer];
    replicatorLayer1.frame = CGRectMake(size.width / 2, 0, size.width / 2, size.height);
    //    replicatorLayer1.position = CGPointZero;
    replicatorLayer1.backgroundColor = [UIColor clearColor].CGColor;
    [layer addSublayer:replicatorLayer1];
    
    
    for (id la in layer.sublayers) {
        
        if ([la isKindOfClass:[CAReplicatorLayer class]]) {
            
            CAReplicatorLayer *replicatorLayer = la;
            
            [self addMusicBarAnimationLayerAtLayer:replicatorLayer withTintColor:color size:size];
            
            NSInteger numOfSpot = 2;
            replicatorLayer.instanceCount = numOfSpot;
            replicatorLayer.instanceTransform = CATransform3DMakeTranslation(size.width*2.5/10, 0.f, 0.f);
            replicatorLayer.instanceDelay = 0.17;
            replicatorLayer.masksToBounds = YES; // 子视图超出的部分切掉
        }
    }
}

- (void)addMusicBarAnimationLayerAtLayer:(CALayer *)layer withTintColor:(UIColor *)color size:(CGSize)size{
    CGFloat width = size.width/6;
    CGFloat height = size.height;
    self.itemLayer = [CALayer layer];
    self.itemLayer.bounds = CGRectMake(0, 0, width, height);
    self.itemLayer.position = CGPointMake(width / 2, layer.frame.origin.x == 0 ? size.height + 6  :  size.height + 6 - self.itemLayer.bounds.size.height/2);
    self.itemLayer.cornerRadius = 2.0;
    self.itemLayer.backgroundColor = color.CGColor;
    [layer addSublayer:self.itemLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position.y"];
    //    NSLog(@"%lf",self.itemLayer.position.y - self.itemLayer.bounds.size.height/2 );
    animation.toValue = @(layer.frame.origin.x == 0 ? self.itemLayer.position.y - self.itemLayer.bounds.size.height/2 : size.height + 6);
    animation.duration = 0.36;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:layer.frame.origin.x == 0 ?kCAMediaTimingFunctionEaseOut : kCAMediaTimingFunctionEaseIn];
    animation.autoreverses = YES;
    animation.repeatCount = HUGE_VALF;
    
    
    [self.itemLayer addAnimation:animation forKey:@"animation"];
}

- (void)appWillBecomeActive{
    if (self.isAnimating == YES) {
        [self.itemLayer removeAnimationForKey:@"animation"];
        self.layer.sublayers = nil;
        self.isAnimating = NO;
        [self startAnimation];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
