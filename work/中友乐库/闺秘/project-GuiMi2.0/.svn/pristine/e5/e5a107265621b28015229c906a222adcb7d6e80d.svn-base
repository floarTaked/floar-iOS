//
//  MainTableViewCell.m
//  Guimi
//
//  Created by jonas on 9/11/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import "MainTableViewCellView.h"
#import "BlurView.h"
#import "ActionAlertView.h"
@implementation MainTableViewCustomCellView
@synthesize feed;
- (void)awakeFromNib
{
    backView.layer.cornerRadius = 10;
    backView.layer.masksToBounds = YES;
    backView.backgroundColor = getRandomColor();
    
    avatarImageView.image = getRandomImage(@"people",10,NULL);
    
    addressLabel.font = getFontWith(YES, 12);
    addressLabel.textColor = colorWithHex(BackgroundColor5);
    [addressLabel setText:@"深圳"];
    [commentButton setTitle:@"99" forState:UIControlStateNormal];
    [likeButton setTitle:@"99" forState:UIControlStateNormal];
}
-(void)setFeed:(Feed *)fd
{
    feed = fd;
    
    
    if(feed == nil || feed.contentStr == nil || [feed.contentStr length] == 0)
    {
        return;
    }

    float height = [UILabel calculateHeightWith:feed.contentStr font:getFontWith(YES, 14) width:280.0 lineBreakeMode:NSLineBreakByWordWrapping];
    
    
    if(height > content.frame.size.height)
    {
        float diffHeight = height - content.frame.size.height;
        
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                                self.frame.size.width, self.frame.size.height + diffHeight);
        
        content.frame = CGRectMake(content.frame.origin.x, content.frame.origin.y,
                                   content.frame.size.width, content.frame.size.height + diffHeight);
        
        
        bottomView.frame = CGRectMake(bottomView.frame.origin.x, bottomView.frame.origin.y + diffHeight,
                                      bottomView.frame.size.width, bottomView.frame.size.height);
    }
    
    
    NSMutableString* str = [[NSMutableString alloc]init];
    //#464646
    [str appendFormat:@"<p   lineSpacing=0><font color='#464646' face='FZLTZHK--GBK1-0' size=14>%@-%llu</font></p>",feed.contentStr,feed.feedId];
    [content setText:str];
    
    if(feed.feedId % 2 == 0)
    {
        [self processQuestion];
    }
}
-(void)processQuestion
{
    float diffHeight = 20;
    int i = 0;
    //for(int i = 0;i<feed.feedId;i++)
    {
        UIView* choose = [[UIView alloc]initWithFrame:CGRectMake(0, content.frame.origin.y + content.frame.size.height+diffHeight+12,
                                                                  self.frame.size.width, 50)];
        choose.backgroundColor = colorWithHexAlpha(0xAAECEB,0.7);
        
        UIView* percent = [[UIView alloc]initWithFrame:CGRectMake(0, 0, choose.frame.size.width * (0.2*i+0.1), choose.frame.size.height)];
        
        if(i == 0)
        {
            percent.backgroundColor = colorWithHexAlpha(0xEA5BA3, 0.6);
        }
        else
        {
            percent.backgroundColor = colorWithHexAlpha(0xFFFFFF, 0.5);
        }
        
        [choose addSubview:percent];
        
        
        UILabel* percentLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 70, choose.frame.size.height)];
        percentLabel.backgroundColor = [UIColor clearColor];
        percentLabel.textAlignment = NSTextAlignmentCenter;
        percentLabel.textColor = [UIColor darkGrayColor];
        [percentLabel setText:[NSString stringWithFormat:@"%d%%",(int)((0.2*i+0.1)*100)]];
        [choose addSubview:percentLabel];
        
        
        
        UILabel* chooseContent = [[UILabel alloc]initWithFrame:CGRectMake(70, 0,
                                                                         choose.frame.size.width-140,
                                                                         choose.frame.size.height)];
        [chooseContent setText:@"客震动带坏了胖组名"];
        chooseContent.backgroundColor = [UIColor clearColor];
        chooseContent.textAlignment = NSTextAlignmentCenter;
        [choose addSubview:chooseContent];
        [chooseContent setTextColor:[UIColor darkGrayColor]];
        [chooseContent setFont:getFontWith(YES, 16)];
        
        diffHeight += choose.frame.size.height+2;
        [backView addSubview:choose];
    }
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y,
                            self.frame.size.width, self.frame.size.height + diffHeight);
    content.frame = CGRectMake(content.frame.origin.x, content.frame.origin.y,
                               content.frame.size.width, content.frame.size.height + diffHeight);
    bottomView.frame = CGRectMake(bottomView.frame.origin.x, bottomView.frame.origin.y + diffHeight,
                                  bottomView.frame.size.width, bottomView.frame.size.height);
}
-(void)setEventCallBack:(EventCallBack)callback
{
    block = callback;
}

-(IBAction)commemtAction:(id)sender
{
    
}
-(IBAction)likeAction:(id)sender
{
    
}
-(IBAction)shareAction:(id)sender
{
    
}
-(IBAction)moreAction:(id)sender
{
    
}
@end








@implementation MainTableViewContactCellView
- (void)awakeFromNib
{
    backImage.layer.cornerRadius = 10;
    [detailLabel setText:@"为了看到来自闺蜜的秘密,\n请允许「闺蜜」访问你通讯录"];
    actionButton.layer.cornerRadius = 3.0;
    tipLabel.font = getFontWith(YES, 12);
    tipLabel.textColor = colorWithHex(BackgroundColor5);
}
-(void)setEventCallBack:(EventCallBack)callback
{
    block = callback;
}

-(IBAction)action:(id)sender
{
    BlurView* blur = [[BlurView alloc]init];
    UIView* view = [[ActionAlertView sharedInstance] loadContactBookActionView:^(int event, id object)
    {
        if(event == 1)
        {
            [blur hide];
        }
    }];
    [blur setActionView:view];
    [blur show];
}
@end