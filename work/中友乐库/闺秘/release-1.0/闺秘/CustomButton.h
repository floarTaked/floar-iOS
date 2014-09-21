//
//  CustomButton.h
//  KitMoreTest
//
//  Created by floar on 14-6-18.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^buttionAction)();

@interface CustomButton : UIButton

@property (nonatomic, strong) id extraData;

+(instancetype)buttonWithRect:(CGRect)rect btnTitle:(NSString *)title btnImage:(NSString *)image btnSelectedImage:(NSString *)selectedImage;

-(void)addButtionAction:(buttionAction)action buttonControlEvent:(UIControlEvents)controlEvent;

@end
