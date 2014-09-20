//
//  CustomButton.m
//  KitMoreTest
//
//  Created by floar on 14-6-18.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "CustomButton.h"

@interface CustomButton ()

@property (nonatomic, copy) buttionAction buttonActionBlock;

@property (nonatomic, copy) NSString *customTitle;
@property (nonatomic, assign) CGRect customRect;
@property (nonatomic, copy) NSString *customImage;
@property (nonatomic, copy) NSString *customSelectedImage;

@end

@implementation CustomButton

+(instancetype)buttonWithRect:(CGRect)rect btnTitle:(NSString *)title btnImage:(NSString *)image btnSelectedImage:(NSString *)selectedImage
{
    return [[self alloc] initWithRect:rect btnTitle:title btnImage:image btnSelectedImage:selectedImage];
}

-(id)initWithRect:(CGRect)rect btnTitle:(NSString *)title btnImage:(NSString *)image btnSelectedImage:(NSString *)selectedImage
{
    _customTitle = title;
    _customRect = rect;
    _customImage = image;
    _customSelectedImage = selectedImage;
    
//    _customBtnTpye = buttonType;
    return [self init];
}

- (instancetype)init
{
    self = [super initWithFrame:self.customRect];
    if (self) {
//        self.buttonType = self.customBtnTpye;
        if (self.customImage != nil)
        {
            [self setImage:[UIImage imageNamed:self.customImage] forState:UIControlStateNormal];
        }
        else if (self.customSelectedImage != nil)
        {
            [self setImage:[UIImage imageNamed:self.customSelectedImage] forState:UIControlStateSelected];
        }
        [self setTitle:self.customTitle forState:UIControlStateNormal];
        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        
        
    }
    return self;
}

//-(CustomButton *)initButtonWithRect:(CGRect)rect buttonType:(UIButtonType)type
//{
//    self = [UIButton buttonWithType:type];
//    self.frame = rect;
//    
//    return self;
//}

-(void)addButtionAction:(buttionAction)action buttonControlEvent:(UIControlEvents)controlEvent
{
    self.buttonActionBlock = action;
    [self addTarget:self action:@selector(executButtonAction) forControlEvents:controlEvent];
}

-(void)executButtonAction
{
    self.buttonActionBlock();
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
