//
//  LogicManager+ImagePiker.m
//  WeLinked4
//
//  Created by jonas on 5/29/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "LogicManager+ImagePiker.h"
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
                                                        otherButtonTitles:@"拍照",@"相册",nil];
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
            [self showPhotoLibrary];
            break;
        case 2:
            break;
        default:
            break;
    }
}
- (void)showCamera
{
    [self initEditController];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imagePicker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
    [imagePicker setCameraFlashMode:UIImagePickerControllerCameraFlashModeAuto];
    imagePicker.showsCameraControls = YES;
    [hostViewController presentViewController:imagePicker animated:YES completion:nil];
}

- (void)showPhotoLibrary
{
    [self initEditController];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
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
        NSLog(@"Failed to get asset from library");
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:nil];
}
@end
