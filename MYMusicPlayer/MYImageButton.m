//
//  MYImageButton.m
//  MYCloud
//
//  Created by 陈伟南 on 15/12/14.
//  Copyright © 2015年 Jam. All rights reserved.
//

#import "MYImageButton.h"

@implementation MYImageButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect{
    if(_imageBounds.size.width > 0){
        return _imageBounds;
    }
        return [super imageRectForContentRect:contentRect];
}

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    if(_titleBounds.size.width > 0){
        return self.titleBounds;
    }
    return [super titleRectForContentRect:contentRect];
}

@end
