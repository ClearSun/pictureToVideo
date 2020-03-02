//
//  AddTextManager.h
//  VideoAudioCompositionDemo
//
//  Created by 牛清旭 on 2020/2/28.
//  Copyright © 2020 高磊. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddTextManager : NSObject
+(void)addSRTWithSRTArr:(NSArray *)srtArr toVideoURL:(NSURL *)videoUrl complettion:(void (^)(NSURL *))completion;
@end

NS_ASSUME_NONNULL_END
