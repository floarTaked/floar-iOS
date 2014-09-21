//
//  LogicManager+ImagePiker.h
//  WeLinked4
//
//  Created by jonas on 5/29/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "LogicManager.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "ImageEditorViewController.h"
@interface LogicManager (ImagePiker)
-(void)getImage:(UIViewController*)controller block:(EventCallBack)block;
@end
