//
//  InviteFriends.m
//  闺秘
//
//  Created by floar on 14-7-15.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "InviteFriends.h"
#import "LogicManager.h"

@implementation InviteFriends
{
    __weak IBOutlet UILabel *inviteLabel;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

-(void)awakeFromNib
{
    inviteLabel.font = getFontWith(YES, 20);
    inviteLabel.textColor = colorWithHex(0xD0246C);
}


/*
 聊天界面
 WXSceneSession  = 0,
 朋友圈
 WXSceneTimeline = 1
 收藏
 WXSceneFavorite = 2
 */

- (IBAction)inviteWeChat:(id)sender
{
    [MobClick event:share_weixin];
    [[LogicManager sharedInstance] sendWechatWithTitle:@"和我一起玩「闺秘」吧!" describe:@"八卦、爆料、真心话...这里是女生专属秘密交流聚集地，快来分享闺蜜之间的秘密。猛戳下载https://itunes.apple.com/us/app/gui-mi/id903777968?l=zh&ls=1&mt=8" identify:@"testIdentify" image:[UIImage imageNamed:@"58x58"] scene:0 contentCode:0 feedId:0];
}


- (IBAction)inviteCircle:(id)sender
{
    [MobClick event:share_friend_circle];
    [[LogicManager sharedInstance] sendWechatWithTitle:@"和我一起玩「闺秘」吧!" describe:@"八卦、爆料、真心话...这里是女生专属秘密交流聚集地，快来分享闺蜜之间的秘密。猛戳下载https://itunes.apple.com/us/app/gui-mi/id903777968?l=zh&ls=1&mt=8" identify:@"testIdentify" image:[UIImage imageNamed:@"58x58"] scene:1 contentCode:0 feedId:0];
}

- (IBAction)inviteWeibo:(id)sender
{
    [MobClick event:share_weibo];
    [[LogicManager sharedInstance] sendWeiBoWithTitle:@"闺秘" desribe:@"和我一起玩「闺秘」吧！八卦、爆料、真心话...这里是女生专属秘密交流聚集地，快来分享闺蜜之间的秘密" image:[UIImage imageNamed:@"58x58"] contentCode:0 feedId:0];
}

- (IBAction)inviteMessage:(id)sender
{
    [MobClick event:share_message];
    if (self.handleInviteFriendMessageBlock)
    {
        self.handleInviteFriendMessageBlock();
    }
}

- (IBAction)btnClose:(id)sender
{
    [MobClick event:share_dialog_close];
    [self.superview removeFromSuperview];
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
