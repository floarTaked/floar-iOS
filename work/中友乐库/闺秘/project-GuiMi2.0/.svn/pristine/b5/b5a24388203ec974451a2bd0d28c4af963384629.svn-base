//
//  LogicManager+ImagePiker.m
//  WeLinked4
//
//  Created by jonas on 5/29/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "LogicManager+ImagePiker.h"
#import <AVFoundation/AVFoundation.h>
#import "GifImageHelper.h"
@implementation LogicManager (ImagePiker)
#pragma --mark 获得图片
-(void)getImage:(UIViewController*)controller block:(EventCallBack)block
{
    hostViewController = controller;
    imagePikerCallBack = block;
    if(imagePicker == nil)
    {
        imagePicker = [[UIImagePickerController alloc]init];
        imagePicker.delegate = self;
        imagePicker.wantsFullScreenLayout = NO;
    }
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照",@"视频",@"相册",nil];
        [actionSheet showInView:controller.view];
    }
    else
    {
        [self showPhotoLibrary];
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self showCamera];
            break;
        case 1:
            [self showVideo];
            break;
        case 2:
            [self showPhotoLibrary];
            break;
        default:
            break;
    }
}
-(void)showVideo
{
    imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.movie", nil];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imagePicker setCameraDevice:UIImagePickerControllerCameraDeviceRear];
    [imagePicker setCameraFlashMode:UIImagePickerControllerCameraFlashModeAuto];
    imagePicker.showsCameraControls = YES;
    imagePicker.videoMaximumDuration = 7.0;
    [hostViewController presentViewController:imagePicker animated:YES completion:nil];
}
- (void)showCamera
{
    [MobClick event:take_photos];
    [self initEditController];
    
    imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.image", nil];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imagePicker setCameraDevice:UIImagePickerControllerCameraDeviceRear];
    [imagePicker setCameraFlashMode:UIImagePickerControllerCameraFlashModeAuto];
    imagePicker.showsCameraControls = YES;
    [hostViewController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)showPhotoLibrary
{
    [self initEditController];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeSavedPhotosAlbum];
    imagePicker.allowsEditing = YES;
    imagePicker.videoMaximumDuration = 7.0;
    imagePicker.mediaTypes = [NSArray arrayWithObjects:@"public.image",@"public.movie", nil];
    [hostViewController presentViewController:imagePicker animated:YES completion:nil];
}
-(void)initEditController
{
    library = [[ALAssetsLibrary alloc] init];
    imageEditor = [[ImageEditorViewController alloc] initWithNibName:@"ImageEditorViewController" bundle:nil];
    __weak UIImagePickerController* piker =  imagePicker;
    __weak typeof(EventCallBack) block = imagePikerCallBack;
    imageEditor.doneCallback = ^(int event,id object)
    {
        if(event == 1)
        {
            if(block)
            {
                block(event,object);
            }
            //            if(object != nil)
            //            {
            //                [weakSelf setAvatar:object];
            //            }
        }
        else
        {
            [piker popViewControllerAnimated:YES];
        }
    };
}
#pragma --mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:NO completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString* videoType = [info objectForKey:UIImagePickerControllerMediaType];
    if(videoType != nil && [videoType isEqualToString:@"public.movie"])
    {
        NSURL* path = [info objectForKey:UIImagePickerControllerMediaURL];
        
        [self videoCompressQualityWithInputUrl:path block:^(int event, id object)
        {
            unlink([[path path] UTF8String]);
            if(event == 1)
            {
                [[GifImageHelper sharedInstance] setCallBack:imagePikerCallBack];
                [[GifImageHelper sharedInstance] processVideo:(NSURL*)object];
                [imagePicker dismissViewControllerAnimated:YES completion:nil];
            }
            else
            {
                DLog(@"处理视频出错");
            }
        }];
    }
    else
    {
        UIImage *image =  [info objectForKey:UIImagePickerControllerOriginalImage];
        NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
        
        [library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
            UIImage *preview = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
            
            imageEditor.sourceImage = image;
            imageEditor.previewImage = preview;
            [imageEditor reset:NO];
            
            [picker dismissViewControllerAnimated:NO completion:nil];
            hostViewController.hidesBottomBarWhenPushed = YES;
            [hostViewController.navigationController pushViewController:imageEditor animated:YES];
            hostViewController.hidesBottomBarWhenPushed = NO;
        } failureBlock:^(NSError *error) {
            DLog(@"Failed to get asset from library");
        }];
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:nil];
}


