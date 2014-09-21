//
//  TitleStatusBar.h
//  papa
//
//  Created by jonas on 12-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
@interface NavigationBar : UIView
{
    UILabel* iTitleLabel;
    UIButton* iLeftButton;
    UIButton* iRightButton;
    UIButton* iBackButton;
    UIButton* iSkinButton;
    UIActivityIndicatorView* activityView;
}
@property (nonatomic, assign) BOOL isAnimating;
@property (nonatomic, strong) UILabel* iTitleLabel;
@property (nonatomic, strong) UIButton* iLeftButton;
@property (nonatomic, strong) UIButton* iRightButton;
@property (nonatomic, strong) UIImageView* iTitleImgView;
-(void)addIcon:(UIImageView*)imageView;
-(void)setEnable:(int)leftOrRight state:(BOOL)state;
-(void)setState:(int)leftOrRight normal:(NSString*)normalImage highlight:(NSString*)highlightImage;
-(void)setTitle:(NSString*)title;
-(void)setBackgroundImage:(UIImage*)image;

-(void)addleftButtonWithicon:(NSString*)aImg1
               imgHightlight:(NSString*)aImg2
                     iconImg:(NSString*)aImg3
                   addTarget:(id)target
                      action:(SEL)sel
            forControlEvents:(UIControlEvents)event;

-(void)addRightButtonWithicon:(NSString*)iconNormal
                 iconSelected:(NSString*)iconSelected
                    addTarget:(id)target
                       action:(SEL)sel
             forControlEvents:(UIControlEvents)event;

-(id)initWithTitlebg:(NSString*)aTitleBgString;
-(void)setBackButtonHide:(BOOL)aHide;
-(void)setLeftButtonHide:(BOOL)aHide;
-(void)addSkinButton:(NSString*)aString imgNormal:(NSString*)aImg1 imgHightlight:(NSString*)aImg2 addTarget:(id)target action:(SEL)sel;
-(void)setSkinHide:(BOOL)aHide;
-(void)startActivity;
-(void)stopActivity;
@end
