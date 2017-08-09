//
//  AVPlayer_CachePreference.h
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/12.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 说明：关于缓存的一些偏好设置，如临时文件路径设置、缓存目录路径设置等
 */

@interface AVPlayer_CachePreference : NSObject

/**
 正在缓存的音频文件路径，默认为/tmp/musicTemp.mp3
 */
@property (strong, nonatomic, readonly) NSString *tmpFilePath;

/**
 音频缓存目录路径，存放已经缓存结束的音频文件，默认为/Library/MusicCaches
 */
@property (strong, nonatomic, readonly) NSString *cacheFolderPath;



/**
 获取单例对象
 
 @return self
 */
+ (instancetype)sharedPreference;

/**
 获取缓存文件路径
 
 @param url 待搜索音频文件的网络地址
 @return 指定网络地址下对应的本地音频路径
 */
- (NSString *)getCacheFilePath:(NSString *)url;

@end













@interface NSURL (ResourceLoader)

/**
 自定义scheme，不能是http，才能利用ResourceLoader进行边载边播，否则不走AVAssetResourceLoaderDelegate代理
 */
- (NSURL *)customSchemeURL;

/**
 还原scheme
 */
- (NSURL *)originalSchemeURL;

@end
