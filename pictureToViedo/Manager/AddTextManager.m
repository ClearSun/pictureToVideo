////
////  AddTextManager.m
////  VideoAudioCompositionDemo
////
////  Created by 牛清旭 on 2020/2/28.
////  Copyright © 2020 高磊. All rights reserved.
////
//
//#import "AddTextManager.h"
//#import <AVKit/AVKit.h>
//#import "SrtModel.h"
//@implementation AddTextManager
//+(void)addSRTWithSRTArr:(NSArray *)srtArr toVideoURL:(NSURL *)videoUrl complettion:(void (^)(NSURL *))completion
//
//{
//    NSURL *outPutUrl;
//    
//    
//    //1 创建AVAsset实例 AVAsset包含了video的所有信息 self.videoUrl输入视频的路径
//    AVAsset *videoAsset = [AVAsset assetWithURL:videoUrl];
//    //2 创建AVMutableComposition实例. apple developer 里边的解释 【AVMutableComposition is a mutable subclass of AVComposition you use when you want to create a new composition from existing assets. You can add and remove tracks, and you can add, remove, and scale time ranges.】
//    AVMutableComposition *mixComposition = [[AVMutableComposition alloc] init];
//    
//    //3 视频通道  工程文件中的轨道，有音频轨、视频轨等，里面可以插入各种对应的素材
//    AVMutableCompositionTrack *videoTrack = [mixComposition addMutableTrackWithMediaType:AVMediaTypeVideo
//                                                                        preferredTrackID:kCMPersistentTrackID_Invalid];
//    //把视频轨道数据加入到可变轨道中 这部分可以做视频裁剪TimeRange
//    [videoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, videoAsset.duration)
//                        ofTrack:[[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject]
//                         atTime:kCMTimeZero error:nil];
//    
//    //3.1 AVMutableVideoCompositionInstruction 视频轨道中的一个视频，可以缩放、旋转等
//    AVMutableVideoCompositionInstruction *mainInstruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
//    mainInstruction.timeRange = CMTimeRangeMake(kCMTimeZero, videoAsset.duration);
//    
//    // 3.2 AVMutableVideoCompositionLayerInstruction 一个视频轨道，包含了这个轨道上的所有视频素材
//    AVMutableVideoCompositionLayerInstruction *videolayerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:videoTrack];
//    AVAssetTrack *videoAssetTrack = [[videoAsset tracksWithMediaType:AVMediaTypeVideo] firstObject];
//    UIImageOrientation videoAssetOrientation_  = UIImageOrientationUp;
//    BOOL isVideoAssetPortrait_  = NO;
//    CGAffineTransform videoTransform = videoAssetTrack.preferredTransform;
//    if (videoTransform.a == 0 && videoTransform.b == 1.0 && videoTransform.c == -1.0 && videoTransform.d == 0) {
//        videoAssetOrientation_ = UIImageOrientationRight;
//        isVideoAssetPortrait_ = YES;
//    }
//    if (videoTransform.a == 0 && videoTransform.b == -1.0 && videoTransform.c == 1.0 && videoTransform.d == 0) {
//        videoAssetOrientation_ =  UIImageOrientationLeft;
//        isVideoAssetPortrait_ = YES;
//    }
//    if (videoTransform.a == 1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == 1.0) {
//        videoAssetOrientation_ =  UIImageOrientationUp;
//    }
//    if (videoTransform.a == -1.0 && videoTransform.b == 0 && videoTransform.c == 0 && videoTransform.d == -1.0) {
//        videoAssetOrientation_ = UIImageOrientationDown;
//    }
//    [videolayerInstruction setTransform:videoAssetTrack.preferredTransform atTime:kCMTimeZero];
//    [videolayerInstruction setOpacity:0.0 atTime:videoAsset.duration];
//    
//    // 3.3 - Add instructions
//    mainInstruction.layerInstructions = [NSArray arrayWithObjects:videolayerInstruction,nil];
//    //AVMutableVideoComposition：管理所有视频轨道，可以决定最终视频的尺寸，裁剪需要在这里进行
//    AVMutableVideoComposition *mainCompositionInst = [AVMutableVideoComposition videoComposition];
//    
//    CGSize naturalSize;
//    if(isVideoAssetPortrait_){
//        naturalSize = CGSizeMake(videoAssetTrack.naturalSize.height, videoAssetTrack.naturalSize.width);
//    } else {
//        naturalSize = videoAssetTrack.naturalSize;
//    }
//    
//    float renderWidth, renderHeight;
//    renderWidth = naturalSize.width;
//    renderHeight = naturalSize.height;
//    mainCompositionInst.renderSize = CGSizeMake(renderWidth, renderHeight);
//    mainCompositionInst.instructions = [NSArray arrayWithObject:mainInstruction];
//    mainCompositionInst.frameDuration = CMTimeMake(1, 30);
//    
//    //加水印
//    // videoLayer是视频layer,parentLayer是最主要的，videoLayer和字幕，贴纸的layer都要加在该layer上
//    CALayer *parentLayer = [CALayer layer];
//    CALayer *videoLayer = [CALayer layer];
//    parentLayer.frame = CGRectMake(0, 0, renderWidth, renderHeight);
//    videoLayer.frame = CGRectMake(0, 0, renderWidth, renderHeight);
//    [parentLayer addSublayer:videoLayer];
//    for (SrtModel *srtModel in srtArr) {
//        UILabel *subtitleLabel = [[UILabel alloc]initWithFrame:srtModel.rect];
//        subtitleLabel.text = srtModel.title;
//        subtitleLabel.textColor = srtModel.textColor;
//        subtitleLabel.font = [UIFont fontWithName:srtModel.fontName size:srtModel.fontSize];
//        // 这个是透明度动画主要是使在插入的才显示，其它时候都是不显示的
//        subtitleLabel.layer.opacity = 0;
//        CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
//        opacityAnim.fromValue = [NSNumber numberWithFloat:1];
//        opacityAnim.toValue = [NSNumber numberWithFloat:1];
//        opacityAnim.removedOnCompletion = NO;
//        
//        CABasicAnimation *rotationAnimation;
////        switch (srtModel.animationType) {
////            case 0:
////
////                break;
////            case 1:
////                rotationAnimation = [SubTitleAnimation moveAnimationWithFromPosition:CGPointMake(subtitleLabel.layer.position.x + 100, subtitleLabel.layer.position.y) toPosition:subtitleLabel.layer.position];
////                break;
////            case 2:
////                rotationAnimation = [SubTitleAnimation moveAnimationWithFromPosition:CGPointMake(subtitleLabel.layer.position.x, subtitleLabel.layer.position.y + 50) toPosition:subtitleLabel.layer.position];
////                break;
////            case 3:
////                rotationAnimation = [SubTitleAnimation narrowIntoAnimation];
////                break;
////            case 4:
////                rotationAnimation = [SubTitleAnimation fadeInAnimation];
////                break;
////            case 5:
////                rotationAnimation = [SubTitleAnimation transformAnimation];
////                break;
////
////            default:
////                break;
////        }
//        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
//        groupAnimation.animations = [NSArray arrayWithObjects:opacityAnim, rotationAnimation, nil];
//        if (CMTimeGetSeconds(srtModel.insertTime.start) == 0) {
//            groupAnimation.beginTime = 0.01;
//        }else {
//            groupAnimation.beginTime = CMTimeGetSeconds(srtModel.insertTime.start);
//        }
//        groupAnimation.duration = CMTimeGetSeconds(srtModel.insertTime.duration);
//        
//        [subtitleLabel.layer addAnimation:groupAnimation forKey:nil];
//        [parentLayer addSublayer:subtitleLabel.layer];
//    }
//    
//    mainCompositionInst.animationTool = [AVVideoCompositionCoreAnimationTool
//                                 videoCompositionCoreAnimationToolWithPostProcessingAsVideoLayer:videoLayer inLayer:parentLayer];
//    
//    
//    
//    
//    
//    // 4 - 输出路径
//    
//    NSString *documentsDirectory = [self mp4FilePath];
//    NSString *myPathDocs =  [documentsDirectory stringByAppendingPathComponent:
//                             [NSString stringWithFormat:@"v_%@.mp4",[NSString dateToIDstring:[NSDate date]]]];
//    outPutUrl = [NSURL fileURLWithPath:myPathDocs];
//    
//    // 5 - 视频文件输出
//    AVAssetExportSession *exporter = [[AVAssetExportSession alloc] initWithAsset:mixComposition
//                                                                      presetName:AVAssetExportPresetHighestQuality];
//    exporter.outputURL = outPutUrl;
//    exporter.outputFileType = AVFileTypeMPEG4;
//    exporter.shouldOptimizeForNetworkUse = YES;
//    exporter.videoComposition = mainCompositionInst;
//    [exporter exportAsynchronouslyWithCompletionHandler:^{
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //这里是输出视频之后的操作，做你想做的
//            NSLog(@"完事了-----%f",[self getRealVideoAllTimeWith:outPutUrl]);
//            completion(outPutUrl);
//            
//        });
//    }];
//
//
//}
//
//@end
