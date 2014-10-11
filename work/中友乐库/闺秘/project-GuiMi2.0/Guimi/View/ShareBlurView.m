//
//  ShareBlurView.m
//  闺秘
//
//  Created by floar on 14-6-26.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "ShareBlurView.h"
#import "LogicManager.h"
#import "SplashViewController.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "DataBaseManager.h"
#import <POP.h>
#import "AppDelegate.h"
#import <UIImage+Screenshot.h>
const float bottonY = 568+2;

#import <UIImage+Blur.h>

#pragma mark - blruView-for-BottonView
@implementation ShareBlurView
{
    UIImageView *blurImageView;
    UITapGestureRecognizer *tap;
    WhoSeeSecretAlertView *whoSeeSecretView;
    LogoutView *logout;
    ReportReasonView *reason;
    AllowToVisitPhoneBookView *allowPhoneBook;
    JustExperienceView *experienceView;
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        blurImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        blurImageView.backgroundColor = [UIColor blackColor];
        [self addSubview:blurImageView];
        
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

-(void)shareBlurWithImage:(UIImage *)shotImage withBlurType:(BlurSubViewType)blurType
{
    if (shotImage != nil)
    {
        float quality = .00002f;
        float blurred = .6f;

        NSData *dataImg = UIImageJPEGRepresentation(shotImage, quality);
        UIImage *blurredImage = [[UIImage imageWithData:dataImg] blurredImage:blurred];
        blurImageView.image = blurredImage;
        
        UIView *overlayView = [[UIImageView alloc] initWithFrame:blurImageView.frame];
        overlayView.alpha = 0.5;
        overlayView.backgroundColor = colorWithHex(0x666666);
        [blurImageView addSubview:overlayView];
    }
    else
    {
        DLog(@"shotImage error");
    }
    
    if (blurType == BlurCellShareType)
    {
        
        _cellShare = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([CellShareView class]) owner:self options:nil] lastObject];
        _cellShare.center = self.center;
        _cellShare.layer.cornerRadius = 5.0f;
        _cellShare.layer.borderColor = [UIColor redColor].CGColor;
        [self addSubview:_cellShare];
        [UIView animateWithDuration:0.2 animations:
         ^(void){
             _cellShare.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.1f, 1.1f);
             _cellShare.alpha = 0.5;
         }completion:^(BOOL finished)
         {
             [self bounceOutAnimationStoped:_cellShare];
         }];
    }
    else if (blurType == BlurCommitType)
    {
        _mainAgainst = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([MainAgainstView class]) owner:self options:nil] lastObject];
        _mainAgainst.layer.cornerRadius = 5.0f;
        
        POPSpringAnimation *animation = [POPSpringAnimation animation];
        animation.property = [POPAnimatableProperty propertyWithName:kPOPLayerTranslationX];
        animation.fromValue = @300.0;
        animation.toValue = @0.0;
        animation.springBounciness = 13.0;
        animation.springSpeed = 20.0;
        [_mainAgainst.layer pop_addAnimation:animation forKey:@"pop"];
        _mainAgainst.center = self.center;
        
        [self addSubview:_mainAgainst];
    }
    else if (blurType == BlurWhoSeeSecretType)
    {
        whoSeeSecretView = [[WhoSeeSecretAlertView alloc] initWithFrame:CGRectMake(15, 190, 290, 195)];
        [whoSeeSecretView whoSeeSecretViewShow];
        whoSeeSecretView.backgroundColor = [UIColor whiteColor];
        whoSeeSecretView.layer.cornerRadius = 5.0f;
        [self addSubview:whoSeeSecretView];
    }
    else if (blurType == BlurSettingType)
    {
        _navSettingAppear = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([NavSettingAppearView class]) owner:self options:nil] lastObject];
        
        POPSpringAnimation *animation = [POPSpringAnimation animation];
        animation.property = [POPAnimatableProperty propertyWithName:kPOPLayerTranslationY];
        animation.fromValue = @300.0;
        animation.toValue = @0.0;
        animation.springBounciness = 13.0;
        animation.springSpeed = 20.0;
        [_navSettingAppear.layer pop_addAnimation:animation forKey:@"pop"];
        _navSettingAppear.frame = CGRectMake(0, 80, CGRectGetWidth(_navSettingAppear.frame), CGRectGetHeight(_navSettingAppear.frame));
        [self addSubview:_navSettingAppear];
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        closeBtn.frame = CGRectMake(5, 20, 44, 44);
        [closeBtn setBackgroundImage:[UIImage imageNamed:@"btn_close_n"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(navSettingCloseBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closeBtn];
    }
    else if (blurType == BlurInviteFriendsType)
    {
        _inviteNavSetting = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([InviteFriends class]) owner:self options:nil] firstObject];
        _inviteNavSetting.center = self.center;
        [self addSubview:_inviteNavSetting];
        
        [UIView animateWithDuration:0.2 animations:
         ^(void){
             _inviteNavSetting.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.1f, 1.1f);
         }completion:^(BOOL finished){
             [self bounceOutAnimationStoped:_inviteNavSetting];
         }];
    }
    else if (blurType == BlurReportReasonType)
    {
        reason = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ReportReasonView class]) owner:self options:nil] lastObject];
        reason.frame = CGRectMake(0, 120, CGRectGetWidth(reason.frame), CGRectGetHeight(reason.frame));
        reason.layer.cornerRadius = 5.0f;
        POPSpringAnimation *animation = [POPSpringAnimation animation];
        animation.property = [POPAnimatableProperty propertyWithName:kPOPLayerTranslationY];
        animation.fromValue = @300.0;
        animation.toValue = @0.0;
        animation.springBounciness = 13.0;
        animation.springSpeed = 20.0;
        [reason.layer pop_addAnimation:animation forKey:@"pop"];
        
        UILabel *reasonLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, CGRectGetMinY(reason.frame)-40, 320, 40)];
        reasonLabel.text = @"选择[举报]理由?";
        reasonLabel.textColor = [UIColor whiteColor];
        reasonLabel.font = getFontWith(NO, 12);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(15, 20, 44, 44);
        [btn setBackgroundImage:[UIImage imageNamed:@"btn_close_n"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(clostBtnActon) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:reason];
        [self addSubview:reasonLabel];
        [self addSubview:btn];
        
    }
    else if (blurType == BlurSplashPhoneType)
    {
        SplashPhoneView *phone = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SplashPhoneView class]) owner:self options:nil] lastObject];
        
        [self removeGestureRecognizer:tap];
        int width = CGRectGetWidth(phone.frame);
        int hight = CGRectGetHeight(phone.frame);
        phone.frame = CGRectMake(10, -400, width, hight);
        phone.layer.cornerRadius = 5.0f;
        
        [UIView animateWithDuration:0.4 animations:^{
            phone.center = self.center;
        }];
        [self addSubview:phone];
    }
    else if (blurType == BLurLogoutType)
    {
        logout = [[LogoutView alloc] initWithFrame:CGRectMake(15, ([UIScreen mainScreen].bounds.size.height-180)/2, 290, 180)];
        logout.layer.cornerRadius = 5.0f;
        logout.backgroundColor = [UIColor whiteColor];
        [logout logoutViewShow];
        
        [UIView animateWithDuration:0.2 animations:
         ^(void){
             logout.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.1f, 1.1f);
             //             inviteFriends.alpha = 0.5;
         }completion:^(BOOL finished){
             [self bounceOutAnimationStoped:logout];
         }];

        [self addSubview:logout];
    }
    else if (blurType == BlurClearMarkType)
    {
        ClearMarkView *clear = [[[NSBundle mainBundle] loadNibNamed:@"ClearMarkView" owner:self options:nil] firstObject];
        clear.center = self.center;
        clear.layer.cornerRadius = 5.0f;
        [UIView animateWithDuration:0.2 animations:
         ^(void){
             clear.transform = CGAffineTransformScale(CGAffineTransformIdentity,1.1f, 1.1f);
         }completion:^(BOOL finished){
             [self bounceOutAnimationStoped:clear];
         }];

        [self addSubview:clear];
    }
    else if (blurType == BlurTipsType)
    {
        _tip = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([Tips class]) owner:self options:nil] lastObject];
        _tip.frame = CGRectMake(0, _tipsHeight, _tip.width, _tip.height);
