//
//  VoteView.m
//  WeLinked4
//
//  Created by floar on 14-5-30.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "VoteView.h"
#import "CustomProcessView.h"
#import "DetailRateViewController.h"

@implementation VoteView
{
    CustomProcessView *processView;
    
    CGRect lrect;
    
    UIButton *voteBtn;
    UIView *bottonView;
    UILabel *voteLabel;
    
    NSArray *longthChangeArray;
    NSArray *foreArray;
    NSArray *titleArray;
}

@synthesize processView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        lrect = frame;
        self.userInteractionEnabled = YES;
        
    }
    return self;
}

//-(void)setVoteType:(VoteType)voteType
//{
//    if (voteType == voteTypeHttp)
//    {
//        
//    }
//    else
//    {
//        
//    }
//}

-(void)setVoteCount:(int)voteCount
{
    NSArray *longthArray = @[@"0",@"0",@"0"];
    longthChangeArray = @[@"0.4",@"0.6",@"0.8"];
    
    NSArray *backgoundArray = @[[UIColor orangeColor],[UIColor orangeColor],[UIColor orangeColor]];

    foreArray = @[[UIColor blueColor],[UIColor greenColor],[UIColor redColor]];
    titleArray = @[@"好疼",@"疼",@"有点疼"];
    
    bottonView = [[UIView alloc] initWithFrame:CGRectMake(0, 40*voteCount, 320, 30)];
    bottonView.userInteractionEnabled = NO;
    [self addSubview:bottonView];
    
    UIView* line = [bottonView viewWithTag:300];
    if(line == nil)
    {
        line = [[UIView alloc]initWithFrame:CGRectMake(0, bottonView.height-0.5, 320, 0.5)];
        line.backgroundColor = colorWithHex(0xCCCCCC);
        line.tag = 300;
        [bottonView addSubview:line];
    }
    
    if (voteCount > 0)
    {
        if (voteLabel == nil)
        {
            voteLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,5, 290, 20)];
            voteLabel.font = getFontWith(NO, 10);
            voteLabel.textColor = colorWithHex(0xAAAAAA);
            voteLabel.text = [NSString stringWithFormat:@"【169人已参与,投票以后可以查看评论】"];
            voteLabel.textAlignment = NSTextAlignmentCenter;
            [bottonView addSubview:voteLabel];
        }

        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoVoteDetail)];
        [bottonView addGestureRecognizer:tap];
        
        self.frame = CGRectMake(lrect.origin.x, lrect.origin.y, 320, CGRectGetMaxY(bottonView.frame)+5);
        
        for (int i = 0; i<voteCount; i++)
        {
            processView = (CustomProcessView *)[self viewWithTag:100+i];
            if (processView == nil)
            {
                processView = [[CustomProcessView alloc] initWithFrame:CGRectMake(0,40*i, 320, 40)];
                processView.tag = 100+i;
                processView.delegate = self;
                processView.foreLongth = [[longthArray objectAtIndex:i] doubleValue];
                processView.backgroundColor = [backgoundArray objectAtIndex:i];
                processView.foreColor = [foreArray objectAtIndex:i];
                processView.title = [titleArray objectAtIndex:i];
                [self addSubview:processView];
            }
        }
    }
    
    else if (voteCount == 0)
    {
        NSLog(@"-----其他类型");
    }
}

-(void)gotoVoteDetail
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeView" object:nil];
}

#pragma mark - 修改voteLabel.text delegate
-(void)makeVoteViewChange
{
    [voteLabel removeFromSuperview];
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(225, 10, 85, 12)];
    image.image = [UIImage imageNamed:@"img_seevoteDetail"];
    [bottonView addSubview:image];
    
    NSString *voteLabelNewString = [NSString stringWithFormat:@"169人已参与,"];
    CGSize size = [UILabel calculateCGSizeWith:voteLabelNewString height:20 width:2000 font:[UIFont systemFontOfSize:12]];
    
    UILabel *newVoteLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(image.frame)-size.width, CGRectGetMinY(image.frame)-2, size.width, size.height)];
    newVoteLabel.textColor = [UIColor blueColor];
    newVoteLabel.font = [UIFont systemFontOfSize:12];
    newVoteLabel.text = voteLabelNewString;
    [bottonView addSubview:newVoteLabel];
    
    UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMinX(newVoteLabel.frame)-15, CGRectGetMinY(image.frame)-2, 13, 12)];
    headImageView.image = [UIImage imageNamed:@"img_vote"];
    [bottonView addSubview:headImageView];
    
    bottonView.userInteractionEnabled = YES;
    
    for (CustomProcessView *view in self.subviews)
    {
        if ([view isKindOfClass:[CustomProcessView class]])
        {
            view.foreLongth = [[longthChangeArray objectAtIndex:view.tag-100] doubleValue];
            view.foreColor = [foreArray objectAtIndex:view.tag - 100];
            view.title = [titleArray objectAtIndex:view.tag - 100];

        }

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