#pragma --mark AVAssetExportSession
-(void)videoCompressQualityWithInputUrl:(NSURL *)inputUrl block:(EventCallBack)block
{
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:inputUrl options:nil];
    
    AVMutableComposition *mutableComposition = nil;
    AVMutableVideoComposition *mutableVideoComposition = nil;
    
    AVMutableVideoCompositionInstruction *instruction = nil;
    AVMutableVideoCompositionLayerInstruction *layerInstruction = nil;
    CGAffineTransform t1;
    CGAffineTransform t2;
    
    AVAssetTrack *assetVideoTrack = nil;
    // Check if the asset contains video and audio tracks
    if ([[asset tracksWithMediaType:AVMediaTypeVideo] count] != 0)
    {
        assetVideoTrack = [asset tracksWithMediaType:AVMediaTypeVideo][0];
    }
    
    CMTime insertionPoint = kCMTimeZero;
    NSError *error = nil;
    
    
    // Step 1
    // Create a composition with the given asset and insert audio and video tracks into it from the asset
    // Check whether a composition has already been created, i.e, some other tool has already been applied
    // Create a new composition
    mutableComposition = [AVMutableComposition composition];
    
    // Insert the video and audio tracks from AVAsset
    if (assetVideoTrack != nil)
    {
        AVMutableCompositionTrack *compositionVideoTrack = [mutableComposition addMutableTrackWithMediaType:AVMediaTypeVideo preferredTrackID:kCMPersistentTrackID_Invalid];
        [compositionVideoTrack insertTimeRange:CMTimeRangeMake(kCMTimeZero, [asset duration]) ofTrack:assetVideoTrack atTime:insertionPoint error:&error];
    }
    
    
    // Step 2
    // Translate the composition to compensate the movement caused by rotation (since rotation would cause it to move out of frame)
    t1 = CGAffineTransformMakeTranslation(assetVideoTrack.naturalSize.height, 0.0);
    // Rotate transformation
    t2 = CGAffineTransformRotate(t1, M_PI/2);
    
    
    // Step 3
    // Set the appropriate render sizes and rotational transforms
    // Create a new video composition
    mutableVideoComposition = [AVMutableVideoComposition videoComposition];
    mutableVideoComposition.renderSize = CGSizeMake(assetVideoTrack.naturalSize.height,assetVideoTrack.naturalSize.width);
    mutableVideoComposition.frameDuration = CMTimeMake(1, 30);
    
    // The rotate transform is set on a layer instruction
    instruction = [AVMutableVideoCompositionInstruction videoCompositionInstruction];
    instruction.timeRange = CMTimeRangeMake(kCMTimeZero, [mutableComposition duration]);
    layerInstruction = [AVMutableVideoCompositionLayerInstruction videoCompositionLayerInstructionWithAssetTrack:(mutableComposition.tracks)[0]];
    [layerInstruction setTransform:t2 atTime:kCMTimeZero];
    
    
    // Step 4
    // Add the transform instructions to the video composition
    instruction.layerInstructions = @[layerInstruction];
    mutableVideoComposition.instructions = @[instruction];
    
    
    AVAssetExportSession *session = [[AVAssetExportSession alloc]initWithAsset:mutableComposition
                                                                    presetName:AVAssetExportPreset640x480];
    NSString *pathToMovie = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/Movie.mov"];
    unlink([pathToMovie UTF8String]);
    float duration = mutableComposition.duration.value/mutableComposition.duration.timescale;
    if(duration < 6.0)
    {
        session.timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(0.0f, 30), mutableComposition.duration);
    }
    else
    {
        session.timeRange = CMTimeRangeMake(CMTimeMakeWithSeconds(0.0f, 30), CMTimeMakeWithSeconds(6.0f, 30));
    }
    session.outputFileType = AVFileTypeQuickTimeMovie;
    session.videoComposition = mutableVideoComposition;
    NSURL* outputUrl = [NSURL fileURLWithPath:pathToMovie];
    session.outputURL = outputUrl;
    [session exportAsynchronouslyWithCompletionHandler:^(void)
     {
         switch (session.status)
         {
             case AVAssetExportSessionStatusUnknown:
                 if(block)
                 {
                     block(0,nil);
                 }
                 break;
             case AVAssetExportSessionStatusWaiting:
                 break;
             case AVAssetExportSessionStatusExporting:
                 break;
             case AVAssetExportSessionStatusCompleted:
                 if(block)
                 {
                     block(1,outputUrl);
                 }
                 break;
             case AVAssetExportSessionStatusFailed:
                 if(block)
                 {
                     block(0,nil);
                 }
                 break;
             case AVAssetExportSessionStatusCancelled:
                 if(block)
                 {
                     block(0,nil);
                 }
                 break;
             default:
                 break;
         }
     }];
    
}
@end
