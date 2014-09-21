//
//  BasePickerView.m
//  WeLinked3
//
//  Created by jonas on 2/27/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "BasePickerView.h"

@implementation BasePickerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initlize];
    }
    return self;
}

-(id)init
{
    self = [super init];
    if(self)
    {
        [self initlize];
    }
    return self;
}
-(void)initlize
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.frame = CGRectMake(0, bounds.size.height, bounds.size.width, 260);
    self.backgroundColor = [UIColor clearColor];
    
    UIImage *backgroundImage = [[UIImage imageNamed:@"wheel_bg"] stretchableImageWithLeftCapWidth:4 topCapHeight:0];
    
    UIImageView* backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    backgroundView.frame = CGRectMake(0, 44, self.frame.size.width, self.frame.size.height-44);
    [self addSubview:backgroundView];
    
    // Add shadow to wheel
    UIImageView *shadow = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"wheel_shadow"]];
    shadow.frame = backgroundView.frame;
    [self addSubview:shadow];
    
    
    
    UIImageView *leftBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_left"]];
    leftBorder.frame = CGRectMake(0, 44, 15, self.frame.size.height-44);
    [self addSubview:leftBorder];
    
    UIImageView *rightBorder = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"frame_right"]];
    rightBorder.frame = CGRectMake(self.frame.size.width - 15, 44, 15, self.frame.size.height-44);
    [self addSubview:rightBorder];
    UIImageView *middleBorder = [[UIImageView alloc] initWithImage:
                                 [[UIImage imageNamed:@"frame_middle"]
                                  stretchableImageWithLeftCapWidth:0 topCapHeight:10]];
    middleBorder.frame = CGRectMake(15, 44, self.frame.size.width - 30, self.frame.size.height-44);
    [self addSubview:middleBorder];
    
    
    
    //创建工具栏
    NSMutableArray *items = [[NSMutableArray alloc] initWithCapacity:3];
	UIBarButtonItem *confirmBtn = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                   style:UIBarButtonItemStyleDone
                                                                  target:self
                                                                  action:@selector(confirmPicker)];
    
	UIBarButtonItem *flexibleSpaceItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                                       target:nil
                                                                                       action:nil];
	UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc] initWithTitle:@"取消"
                                                                  style:UIBarButtonItemStyleBordered
                                                                 target:self
                                                                 action:@selector(hide)];
    [items addObject:cancelBtn];
    [items addObject:flexibleSpaceItem];
    [items addObject:confirmBtn];
    
    if (toolBar==nil)
    {
        toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 44)];
    }
    toolBar.hidden = NO;
    toolBar.barStyle = UIBarStyleBlackTranslucent;
    toolBar.items = items;
    toolBar.userInteractionEnabled = YES;
    [self addSubview:toolBar];
    self.userInteractionEnabled = YES;
    
    basePickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 44, self.frame.size.width, 216)];
    [self addSubview:basePickerView];
    basePickerView.showsSelectionIndicator = YES;
}
-(void)confirmPicker
{
}
-(void)showWithObject:(id)object block:(EventCallBack)block
{
    
}
-(void)hide
{
}

@end
