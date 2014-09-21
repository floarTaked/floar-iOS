//
//  CardPreviewViewController.h
//  WeLinked4
//
//  Created by jonas on 5/16/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "Common.h"
#import <ISWebRecognition/ISWebRecognizer.h>
#import <MBProgressHUD.h>
@interface CardPreviewViewController : UIViewController<AVCaptureVideoDataOutputSampleBufferDelegate,UIAlertViewDelegate>
{
    UIView* maskView;
    IBOutlet UIImageView* previewImageView;
    
    ISWebRecognizer* recognizer;
    AVCaptureSession *session;
    
    IBOutlet UIImageView* captureImageView;
    IBOutlet UIButton* takeButton;
    IBOutlet UIButton* cancelButton;
    IBOutlet UIImageView* multiImageView;
    IBOutlet UIImageView* oneImageView;
    IBOutlet UIImageView* qrImageView;
    NSMutableDictionary* parseResult;
}
@property(nonatomic,assign)BOOL fillInfo;
@property(nonatomic, strong) AVCaptureStillImageOutput *stillImageOutput;
@end
