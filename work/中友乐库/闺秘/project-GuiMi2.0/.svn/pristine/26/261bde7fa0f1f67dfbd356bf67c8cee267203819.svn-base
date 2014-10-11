//
//  FriendNumsTableViewCell.m
//  闺秘
//
//  Created by floar on 14-7-18.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "FriendNumsTableViewCell.h"
#import "Package.h"
#import "NetWorkEngine.h"
#import "ShareBlurView.h"
#import <UIImage+Screenshot.h>
#import "AppDelegate.h"
@implementation FriendNumsTableViewCell
{
    
    __weak IBOutlet UILabel *content;
    
    __weak IBOutlet UILabel *friendNumLabel;
    
}

- (void)awakeFromNib
{
    friendNumLabel.textColor = colorWithHex(DeepRedColor);
}

-(void)setFriendNum:(UInt32)friendNum
{
    _friendNum = friendNum;
    if (friendNum > 3)
    {
        content.text = @"邀请更多的朋友，看看她们都有哪些心里话?";
    }
    else if (friendNum < 3 && friendNum > 0)
    {
        content.text = @"朋友的秘密被隐藏了，当你有了3个朋友后就能看到这些秘密了";
    }
    friendNumLabel.text = [NSString stringWithFormat:@"%d",(unsigned int)friendNum];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)inviteBtnAction:(id)sender
{
    if (self.friendNumHandleInviteFriend)
    {
        [MobClick event:share];
        [MobClick event:invite_friends];
        self.friendNumHandleInviteFriend();
    }
    
//        [ShareBlurView show:self type:BlurInviteFriendsType];
    //    AppDelegate* delegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//    
//    ShareBlurView *invite = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
//    [invite shareBlurWithImage:[UIImage imageFromUIView:self] withBlurType:BlurInviteFriendsType];
//    
//    [delegate.window addSubview:invite];
}

- (IBAction)close:(id)sender
{
    
}


@end
