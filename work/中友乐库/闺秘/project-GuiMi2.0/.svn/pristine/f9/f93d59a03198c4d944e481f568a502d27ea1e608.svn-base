//
//  ActionAlertView.h
//  Guimi
//
//  Created by jonas on 9/13/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PublishActionView : UIView
{
    IBOutlet UIButton* leftButton;
    IBOutlet UIButton* rightButton;
    EventCallBack block;
}
-(void)setEventBlock:(EventCallBack)callback;
@end


@interface LogoutActionView : UIView
{
    IBOutlet UIImageView* backView;
    IBOutlet UIButton* leftButton;
    IBOutlet UIButton* rightButton;
    EventCallBack block;
}
-(void)setEventBlock:(EventCallBack)callback;
@end



@interface VisiableActionView : UIView
{
    IBOutlet UIImageView* backView;
    IBOutlet UIButton* rightButton;
    EventCallBack block;
}
-(void)setEventBlock:(EventCallBack)callback;
@end

@interface SexActionView : UIView
{
    IBOutlet UIImageView* backView;
    IBOutlet UILabel* detailLabel;
    IBOutlet UIButton* leftButton;
    IBOutlet UIButton* rightButton;
    EventCallBack block;
}
-(void)setEventBlock:(EventCallBack)callback;
@end


@interface ContactBookActionView : UIView
{
    IBOutlet UIImageView* backView;
    IBOutlet UILabel* detailLabel;
    IBOutlet UIButton* leftButton;
    EventCallBack block;
}
-(void)setEventBlock:(EventCallBack)callback;
@end











@interface ActionAlertView : NSObject
{
    NSArray* viewArray;
}
@property(nonatomic,strong)NSArray * viewArray;
-(UIView*)loadLogoutActionView:(EventCallBack)block;
-(UIView*)loadPublishActionView:(EventCallBack)block;
-(UIView*)loadVisiableActionView:(EventCallBack)block;
-(UIView*)loadSexActionView:(EventCallBack)block;
-(UIView*)loadContactBookActionView:(EventCallBack)block;


+(ActionAlertView*)sharedInstance;
@end
