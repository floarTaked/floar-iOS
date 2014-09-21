//
//  SupportCell.m
//  WeLinked3
//
//  Created by Caesar on 14-3-21.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "SupportCell.h"
#import <EGOImageView.h>

@interface SupportCell ()
{
    CGSize size;
    
}
@property (nonatomic ,strong) EGOImageView *userHead;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *jobTitle;
@property (nonatomic, strong) UILabel *company;

@end

@implementation SupportCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)setSupport:(Support *)support
{
    _support = support;
    self.userHead.imageURL = [NSURL URLWithString:_support.userAvatar];
    self.userName.text = _support.userName;
    self.company.text = _support.userCompany;
    if (isSystemVersionIOS7())
    {
        size = [self.support.userCompany boundingRectWithSize:CGSizeMake(self.contentView.frame.size.width , CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.company.font,NSFontAttributeName, nil] context:nil].size;
    }else
    {
        size = [self.support.userCompany sizeWithFont:self.company.font constrainedToSize:CGSizeMake(self.contentView.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    }
    [self initlize];
    self.jobTitle.text = _support.userJob;
    
}

- (void)initlize
{
    self.userHead = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10,60, 60)];
    [self.contentView addSubview:self.userHead];
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userHead.frame) + 10, 5, 200, 40)];
    self.userName.font = getFontWith(NO, 18);
    self.userName.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.userName];
    
    self.company = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userHead.frame)+10, CGRectGetMaxY(self.userName.frame)-5, size.width, size.height)];
    self.company.font = getFontWith(NO, 14);
    self.company.text = self.support.userCompany;
    self.company.textColor = colorWithHex(0x999999);
    [self.contentView addSubview:self.company];
    
    self.jobTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.company.frame)+7, CGRectGetMaxY(self.userName.frame)-10, 300-CGRectGetMaxX(self.company.frame)-10, 30)];
    self.jobTitle.font = getFontWith(NO, 14);
    self.jobTitle.textColor = colorWithHex(0x999999);
    [self.contentView addSubview:self.jobTitle];
    
    
}

- (void)dealloc
{
    self.userName = nil;
    self.userHead = nil;
    self.jobTitle = nil;
    self.company = nil;
}


-(void)layoutSubviews
{
    [super layoutSubviews];
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
