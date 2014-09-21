//
//  SystemFeedTableViewCell.m
//  WeLinked3
//
//  Created by 牟 文斌 on 4/10/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "SystemFeedTableViewCell.h"
#import "RCLabel.h"
#import <EGOImageView.h>
#import "UserInfo.h"

@interface SystemFeedTableViewCell()
@property (weak, nonatomic) IBOutlet EGOImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet RCLabel *content;
@property (weak, nonatomic) IBOutlet UIView *userHeadContainView;
@property (weak, nonatomic) IBOutlet UIView *headerLine;

@end

@implementation SystemFeedTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setFeed:(Feeds *)feed
{
    if (_feed == feed) {
        return;
    }
    _feed = feed;
    _userIcon.imageURL = [NSURL URLWithString:_feed.userAvatar];
    _userName.text = _feed.userName;
    
    _timeLabel.text = [Common timeIntervalStringFromTime:_feed.createTime];
    _timeLabel.font = getFontWith(NO, 8);
    _timeLabel.textColor = colorWithHex(0x999999);
    
    [_content setText:[NSString stringWithFormat:@"<p><font size = 14 color='#333333' face = Hiragino Kaku Gothic ProN W3>%@ </font></p>",_feed.content]];
    
    for (UIView *view in self.userHeadContainView.subviews) {
        if (view.tag != 1000) {
            [view removeFromSuperview];
        }
        
    }
    
    NSError* error = nil;
    id data = nil;
    if (_feed.targetContent.length) {
        data = [NSJSONSerialization JSONObjectWithData:[_feed.targetContent dataUsingEncoding:NSUTF8StringEncoding]
                                               options:NSJSONReadingMutableLeaves error:&error];
    }
    if(error != nil)
    {
        data = nil;
    }
    
    for (int i = 0; i < [(NSArray *)data count] ; i ++) {
        NSDictionary *dic = [data objectAtIndex:i];
        UserInfo *user = [[UserInfo alloc] init];
        [user setValuesForKeysWithDictionary:dic];
        EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(10 + 40 * i , 10, 35, 35)];
        imageView.imageURL = [NSURL URLWithString:user.avatar];
        
        [self.userHeadContainView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(imageView.x, imageView.bottom  , imageView.width , 20)];
        label.font = getFontWith(NO, 10);
        label.textColor = colorWithHex(0x999999);
        label.text = user.name;
        [self.userHeadContainView addSubview:label];
        
    }
    
}

-(void)layoutSubviews
{
    [super layoutSubviews];
    self.content.height = [self.content optimumSize].height;
    self.userHeadContainView.y = self.content.bottom + 10;
    self.headerLine.height = 0.5;
}

@end
