//
//  HeaderViewOfTableView.m
//  UITableViewTest
//
//  Created by floar on 14-9-3.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "HeaderViewOfTableView.h"

@implementation HeaderViewOfTableView
{
    UIView *bottonView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)initalize
{
    bottonView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:bottonView];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.offSetY = scrollView.contentOffset.y;
}

-(void)setOffSetY:(double)offSetY
{
    _offSetY = offSetY;
    if (offSetY < 0)
    {
        
    }
    else
    {
        
    }
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
