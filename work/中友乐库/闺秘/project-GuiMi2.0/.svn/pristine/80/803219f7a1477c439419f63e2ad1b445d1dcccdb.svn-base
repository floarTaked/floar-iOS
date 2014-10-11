//
//  QuestionFeedTableViewCell.m
//  闺秘
//
//  Created by floar on 14-7-18.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "QuestionFeedTableViewCell.h"
#import "DataBaseManager.h"


@implementation QuestionFeedTableViewCell
{
    
    __weak IBOutlet UIButton *changeBtn;
    
    __weak IBOutlet UILabel *contentLabel;
    
    __weak IBOutlet EGOImageView *cellBg;
    
    
    int num;
    
}

- (void)awakeFromNib
{
    num = 0;
    contentLabel.font = getFontWith(NO, 20);
    
    [self changeQuestionFeed:nil];
}

- (IBAction)btnPublishSecretAction:(id)sender
{
    if (self.handlePublishSecretFromCell)
    {
        self.handlePublishSecretFromCell();
    }
}

- (IBAction)btnFriendAnswerAction:(id)sender
{
    [MobClick event:share];
    if (self.handleInviteFriendAnswer)
    {
        self.handleInviteFriendAnswer();
    }
}

- (IBAction)changeQuestionFeed:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    CAKeyframeAnimation *theAnimation = [CAKeyframeAnimation animation];
	theAnimation.values = [NSArray arrayWithObjects:
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0, 0,0,1)],
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.13, 0,0,1)],
						   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(6.26, 0,0,1)],
						   nil];
	theAnimation.cumulative = YES;
	theAnimation.duration = 0.7;
	theAnimation.repeatCount = 1.5;
	theAnimation.removedOnCompletion = YES;
    [btn.layer addAnimation:theAnimation forKey:@"transform"];
    

    
    NSArray *arr = [[UserDataBaseManager sharedInstance] queryWithClass:[Feed class] tableName:@"QUESTIONFEED" condition:nil];
    if (arr != nil && arr.count > 0)
    {
        if (arr.count == 1)
        {
            num = 0;
        }
        else
        {
            num++;
            if (num > arr.count-1)
            {
                num = 0;
            }
        }
        Feed *questionFeed = [arr objectAtIndex:num];
        if (questionFeed.contentStr != nil && questionFeed.contentStr.length > 0 && questionFeed.imageStr != nil && questionFeed.imageStr.length > 0)
        {
            [self setQuestionFeed:questionFeed];
        }
    }
}

-(void)setQuestionFeed:(Feed *)questionFeed
{
    if (questionFeed != nil && questionFeed.imageStr.length > 0 && questionFeed.contentStr.length > 0)
    {
        NSRange range = [questionFeed.imageStr rangeOfString:@"http"];
        if (range.location != NSNotFound)
        {
            cellBg.imageURL = [NSURL URLWithString:questionFeed.imageStr];
        }
        else
        {
            NSRange imgNumRange = [questionFeed.imageStr rangeOfString:@"12"];
            if (imgNumRange.location != NSNotFound)
            {
                cellBg.image = [UIImage imageNamed:@"img_secretCell_background_2"];
            }
            else
            {
                cellBg.image = [UIImage imageNamed:questionFeed.imageStr];
            }
        }
        
        contentLabel.text = questionFeed.contentStr;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
