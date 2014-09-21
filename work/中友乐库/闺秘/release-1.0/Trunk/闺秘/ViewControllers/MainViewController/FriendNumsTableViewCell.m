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

@implementation FriendNumsTableViewCell
{
    
    __weak IBOutlet UILabel *content;
    
    __weak IBOutlet UILabel *friendNumLabel;
    
}

- (void)awakeFromNib
{
    friendNumLabel.textColor = colorWithHex(DeepRedColor);
    
    int localNum = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"friendNum"];
    
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:FetchNumberOfFriendsCode block:^(int event, id object) {
        if (1 == event)
        {
            Package *pack = (Package *)object;
            int friendNum = [pack handleFetchNumberOfFriends:pack withErrorCode:NoCheckErrorCode];
            if (-1 == friendNum)
            {
                
            }
            else
            {
                [[LogicManager sharedInstance] setPersistenceData:[NSNumber numberWithInt:friendNum] withKey:@"friendNum"];
                if (friendNum > 3)
                {
                    content.text = @"邀请更多的朋友，看看她们都有哪些心里话?";
                }
                friendNumLabel.text = [NSString stringWithFormat:@"%d",friendNum];
            }
        }
    }];
    if (localNum > 3)
    {
        content.text = @"邀请更多的朋友，看看她们都有哪些心里话?";
    }
    
    friendNumLabel.text = [NSString stringWithFormat:@"%d",localNum];
    Package *pack = [[Package alloc] initWithSubSystem:UserBasicInfoSubSys withSubProcotol:0x0d];
    [pack fetchNumberOfFriendsWithUserId:[UserInfo myselfInstance].userId userKey:[UserInfo myselfInstance].userKey];
    [[NetWorkEngine shareInstance] sendData:pack UniqueCode:FetchNumberOfFriendsCode block:^(int event, id object) {
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)inviteBtnAction:(id)sender
{
    ShareBlurView *invite = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [invite shareBlurWithImage:[UIImage imageFromUIView:self] withBlurType:BlurInviteFriendsType];
    [self addSubview:invite];
}

- (IBAction)close:(id)sender
{
    
}


@end
