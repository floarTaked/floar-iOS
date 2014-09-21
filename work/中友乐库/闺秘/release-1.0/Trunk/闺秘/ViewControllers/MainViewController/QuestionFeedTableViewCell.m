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
    if (self.handleInviteFriendAnswer)
    {
        self.handleInviteFriendAnswer();
    }
}

- (IBAction)changeQuestionFeed:(id)sender
{
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
        [self setQuestionFeed:questionFeed];
    }
}

-(void)setQuestionFeed:(Feed *)questionFeed
{
    if (questionFeed != nil)
    {
        cellBg.image = [UIImage imageNamed:questionFeed.imageStr];
        contentLabel.text = questionFeed.contentStr;
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
