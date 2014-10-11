//
//  CameraImageHelper.h
//  HelloWorld
//
//  Created by Erica Sadun on 7/21/10.
//  Copyright 2010 Up To No Good, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <MediaPlayer/MediaPlayer.h>
#import "Common.h"
//#import <GifEncode.h>
//#import <giflib_ios.h>

@interface GifImageHelper : NSObject
{
    NSURL *fileURL;
    NSDictionary *fileProperties;
    NSDictionary *frameProperties;
    CGImageDestinationRef destination;
    MPMoviePlayerController* moviePlayerController;
    NSInteger frameCount;
    NSInteger currentFrame;
    EventCallBack callBack;
}
-(void)setCallBack:(EventCallBack)call;
-(void)processVideo:(NSURL*)path;
+(id)sharedInstance;
@end
