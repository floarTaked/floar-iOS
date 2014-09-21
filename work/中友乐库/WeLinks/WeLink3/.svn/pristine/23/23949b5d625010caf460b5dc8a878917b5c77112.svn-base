//
//  UserHeadTableCell.m
//  WeLinked3
//
//  Created by 牟 文斌 on 2/28/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "UserHeadTableCell.h"
#import "UserInfo.h"

@implementation UserHeadTableCell
{
    UIView *_headContainView;
}

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self initlize];
    }
    return self;
}

- (void)initlize
{
    _headContainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width - 30, self.height)];
    _headContainView.clipsToBounds = YES;
    _headContainView.backgroundColor = [UIColor clearColor];
    [self.contentView addSubview:_headContainView];
    self.friendList = [NSMutableArray array];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)layoutSubviews
{
    [super layoutSubviews];
    for (UIView *view in _headContainView.subviews) {
        [view removeFromSuperview];
    }
    for (int i = 0; i < self.friendList.count; i ++) {
        NSString *imageString = [self.friendList objectAtIndex:i];
        EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(10 + 40 * i, 10, 35, 35)];
        imageView.imageURL = [NSURL URLWithString:imageString];
        [_headContainView addSubview:imageView];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = imageView.bounds;
        button.tag = i;
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [imageView addSubview:button];
    }
}

- (void)buttonClicked:(UIButton *)button
{
    if ([_delegate respondsToSelector:@selector(userHeadTableCell:DidSelectUserAtIndex:)]) {
        [_delegate userHeadTableCell:self DidSelectUserAtIndex:button.tag];
    }
}

@end
