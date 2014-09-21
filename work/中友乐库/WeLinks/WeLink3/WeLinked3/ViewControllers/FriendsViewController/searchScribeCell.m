//
//  searchScribeCell.m
//  WeLinked3
//
//  Created by floar on 14-4-9.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "searchScribeCell.h"
#import <EGOImageView.h>

@interface searchScribeCell ()

@property (nonatomic, strong) EGOImageView *titleImage;
@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation searchScribeCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setColum:(Column *)colum
{
    _colum = colum;
    self.titleImage.imageURL = [NSURL URLWithString:_colum.img];
    self.titleLabel.text = _colum.title;
}

-(void)initlize
{
    self.titleImage = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
    [self.contentView addSubview:self.titleImage];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.titleImage.frame)+10,CGRectGetMinY(self.titleImage.frame), 200, 40)];
    self.titleLabel.font = getFontWith(NO, 17);
    [self.contentView addSubview:self.titleLabel];
}

-(void)dealloc
{
    self.titleLabel = nil;
    self.titleImage = nil;
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
