//
//  AVPlayer_CacheFileHandler.m
//  MYMusicPlayer
//
//  Created by 伟南 陈 on 2017/7/12.
//  Copyright © 2017年 chenweinan. All rights reserved.
//

#import "AVPlayer_CacheFileHandler.h"

@implementation AVPlayer_CacheFileHandler

+ (BOOL)createTempFileForUrl:(NSString *)url{
    //TODO: 创建临时文件，eg.musicTemp.mp3
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *folder_path = [[AVPlayer_CachePreference sharedPreference]tmpFilePath];
    NSString *path = [[AVPlayer_CachePreference sharedPreference] getTmpFilePath:url];
    if(![manager fileExistsAtPath:folder_path]){//不存在缓存文件目录，创建
         [manager createDirectoryAtPath:folder_path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    if([manager fileExistsAtPath:path]){//存在临时文件，删除旧的
        [manager removeItemAtPath:path error:nil];
    }
    BOOL flag = [manager createFileAtPath:path contents:nil attributes:nil];
    return flag;
}

+ (void)writeTempFileData:(NSData *)data forUrl:(NSString *)url{
    //TODO: 往临时文件写入数据
    NSString *path = [[AVPlayer_CachePreference sharedPreference] getTmpFilePath:url];
    NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path];//打开目标文件
    [handle seekToEndOfFile];//光标移动到文件尾部
    [handle writeData:data];//尾部写入新数据
}

+ (NSData *)readTempFileDataWithOffset:(NSUInteger)offset length:(NSUInteger)length forUrl:(NSString *)url{
    //TODO: 从临时文件中读取某段缓冲数据
    NSString *path = [[AVPlayer_CachePreference sharedPreference] getTmpFilePath:url];
    NSFileHandle *handle = [NSFileHandle fileHandleForReadingAtPath:path];//打开目标文件
    [handle seekToFileOffset:offset];//光标移动到指定位置
    return [handle readDataOfLength:length];//读取指定长度的数据
}

+ (BOOL)saveTempFileIntoCacheFolderWithFileName:(NSString *)fileName forUrl:(NSString *)url{
    //TODO: 保存临时文件到缓存文件夹
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *cacheFolderPath = [AVPlayer_CachePreference sharedPreference].cacheFolderPath;
    if(![manager fileExistsAtPath:cacheFolderPath]){//没有缓存文件夹，进行创建
        [manager createDirectoryAtPath:cacheFolderPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *tempFilePath = [[AVPlayer_CachePreference sharedPreference] getTmpFilePath:url];
    NSString *cacheFilePath = [NSString stringWithFormat:@"%@/%@", cacheFolderPath, fileName];
    BOOL success = [[NSFileManager defaultManager] copyItemAtPath:tempFilePath toPath:cacheFilePath error:nil];
    return success;
}

+ (NSString *)cacheFileExistsWithURL:(NSURL *)url{
    //TODO: 判断指定音频url是否存在相应缓存文件
    NSString * cacheFilePath = [[AVPlayer_CachePreference sharedPreference] getCacheFilePath:url.absoluteString];//得到本地文件路径
    if ([[NSFileManager defaultManager] fileExistsAtPath:cacheFilePath]) {//判断本地缓存文件是否存在
        return cacheFilePath;
    }
    return nil;
}

+ (BOOL)clearCaches{
    NSString *cacheFolderPath = [AVPlayer_CachePreference sharedPreference].cacheFolderPath;
    NSFileManager * manager = [NSFileManager defaultManager];
    return [manager removeItemAtPath:cacheFolderPath error:nil];
}
@end
