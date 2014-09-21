//
//  ShareBlurView.h
//  闺秘
//
//  Created by floar on 14-6-26.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

typedef enum {
    BlurCellShareType = 1,
    BlurCommitType,
    BlurWhoSeeSecretType,
    BlurSettingType,
    BlurInviteFriendsType,
    BlurReportReasonType,
    BlurSplashPhoneType,
    BLurLogoutType,
    BlurClearMarkType,
    BlurTipsType,
    BlurPhoneBookAlertType,
    BlurJustExperienceType
}BlurSubViewType;

#import <UIKit/UIKit.h>
#import "InviteFriends.h"
#import "ClearMarkView.h"
#import "MainAgainstView.h"
#import "NavSettingAppearView.h"
#import "ReportReasonView.h"
#import "CellShareView.h"
#import "SplashPhoneView.h"
#import "Tips.h"
#import "AllowToVisitPhoneBookView.h"
#import "JustExperienceView.h"

#import "Package.h"
#import "NetWorkEngine.h"

@interface ShareBlurView : UIView

@property (nonatomic, assign) uint64_t feedId;
@property (nonatomic, strong) MainAgainstView *mainAgainst;
@property (nonatomic, strong) CellShareView *cellShare;
@property (nonatomic, strong) NavSettingAppearView *navSettingAppear;
@property (nonatomic, strong) InviteFriends *inviteNavSetting;
@property (nonatomic, strong) Tips *tip;
@property (nonatomic, assign) int tipsHeight;

-(void)shareBlurWithImage:(UIImage *)shotImage withBlurType:(BlurSubViewType) blurType;
-(void)tapAction;
+(ShareBlurView*)show:(id)delegate type:(BlurSubViewType)type;
@end


#pragma mark - WhoSeeSecretAlertView
@interface WhoSeeSecretAlertView : UIView

-(void)whoSeeSecretViewShow;

@end

#pragma mark - LogoutView
@interface LogoutView : UIView

-(void)logoutViewShow;
@end

