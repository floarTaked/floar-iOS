//
//  UIImage+Screenshot.m
//  NZAlertView
//
//  Created by Bruno Furtado on 20/12/13.
//  Copyright (c) 2013 No Zebra Network. All rights reserved.
//

#define IsIOS7 ([[[[UIDevice currentDevice] systemVersion] substringToIndex:1] intValue]>=7)

#import "UIImage+Screenshot.h"

@implementation UIImage (Screenshot)

+ (UIImage *)screenshot
{
    CGSize imageSize = [[UIScreen mainScreen] bounds].size;
 
    if (NULL != UIGraphicsBeginImageContextWithOptions) {
        UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    } else {
        UIGraphicsBeginImageContext(imageSize);
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
        if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
            CGContextSaveGState(context);

            CGContextTranslateCTM(context, [window center].x, [window center].y);

            CGContextConcatCTM(context, [window transform]);
            
            CGContextTranslateCTM(context,
                                  -[window bounds].size.width * [[window layer] anchorPoint].x,
                                  -[window bounds].size.height * [[window layer] anchorPoint].y);
            
            [[window layer] renderInContext:context];
            
            CGContextRestoreGState(context);
        }
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIImage *)imageFromUIView:(UIView *)view
{
    //支持retina高分的关键
    
    UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *trackImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return trackImage;
    UIImageWriteToSavedPhotosAlbum(trackImage, nil, nil, nil);
    
    __block UIImage *snapImage = nil;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
        if(UIGraphicsBeginImageContextWithOptions != NULL)
        {
            UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0);
        } else {
            UIGraphicsBeginImageContext(view.frame.size);
        }
        
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        //        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
        //        UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
        //        UIGraphicsEndImageContext();
        //        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    });
    //获取图像
    //    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    //    UIGraphicsEndImageContext();
    return snapImage;
    
}

#if 0
+(UIImage *)imageFromRangeView:(CGRect)arect
{
    
    //区域截图
    UIImage *snapshot;
    CGImageRef UIGetScreenImage();
    CGImageRef cgScreen = UIGetScreenImage();
    if (cgScreen)
    {
        snapshot = [UIImage imageWithCGImage:cgScreen];
        CGImageRelease(cgScreen);
    }
    
    CGRect rect;
    //高清截图需要扩大2倍范围 不高清得就直接按范围切，注意高清版本的ios7系统 妈的20px导航也要考虑在内，如果是ios7以上得 （CGRectMake（，y，，）这个y 要多加20也就是IsIOS7?0:20*2）多加个判断
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)] && [[UIScreen mainScreen] scale] == 2)
    {
        //获取高清size
        rect = CGRectMake(arect.origin.x*2, arect.origin.y*2+(IsIOS7?0:20*2), (arect.size.width)*2, arect.size.height*2);//创建要剪切的矩形框
    }
    else
    {
        //获取低清size
        rect=CGRectMake(arect.origin.x, arect.origin.y+20, arect.size.width, arect.size.height);
    }
    
    UIImage *res = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([snapshot CGImage], rect)];
    //存到像册
//    UIImageWriteToSavedPhotosAlbum(res, nil, nil, nil);
    
    return res;
}
#endif


@end