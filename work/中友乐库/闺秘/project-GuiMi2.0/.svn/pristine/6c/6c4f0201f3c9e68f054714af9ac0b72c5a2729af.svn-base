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
    __weak IBOutlet UIImageView* maskView;
    __weak IBOutlet EGOImageView *BGImageView;
    
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
    self.layer.cornerRadius = 5;
    contentLabel.font = getFontWith(NO, 14);
}

-(void)setCellFeed:(Feed *)cellFeed
{
    _cellFeed = cellFeed;
    
    NSRange range = [cellFeed.imageStr rangeOfString:@"http"];
    if (range.location != NSNotFound)
    {
        BGImageView.image = nil;
        BGImageView.imageURL = [NSURL URLWithString:cellFeed.imageStr];
    }
    else
    {
        NSRange imgNumRange = [cellFeed.imageStr rangeOfString:@"12"];
        if (imgNumRange.location != NSNotFound)
        {
            BGImageView.image = [UIImage imageNamed:@"img_secretCell_background_2"];
        }
        else
        {
            BGImageView.image = [UIImage imageNamed:cellFeed.imageStr];
        }
    }
    BOOL needMask = YES;
    contentLabel.text = cellFeed.contentStr;
    NSString* sql = [NSString stringWithFormat:@" where DBUid = %llu and feedId = %llu order by createTime desc limit 1 offset 0",
                     [UserInfo myselfInstance].userId,cellFeed.feedId];
    NSArray* array = [[UserDataBaseManager sharedInstance] queryWithClass:[Notice class]
                                                                tableName:nil
                                                                condition:sql];
    if(array != nil && [array count]>0)
    {
        Notice* notice = [array objectAtIndex:0];
        if(notice != nil)
        {
            if(notice.type == 1)
            {
                needMask = NO;
                noticemageView.image = [UIImage imageNamed:@"img_messageComment"];
            }
            else if(notice.type == 2)
            {
                needMask = NO;
                noticemageView.image = [UIImage imageNamed:@"img_messageLike"];
            }
        }
    }
    if(needMask)
    {
        maskView.hidden = NO;
    }
    else
    {
        maskView.hidden = YES;
    }
}

@end
