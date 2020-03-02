//
//  UIImage+scaledSize.h
//  pictureToViedo
//
//  Created by 牛清旭 on 2020/3/2.
//  Copyright © 2020 牛清旭. All rights reserved.
//



#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (scaledSize)
/**
 图片根据尺寸缩放

 @param targetSize 尺寸
 @return 新的图片
 */
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
@end

NS_ASSUME_NONNULL_END
