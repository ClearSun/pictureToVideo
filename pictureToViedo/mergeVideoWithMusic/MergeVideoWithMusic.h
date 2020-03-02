//
//  MergeVideoWithMusic.h
//  pictureToViedo
//
//  Created by 牛清旭 on 2020/3/2.
//  Copyright © 2020 牛清旭. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^mergeVideoSuccessBlock)(void);
@interface MergeVideoWithMusic : NSObject

/**
 没有背景音乐的视频添加背景音乐

 @param musicPath 背景音乐地址
 @param videoPath 视频地址
 @param savePath 保存视频地址
 @param successBlock 合成成功
 */
+ (void)mergeVideoWithMusic:(NSString *)musicPath noBgMusicVideo:(NSString *)videoPath saveVideoPath:(NSString *)savePath success:(mergeVideoSuccessBlock)successBlock;

//抽取原视频的音频与需要的音乐混合
/**
 音频视频合成
 
 @param musicPath 音频
 @param videoPath 视频
 @param savePath 保存地址
 @param successBlock 合成成功
 */
+ (void)mergeVideoWithMusic:(NSString *)musicPath video:(NSString *)videoPath saveVideoPath:(NSString *)savePath success:(mergeVideoSuccessBlock)successBlock;

@end

NS_ASSUME_NONNULL_END
