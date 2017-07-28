//
//  MYBaseJsonModel.h
//  GuDaShi
//
//  Created by 伟南 陈 on 2017/7/14.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import <Foundation/Foundation.h>
//数据模型转化基类

@interface MYBaseJsonModel : NSObject

- (instancetype)initWithDictionary:(NSDictionary *)dic;//初始化方法
- (void)setParam:(NSString *)param ofDic:(NSDictionary *)dic;//kvc设置属性

@end
