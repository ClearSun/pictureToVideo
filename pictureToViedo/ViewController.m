//
//  ViewController.m
//  pictureToViedo
//
//  Created by 牛清旭 on 2020/3/2.
//  Copyright © 2020 牛清旭. All rights reserved.
//

#import "ViewController.h"
#import "ImagesToVideo.h"
#import "MergeVideoWithMusic.h"
#import "UIImage+scaledSize.h"
#import "TZImagePickerController.h"


#define WeakSelf(self)  __weak typeof(self) weakSelf = self //弱引用self !!!  勿删


#import "ViewController.h"
#import "VideoAudioComposition.h"
#import "GLProgressLayer.h"
#import "VideoAudioEdit.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
@interface ViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,TZImagePickerControllerDelegate>
@property (nonatomic,strong) NSMutableArray *dataSource;

@property (nonatomic,strong) GLProgressLayer *progressLayer;

@property (nonatomic,strong) NSMutableArray *images;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self mergeMusicAndNoMusicVide];
    
    self.view.backgroundColor = UIColor.whiteColor;
    UIButton *startBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    startBtn.frame = CGRectMake(100, 100, 100, 100);
    startBtn.backgroundColor = UIColor.redColor;
    [startBtn setTitle:@"选择照片" forState:(UIControlStateNormal)];
    [startBtn addTarget:self action:@selector(selectFromLocalPhoto) forControlEvents:(UIControlEventTouchUpInside)];
    [self.view addSubview:startBtn];

}
#pragma mark----选取本地图片
- (void)selectFromLocalPhoto{
    TZImagePickerController  *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:20 delegate:self];
    
    
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.showSelectedIndex = YES;
    imagePickerVc.statusBarStyle = UIStatusBarStyleDefault;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    imagePickerVc.allowPreview = NO;
    imagePickerVc.showPhotoCannotSelectLayer = YES;
    imagePickerVc.naviTitleColor = UIColor.blackColor;
    imagePickerVc.barItemTextColor = UIColor.blackColor;
    imagePickerVc.isSelectOriginalPhoto = YES;
    WeakSelf(self);
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {

        
//        [weakSelf mergeMusicAndNoMusicVideWithPicture:photos];
        
        [weakSelf secondWithPicture:photos];

        
    }];
    self.navigationController.modalPresentationStyle = UIModalPresentationFullScreen;
    self.modalPresentationStyle = UIModalPresentationFullScreen;
    
      [self presentViewController:imagePickerVc animated:YES completion:^{
          
      }];
    
}




- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
}