//        self.userInteractionEnabled = NO;
//        self.superview.userInteractionEnabled = NO;
        [self removeGestureRecognizer:tap];
        [self addSubview:_tip];
    }
    else if (blurType == BlurPhoneBookAlertType)
    {
        allowPhoneBook = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([AllowToVisitPhoneBookView class]) owner:self options:nil] lastObject];
        allowPhoneBook.layer.cornerRadius = 5.0f;
        allowPhoneBook.center = self.center;
        [self addSubview:allowPhoneBook];
    }
    else if (blurType == BlurJustExperienceType)
    {
        experienceView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([JustExperienceView class]) owner:self options:nil] lastObject];
        experienceView.layer.cornerRadius = 5.0f;
        experienceView.center = self.center;
        [self addSubview:experienceView];
    }
}

-(void)setTipsHeight:(int)tipsHeight
{
    _tipsHeight = tipsHeight;
    _tip.frame = CGRectMake(0, _tipsHeight, _tip.width, _tip.height);
}

-(void)clostBtnActon
{
    [self tapAction];
}

-(void)navSettingCloseBtnAction
{
    [self tapAction];
}

+(ShareBlurView*)show:(id)delegate type:(BlurSubViewType)type
{
    UIWindow* window = [(AppDelegate*)[UIApplication sharedApplication].delegate window];
    ShareBlurView *invite = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, window.frame.size.width, window.frame.size.height)];
    
    if(delegate != nil)
    {
        if([delegate isKindOfClass:[UIView class]])
        {
            [invite shareBlurWithImage:[UIImage imageFromUIView:(UIView*)delegate] withBlurType:type];
        }
        else if ([delegate isKindOfClass:[UIImage class]])
        {
            [invite shareBlurWithImage:(UIImage*)delegate withBlurType:type];
        }
    }
    
    [window addSubview:invite];
    return invite;
}
-(void)tapAction
{
//    if (actionView != nil)
//    {
//        [actionView removeFromSuperview];
//    }
//    else if (commitView != nil)
//    {
//        [commitView removeFromSuperview];
//    }
    if (whoSeeSecretView != nil)
    {
        [whoSeeSecretView removeFromSuperview];
    }
    else if (_cellShare != nil)
    {
        [MobClick event:share_dialog_close];
        [UIView animateWithDuration:0.5 animations:^{
            _cellShare.frame = CGRectMake(-400, CGRectGetMinY(_cellShare.frame), CGRectGetWidth(_cellShare.frame), CGRectGetHeight(_cellShare.frame));
        } completion:^(BOOL finished) {
            [_cellShare removeFromSuperview];
        }];
    }
    else if (_mainAgainst != nil)
    {
        [UIView animateWithDuration:0.5 animations:^{
            _mainAgainst.alpha = 0;
        } completion:^(BOOL finished) {
            [_mainAgainst removeFromSuperview];
        }];
    }
    else if (_navSettingAppear != nil)
    {
        [UIView animateWithDuration:0.5 animations:^{
            _navSettingAppear.frame = CGRectMake(CGRectGetMinX(_navSettingAppear.frame), 579, CGRectGetWidth(_navSettingAppear.frame), CGRectGetHeight(_navSettingAppear.frame));
        } completion:^(BOOL finished) {
            [_navSettingAppear removeFromSuperview];
        }];
    }
    else if (logout != nil)
    {
        [logout removeFromSuperview];
    }
    else if (reason != nil)
    {
        [UIView animateWithDuration:0.5 animations:^{
                        reason.frame = CGRectMake(CGRectGetMinX(reason.frame), 579, CGRectGetWidth(reason.frame), CGRectGetHeight(reason.frame));
        } completion:^(BOOL finished) {
            [reason removeFromSuperview];
        }];
    }
    else if (allowPhoneBook != nil)
    {
        [UIView animateWithDuration:0.5 animations:^{
            allowPhoneBook.alpha = 0;
        } completion:^(BOOL finished) {
            [allowPhoneBook removeFromSuperview];
        }];
    }
    else if (experienceView != nil)
    {
        [UIView animateWithDuration:0.5 animations:^{
            experienceView.alpha = 0;
        } completion:^(BOOL finished) {
            [experienceView removeFromSuperview];
        }];
    }
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


-(void)setFeedId:(uint64_t)feedId
{
    _feedId = feedId;
    if (_mainAgainst != nil)
    {
        _mainAgainst.feedId = feedId;
    }
}

- (void)bounceOutAnimationStoped:(UIView *)animationView
{
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         animationView.transform = CGAffineTransformScale(CGAffineTransformIdentity,0.9, 0.9);
         animationView.alpha = 0.8;
     }
                     completion:^(BOOL finished){
                         [self bounceInAnimationStoped:animationView];
                     }];
}
- (void)bounceInAnimationStoped:(UIView *)animationView
{
    [UIView animateWithDuration:0.1 animations:
     ^(void){
         animationView.transform = CGAffineTransformScale(CGAffineTransformIdentity,1, 1);
         animationView.alpha = 1.0;
     }
                     completion:^(BOOL finished){
//                         [self animationStoped];
                     }];
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



#pragma mark - WhoSeeSecretAlertView
@implementation WhoSeeSecretAlertView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
    }
    return self;
}

