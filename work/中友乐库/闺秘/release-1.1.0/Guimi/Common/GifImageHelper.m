//
//  CameraImageHelper.m
//  HelloWorld
//
//  Created by Erica Sadun on 7/21/10.
//  Copyright 2010 Up To No Good, Inc. All rights reserved.
//

#import <CoreVideo/CoreVideo.h>
#import "GifImageHelper.h"
#define FPS 0.25f
#define SCALE 0.67

@interface GifImageHelper()
@property(atomic,assign)NSInteger frameCount;
@property(atomic,assign)NSInteger currentFrame;
@end


@implementation GifImageHelper
@synthesize frameCount,currentFrame;
-(void)setCallBack:(EventCallBack)call
{
    callBack = call;
}

- (id) init
{
	if (self = [super init])
    {
        NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:0],
                             kCGImagePropertyGIFLoopCount,nil];
        fileProperties = [NSDictionary dictionaryWithObjectsAndKeys:dic,kCGImagePropertyGIFDictionary,nil];
        
        
        
        dic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:FPS],
               kCGImagePropertyGIFDelayTime,nil];
        frameProperties =[NSDictionary dictionaryWithObjectsAndKeys:dic,kCGImagePropertyGIFDictionary,nil];
    }
	return self;
}
-(void)processVideo:(NSURL*)path
{
    runOnMainQueueWithoutDeadlocking(^{
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(requestThumbnailImages)
                                                     name:MPMovieDurationAvailableNotification
                                                   object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(addFrame:)
                                                     name:MPMoviePlayerThumbnailImageRequestDidFinishNotification
                                                   object:nil];
        moviePlayerController =[[MPMoviePlayerController alloc]  initWithContentURL:path];
        [moviePlayerController prepareToPlay];
    });
}
-(void)finalizeProcess
{
    runOnMainQueueWithoutDeadlocking(^{
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMovieDurationAvailableNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:nil];
    });
}
-(void)addFrame:(NSNotification*)notification
{
    runOnAsynQueue(^{
        NSDictionary *userInfo = [notification userInfo];
        UIImage *thumbImage = [userInfo valueForKey:MPMoviePlayerThumbnailImageKey];
        if(thumbImage != nil)
        {
            if(currentFrame == 0)
            {
                NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:nil];
                fileURL = [documentsDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%ld.gif",time(NULL)]];
                
                destination = CGImageDestinationCreateWithURL((__bridge CFURLRef)fileURL, kUTTypeGIF, frameCount, NULL);
                CGImageDestinationSetProperties(destination, (__bridge CFDictionaryRef)fileProperties);
            }
            currentFrame++;
            DLog(@"frame:%d,totleFrame:%d",currentFrame,frameCount);
            if(callBack)
            {
                NSNumber* number = [NSNumber numberWithFloat:(float)currentFrame/(float)frameCount];
                callBack(-2,number);
            }
            thumbImage = [thumbImage resizeWithSize:CGSizeMake(320.f, 320.f)];
            if (thumbImage==nil)
            {
                return;
            }
            CGImageDestinationAddImage(destination, thumbImage.CGImage, (__bridge CFDictionaryRef)frameProperties);
        }
        if(currentFrame == frameCount)
        {
            if (!CGImageDestinationFinalize(destination))
            {
                DLog(@"failed to finalize image destination");
            }
            CFRelease(destination);
            [self finalizeProcess];
            if(callBack)
            {
                callBack(-3,fileURL);
            }
        }
    });
}
-(void)requestThumbnailImages
{
    runOnAsynQueue(^{
        if(callBack)
        {
            callBack(-1,nil);
        }
        frameCount = (NSUInteger)(moviePlayerController.duration/FPS);
        self.currentFrame = 0;
        NSMutableArray* times = [[NSMutableArray alloc]init];
        for(int i = 0 ; i < frameCount ; i++)
        {
            [times addObject:[NSNumber numberWithFloat:(float)(i*FPS)]];
        }
        [moviePlayerController requestThumbnailImagesAtTimes:times timeOption:MPMovieTimeOptionExact];
    });
}
+(id)sharedInstance // private
{
    static GifImageHelper* m_instance = nil;
    if(m_instance == nil)
    {
        m_instance = [[self alloc] init];
    }
    return m_instance;
}
@end
