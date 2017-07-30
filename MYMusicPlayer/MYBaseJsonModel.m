//
//  MYBaseJsonModel.m
//  GuDaShi
//
//  Created by 伟南 陈 on 2017/7/14.
//  Copyright © 2017年 songzhaojie. All rights reserved.
//

#import "MYBaseJsonModel.h"

@implementation MYBaseJsonModel

- (void)setParam:(NSString *)param ofDic:(NSDictionary *)dic{
    if(![dic[param] isKindOfClass:[NSNull class]]){
        NSString *paramStr = [NSString stringWithFormat:@"%@", dic[param]];
        [self setValue:paramStr forKey:param];
    }
}

- (instancetype)initWithDictionary:(NSDictionary *)dic{
    if(self = [super init]){
        
    }
    return self;
}

@end
