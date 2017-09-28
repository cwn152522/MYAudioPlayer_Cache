//
//  AVPlayer_CachePreference.m
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/12.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "AVPlayer_CachePreference.h"
static AVPlayer_CachePreference *instance;

@implementation AVPlayer_CachePreference

- (instancetype)init{
    if(self = [super init]){
        _tmpFilePath = [NSTemporaryDirectory() stringByAppendingPathComponent:@"MusicTmps"];
        _cacheFolderPath = [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"MusicCaches"];
    }
    return self;
}

+ (instancetype)sharedPreference{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[AVPlayer_CachePreference alloc] init];
    });
    return instance;
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

- (NSString *)getCacheFilePath:(NSString *)url{
    NSString *fileName = [[url componentsSeparatedByString:@"/"] lastObject];//从url获取音频的文件名
    NSString * cacheFilePath = [NSString stringWithFormat:@"%@/%@", [self cacheFolderPath], fileName];//得到本地文件路径
    return cacheFilePath;
}

- (NSString *)getTmpFilePath:(NSString *)url{
    NSString *fileName = [[url componentsSeparatedByString:@"/"] lastObject];//从url获取音频的文件名
    NSString * tmpFilePath = [NSString stringWithFormat:@"%@/%@", [self tmpFilePath], fileName];//得到本地临时文件路径
    return tmpFilePath;
}



@end










@implementation NSURL (ResourceLoader)

- (NSURL *)customSchemeURL {
    NSURLComponents * components = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:NO];
    components.scheme = @"streaming";
    return [components URL];
}

- (NSURL *)originalSchemeURL {
    NSURLComponents * components = [[NSURLComponents alloc] initWithURL:self resolvingAgainstBaseURL:NO];
    components.scheme = @"http";
    return [components URL];
}

@end