-(void)whoSeeSecretViewShow
{
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 30)];
    titleLabel.font = getFontWith(YES, 19);
    titleLabel.textColor = colorWithHex(0xD0246C);
    titleLabel.text = @"谁会看到这个秘密?";
    [self addSubview:titleLabel];
    
    UILabel *subTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(titleLabel.frame)+10, 255, 60)];
    subTitleLabel.font = getFontWith(NO, 14);
    subTitleLabel.textColor = colorWithHex(0xF88BB5);
    subTitleLabel.numberOfLines = 0;
    subTitleLabel.text = @"您的秘密会匿名分享给朋友们。被「赞」了的秘密会传播给朋友的朋友";
    [self addSubview:subTitleLabel];

    CustomButton *btn = [CustomButton buttonWithRect:CGRectMake(CGRectGetMinX(titleLabel.frame), CGRectGetMaxY(subTitleLabel.frame)+10, 250, 48) btnTitle:nil btnImage:@"btn_ok_n" btnSelectedImage:@"btn_ok_h"];
    [btn addButtionAction:^{
        [self.superview removeFromSuperview];
    } buttonControlEvent:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

@end


#pragma mark - LogoutView

@implementation LogoutView

//#D0246C
//#F88BB5
-(void)logoutViewShow
{
    [MobClick event:Logout];
    UILabel *titleLable = [[UILabel alloc] initWithFrame:CGRectMake(15, 25, 80, 25)];
    titleLable.text = @"退出登录";
    titleLable.textAlignment = NSTextAlignmentLeft;
    titleLable.textColor = colorWithHex(0xD0246C);
    titleLable.font = getFontWith(YES, 17);
    [self addSubview:titleLable];
    
    UILabel *subTitleLabe = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMinX(titleLable.frame), CGRectGetMaxY(titleLable.frame)+20, 140, 20)];
    subTitleLabe.text = @"你确定要退出登录吗？";
    subTitleLabe.textAlignment = NSTextAlignmentLeft;
    subTitleLabe.font = getFontWith(NO, 12);
    subTitleLabe.textColor = colorWithHex(0xF88BB5);
    [self addSubview:subTitleLabe];
    
    CustomButton *notLogoutBtn = [CustomButton buttonWithRect:CGRectMake(CGRectGetMinX(subTitleLabe.frame), CGRectGetMaxY(subTitleLabe.frame)+20, 124, 40) btnTitle:nil btnImage:@"btn_logoutNo_n" btnSelectedImage:@"btn_logoutNo_h"];
    [notLogoutBtn addButtionAction:^{
        [MobClick event:logout_dialog_cancel];
        [self.superview removeFromSuperview];
    } buttonControlEvent:UIControlEventTouchUpInside];
    [self addSubview:notLogoutBtn];
    
    CustomButton *logoutBtn = [CustomButton buttonWithRect:CGRectMake(CGRectGetMaxX(notLogoutBtn.frame)+11, CGRectGetMinY(notLogoutBtn.frame), 124, 40) btnTitle:nil btnImage:@"btn_logoutYes_n" btnSelectedImage:@"btn_logoutYes_h"];
    [logoutBtn addButtionAction:^{
        [MobClick event:logout_dialog_ok];
        NSString *userToken = [UserInfo myselfInstance].userAPNsToken;
        if (userToken != nil && userToken.length > 0)
        {
            [[NetWorkEngine shareInstance] registDeviceToken:userToken block:^(int event, id object)
            {
                if (1 == event)
                {
                    Package *returnPack = (Package *)object;
                    [[LogicManager sharedInstance] handlePackage:returnPack block:^(int event, id object) {
                        if (1 == event)
                        {
                            NSDictionary *dict = (NSDictionary *)object;
                            uint32_t result = [[dict objectForKey:PACKAGERESULT] longValue];
                            if (0 == result)
                            {
                                DLog(@"token 解绑成功");
                            }
                            
                        }
                    }];
                }
            }];
        }
        
        [[LogicManager sharedInstance] logoutInformationshouldHanlde];
        [(AppDelegate*)([UIApplication sharedApplication].delegate) login];
    } buttonControlEvent:UIControlEventTouchUpInside];
    [self addSubview:logoutBtn];
    
}

@end



