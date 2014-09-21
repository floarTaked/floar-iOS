//
//  MessageCollectionCell.m
//  闺秘
//
//  Created by floar on 14-6-25.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "MessageCollectionCell.h"
#import "LogicManager.h"

@implementation MessageCollectionCell
{
    
    __weak IBOutlet UIImageView *BGImageView;
    
    __weak IBOutlet UILabel *contentLabel;
    
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    contentLabel.font = getFontWith(NO, 14);
}

-(void)setCellFeed:(Feed *)cellFeed
{
    _cellFeed = cellFeed;
    BGImageView.image = [UIImage imageNamed:cellFeed.imageStr];
    contentLabel.text = cellFeed.contentStr;
    int i = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"feedCollect"];
    if (0 == i)
    {
        [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:2] withKey:@"feedCollect"];
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
