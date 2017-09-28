//
//  AVPlayer_CacheFileHandler.h
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/12.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AVPlayer_CachePreference.h"
/*
 说明：利用NSFileManager进行缓存文件(夹)的创建、删除、移动等操作，利用NSFileHandler进行临时播放文件的读写操作
 */

@interface AVPlayer_CacheFileHandler : NSObject

/**
 创建临时文件，eg.musicTemp.mp3

 @return 创建是否成功
 */
+ (BOOL)createTempFileForUrl:(NSString *)url;

/**
 往临时文件写入数据

 @param data 已经缓存到了的数据
 */
+ (void)writeTempFileData:(NSData *)data forUrl:(NSString *)url;

/**
 从临时文件中读取某段缓冲数据

 @param offset 缓冲数据起始点
 @param length 缓冲数据目标长度
 */
+ (NSData *)readTempFileDataWithOffset:(NSUInteger)offset length:(NSUInteger)length forUrl:(NSString *)url;

/**
 保存临时文件到缓存文件夹

 @param fileName 待保存音频文件名
 @return 保存音频文件是否成功 
 */
+ (BOOL)saveTempFileIntoCacheFolderWithFileName:(NSString *)fileName forUrl:(NSString *)url;

/**
 判断指定音频url是否存在相应缓存文件

 @param url 音频网络地址
 @return 缓存文件路径
 */
+ (NSString *)cacheFileExistsWithURL:(NSURL *)url;

/**
 清除缓存所有文件

 @return 清除缓存是否成功
 */
+ (BOOL)clearCaches;

/**
 清除缓存所有文件
 
 @return 清除缓存是否成功
 */
+ (BOOL)clearTmps;

@end
