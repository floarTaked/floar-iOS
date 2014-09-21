//
//  HeadView.m
//  WeLinked4
//
//  Created by floar on 14-5-30.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "HeadView.h"
#import "RCLabel.h"

@implementation HeadView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

-(void)setFeed:(Feed *)feed
{
    EGOImageView *image = (EGOImageView *)[self viewWithTag:10];
    if (image == nil)
    {
        image = [[EGOImageView alloc] initWithFrame:CGRectMake(15, 15, 30, 30)];
        image.tag = 10;
        image.backgroundColor = [UIColor orangeColor];
        image.imageURL = [NSURL URLWithString:self.feed.userInfo.avatar];
        [self addSubview:image];
    }
    
    UILabel *nameLabel = (UILabel *)[self viewWithTag:20];
    if (nameLabel == nil)
    {
        nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(image.frame)+10, CGRectGetMinX(image.frame)-1, 200, 20)];
        nameLabel.tag = 20;
        nameLabel.font = getFontWith(YES, 14);
        nameLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:nameLabel];
    }
    
    UIButton *btn = (UIButton *)[self viewWithTag:50];
    if (btn == nil)
    {
        btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(280, 15, 22, 22);
        btn.tag = 50;
        [btn setImage:[UIImage imageNamed:@"btn_more_n"] forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"btn_more_h"] forState:UIControlStateHighlighted];
        [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    RCLabel *subLabel = (RCLabel *)[self viewWithTag:30];
    if (subLabel == nil)
    {
        subLabel = [[RCLabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(nameLabel.frame), CGRectGetMaxY(nameLabel.frame), 300, 10)];
        subLabel.tag = 30;
        subLabel.textAlignment = NSTextAlignmentLeft;
        subLabel.font = getFontWith(NO, 10);
        subLabel.textColor = colorWithHex(0xAAAAAA);
        [self addSubview:subLabel];
    }
    
    UILabel *questionLabel = (UILabel *)[self viewWithTag:40];
    if (questionLabel == nil)
    {
        questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, CGRectGetMaxY(image.frame)+10, 200, 20)];
        questionLabel.tag = 40;
        questionLabel.textAlignment = NSTextAlignmentLeft;
        questionLabel.font = getFontWith(NO, 14);
        questionLabel.textColor = colorWithHex(0xAAAAAA);
        [self addSubview:questionLabel];
    }
    
    if (feed == nil)
    {
        image.placeholderImage = [UIImage imageNamed:@"defaultHead"];
        nameLabel.text = @"雷军";
        [subLabel setText:[NSString stringWithFormat:@"<font size=10 color='#999999'>%@  %@ %@</font>",@"1分钟前",@"小米科技",@"董事长"]];
        questionLabel.text = @"提出了一个问题";
    }
}

-(void)btnAction
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"举报" delegate:self cancelButtonTitle:@"举报" otherButtonTitles:nil];
    [alertView show];
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