- (void)secondWithPicture:(NSArray *)pictures{
    
     //
                self.progressLayer = [GLProgressLayer showProgress];
//                NSMutableArray *images = [[NSMutableArray alloc] init];
//                for (int i = 0; i < 11; i++) {
//                    [images addObject:[UIImage imageNamed:[NSString stringWithFormat:@"img%d.jpg",i]]];
//                }
                __weak typeof(self)weakSelf = self;
                
                NSMutableArray *imageArray = [[NSMutableArray alloc] init];
                for (int i = 0; i<pictures.count; i++) {
                    UIImage *imageNew = pictures[i];
                    //设置image的尺寸
                    CGSize imagesize = imageNew.size;
                    imagesize.height =480;
                    imagesize.width =320;
                    //对图片大小进行压缩--
                    imageNew = [self imageWithImage:imageNew scaledToSize:imagesize];
                    [imageArray addObject:imageNew];
                }
                
                NSURL *videoInputUrl = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"mp3"]];
                VideoAudioEdit *videoManager = [[VideoAudioEdit alloc] init];
                [videoManager compositionVideoWithImage:imageArray
                                              videoName:@"test.mov"
                                                  audio:videoInputUrl
                                                success:^(NSURL *fileUrl) {
                    [weakSelf.progressLayer hiddenProgress];
//                    ViewController *vc = [[ViewController alloc] init];
//                    [weakSelf.navigationController pushViewController:vc animated:YES];
//                    [vc playWithUrl:fileUrl];
                    
                    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^
                    {
                        [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:fileUrl];
                    }
                                                     completionHandler:^(BOOL success, NSError * _Nullable error)
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
    //                        [MBProgressHUD hideHUDForView:self.view
    //                                             animated:YES];
                            self.view.userInteractionEnabled = YES;
                            if (success)
                            {
                                NSLog(@"保存成功");
                                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"合成完成，已存入相册" preferredStyle:UIAlertControllerStyleAlert];
                                [alertController addAction:[UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    //                                [self.navigationController popViewControllerAnimated:YES];
                                }]];
                                [self presentViewController:alertController animated:YES completion:^{
                                    
                                }];
                            }
                            else
                            {
                                NSLog(@"合成失败");
                            }
                        });
                    }];
                }];
                
                videoManager.progressBlock = ^(CGFloat progress) {
                    weakSelf.progressLayer.progress = progress;
                };
}
- (void)mergeMusicAndNoMusicVideWithPicture:(NSArray *)pictures {
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"Documents/movie.mp4"]];
    

    
    
    CGSize currentSize = CGSizeMake(320, 480);
    
    
    NSMutableArray *imageArray=[NSMutableArray array];
    
    for (int i = 0; i<pictures.count; i++) {
        UIImage *imageNew = pictures[i];
        //设置image的尺寸
        CGSize imagesize = imageNew.size;
        imagesize.height =currentSize.height;
        imagesize.width =currentSize.width;
        
        //对图片大小进行压缩--
        imageNew = [imageNew imageByScalingAndCroppingForSize:currentSize];
        [imageArray addObject:imageNew];
    }
    
    
    //每次生成视频前，先移除重复名的，
    [[NSFileManager defaultManager] removeItemAtPath:path error:NULL];
    
    
//    NSLog(@"path:%@",path);
    
    //开始合成
    
    __weak typeof(self)weakSelf=self;
    

    
    [ImagesToVideo saveVideoToPhotosWithImages:imageArray videoPath:path withSize:currentSize withFPS:1 animateTransitions:YES withCallbackBlock:^(BOOL success) {

        dispatch_async(dispatch_get_main_queue(), ^{

            if (success) {
                NSLog(@"success");

                // 最终合成输出路径
                NSString *outPutFilePath = [NSHomeDirectory() stringByAppendingPathComponent:
                                            [NSString stringWithFormat:@"Documents/merge.mp4"]];

                [MergeVideoWithMusic mergeVideoWithMusic:[[NSBundle mainBundle] pathForResource:@"一个人的冬天" ofType:@"mp3"] noBgMusicVideo:path saveVideoPath:outPutFilePath success:^{

                    NSLog(@"合成并且保存成功  %@",outPutFilePath);
                    UISaveVideoAtPathToSavedPhotosAlbum(outPutFilePath, self, nil, nil);

//                    [weakSelf playWithUrl:outPutFilePath];
                }];

            }

        });

    }];
    

}


/** 播放方法 */
- (void)playWithUrl:(NSString *)urlPath{
    // 传入地址
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithURL:[NSURL fileURLWithPath:urlPath]];
    // 播放器
    AVPlayer *player = [AVPlayer playerWithPlayerItem:playerItem];
    // 播放器layer
    AVPlayerLayer *playerLayer = [AVPlayerLayer playerLayerWithPlayer:player];
    playerLayer.frame = self.view.frame;
    // 视频填充模式
    playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    // 添加到imageview的layer上
    [self.view.layer addSublayer:playerLayer];
    // 播放
    [player play];
    
    
}


- (void)mergeMusicAndVideo {
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:
                      [NSString stringWithFormat:@"Documents/movie.mov"]];
    
    
    [MergeVideoWithMusic mergeVideoWithMusic:[[NSBundle mainBundle] pathForResource:@"一个人的冬天" ofType:@"mp3"] video:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"] saveVideoPath:path success:^{
        
    }];
}



-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    //    新创建的位图上下文 newSize为其大小
    UIGraphicsBeginImageContext(newSize);
    //    对图片进行尺寸的改变
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    //    从当前上下文中获取一个UIImage对象  即获取新的图片对象
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // Return the new image.
    return newImage;
}


@end
