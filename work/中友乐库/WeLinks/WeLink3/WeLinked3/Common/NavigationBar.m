//
//  TitleStatusBar.m
//  papa
//
//  Created by jonas on 13-6-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "NavigationBar.h"
#import "AppDelegate.h"
@implementation NavigationBar

@synthesize iTitleLabel;
@synthesize iLeftButton;
@synthesize iRightButton;
@synthesize iTitleImgView;
#pragma mark -
#pragma mark 系统方法
-(BOOL)isAnimating
{
    if(activityView != nil)
    {
        return activityView.isAnimating;
    }
    return NO;
}
-(id)init
{
    self = [super init];
    if (self)
    {
        self.clipsToBounds = NO;
//        if(isSystemVersionIOS7())
//        {
//            [self setFrame:CGRectMake(0, 0, 320, 64)];
//            iTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 200, self.frame.size.height-20)];
//            iTitleLabel.center = CGPointMake(self.frame.size.width/2, (self.frame.size.height-20)/2);
//            activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.height-20,
//                                                                                    self.frame.size.height-20)];
//        }
//        else
        {
            [self setFrame:CGRectMake(0, 0, 320, 44)];
            iTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, self.frame.size.height)];
            iTitleLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
            activityView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(10, 10, self.frame.size.height-20,
                                                                                    self.frame.size.height-20)];
        }
        self.backgroundColor = colorWithHex(NavBarColor);
        [iTitleLabel setTextColor:[UIColor whiteColor]];
        [iTitleLabel setFont:getFontWith(YES, 17)];
        
//        [iTitleLabel setShadowColor:[UIColor whiteColor]];
//        [iTitleLabel setShadowOffset:CGSizeMake(0, 1.5)];
        iTitleLabel.backgroundColor = [UIColor clearColor];
        
        self.layer.shadowColor = [[UIColor blackColor] CGColor];
        self.layer.shadowOffset = CGSizeMake(0, 0.5);
        self.layer.shadowOpacity = 0.5;
        

        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        [self addSubview:activityView];
        activityView.hidden = YES;
        activityView.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        // Initialization code
    }
    return self;
}
-(void)setTitle:(NSString *)title
{
    CGSize size = [title sizeWithFont:iTitleLabel.font];
    if(size.width >200)
    {
        size.width = 200;
    }
    iTitleLabel.backgroundColor = [UIColor clearColor];
    CGRect frame = activityView.frame;
//    if(isSystemVersionIOS7())
//    {
//        [iTitleLabel setFrame:CGRectMake(0,20,size.width, iTitleLabel.frame.size.height)];
//        iTitleLabel.center = CGPointMake(self.frame.size.width/2-10, (self.frame.size.height-20)/2+20);
//        frame.origin.x = iTitleLabel.frame.origin.x-frame.size.width;
//        frame.origin.y = 20;
//    }
//    else
    {
        [iTitleLabel setFrame:CGRectMake(0,0,size.width, iTitleLabel.frame.size.height)];
        iTitleLabel.center = CGPointMake(self.frame.size.width/2-10, self.frame.size.height/2);
        frame.origin.x = iTitleLabel.frame.origin.x-frame.size.width;
    }

    [iTitleLabel setText:title];
    iTitleLabel.numberOfLines = 1;
    iTitleLabel.lineBreakMode = NSLineBreakByWordWrapping|NSLineBreakByTruncatingTail;
    [self addSubview:iTitleLabel];
    activityView.frame = frame;
}
-(id)initWithTitlebg:(NSString *)aTitleBgString
{
    self = [super init];
    if (self)
    {
        UIImage* bgImg = [UIImage imageNamed:aTitleBgString];
        CGRect rect = CGRectMake(0, 0, bgImg.size.width, bgImg.size.height);
        UIImageView* view = [[UIImageView alloc] initWithImage:bgImg];
        [view setFrame:rect];
        [self addSubview:view];
        [self setFrame:rect];
    }
    return self;
}

#define kTitleSpace 3

#pragma mark -
#pragma mark 公有方法
-(void)addIcon:(UIImageView*)imageView
{
    CGPoint center = iTitleLabel.center;
    center.x += imageView.frame.size.width/2;
    iTitleLabel.center = center;
    center.x -= iTitleLabel.frame.size.width/2 + imageView.frame.size.width/2;
    center.y -= 2;
    imageView.center = center;
    [self addSubview:imageView];
}
-(void)setEnable:(int)leftOrRight state:(BOOL)state
{
    if(leftOrRight == 0)
    {
        if(iLeftButton != nil)
        {
            iLeftButton.enabled = state;
        }
    }
    else if(leftOrRight == 1)
    {
        if(iRightButton != nil)
        {
            iRightButton.enabled = state;
        }
    }
}
-(void)setState:(int)leftOrRight normal:(NSString*)normalImage highlight:(NSString*)highlightImage
{
    if(leftOrRight == 0)
    {
        if(iLeftButton != nil)
        {
            [iLeftButton setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
            [iLeftButton setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
            [self bringSubviewToFront:iLeftButton];
        }
    }
    else if(leftOrRight == 1)
    {
        if(iRightButton != nil)
        {
            [iRightButton setImage:[UIImage imageNamed:normalImage] forState:UIControlStateNormal];
            [iRightButton setImage:[UIImage imageNamed:highlightImage] forState:UIControlStateHighlighted];
            [self bringSubviewToFront:iRightButton];
        }
    }
}

-(void)startActivity
{
    activityView.hidden = NO;
    [activityView startAnimating];
}
-(void)stopActivity
{
    [activityView stopAnimating];
    activityView.hidden = YES;
}
-(void)setBackgroundImage:(UIImage*)image
{
    int w = image.size.width;
    int h = image.size.height;
    int x = (self.frame.size.width - w) / 2;
    int y = (self.frame.size.height - h) / 2 - kTitleSpace;

    iTitleImgView = [[UIImageView alloc] initWithImage:image];
    [iTitleImgView setFrame:CGRectMake(x, y, w, h)];
    [self addSubview:iTitleImgView];
}
-(void)addleftButtonWithicon:(NSString *)aImg1 imgHightlight:(NSString *)aImg2 iconImg:(NSString *)aImg3 addTarget:(id)target action:(SEL)sel forControlEvents:(UIControlEvents)event
{
    iLeftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage* img1 = [UIImage imageNamed:aImg1];
    UIImage* img2 = [UIImage imageNamed:aImg2];
    [iLeftButton setImage:img1 forState:UIControlStateNormal];
    [iLeftButton setImage:img2 forState:UIControlStateHighlighted];
    [iLeftButton setFrame:CGRectMake(10, 0, self.frame.size.height+30, self.frame.size.height)];
    [iLeftButton setImageEdgeInsets:UIEdgeInsetsMake(0, -50, 0, 0)];
    [iLeftButton addTarget:target action:sel forControlEvents:event];
    if(aImg3 != nil && [aImg3 length]>0)
    {
        UIImage* img3 = [UIImage imageNamed:aImg3];
        float x = (iLeftButton.frame.size.width - img3.size.width) / 2;
        float y = (iLeftButton.frame.size.height - img3.size.height) / 2;
        UIImageView* iconView = [[UIImageView alloc] initWithImage:img3];
        [iconView setFrame:CGRectMake(x, y, img3.size.width, img3.size.height)];
        [iLeftButton addSubview:iconView];

    }
    [self addSubview:iLeftButton];
}

-(void)addRightButtonWithicon:(NSString*)iconNormal
                 iconSelected:(NSString*)iconSelected
                    addTarget:(id)target
                       action:(SEL)sel
             forControlEvents:(UIControlEvents)event
{
    iRightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [iRightButton.titleLabel setBackgroundColor:[UIColor clearColor]];
    UIImage* image = [UIImage imageNamed:iconNormal];
    CGSize size = image.size;
    iRightButton.frame = CGRectMake(self.frame.size.width-size.width-45, 0,size.width+30, self.frame.size.height);
    [iRightButton setImageEdgeInsets:UIEdgeInsetsMake(0, 30, 0, 0)];
    [iRightButton setImage:image forState:UIControlStateNormal];
    [iRightButton setImage:[UIImage imageNamed:iconSelected] forState:UIControlStateHighlighted];
    [iRightButton addTarget:target action:sel forControlEvents:event];
    [self addSubview:iRightButton];
}
-(void)addSkinButton:(NSString*)aString imgNormal:(NSString *)aImg1 imgHightlight:(NSString *)aImg2 addTarget:(id)target action:(SEL)sel
{
    iSkinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [iSkinButton setTitle:aString forState:UIControlStateNormal];
    [iSkinButton.titleLabel setTextColor:[UIColor whiteColor]];
    [iSkinButton.titleLabel setBackgroundColor:[UIColor colorWithWhite:0 alpha:0]];
    [iSkinButton.titleLabel setShadowColor:[UIColor colorWithWhite:0 alpha:0.5]];
    [iSkinButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [iSkinButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    UIImage* img1 = [UIImage imageNamed:aImg1];
    UIImage* img2 = [UIImage imageNamed:aImg2];
    [iSkinButton setBackgroundImage:img1 forState:UIControlStateNormal];
    [iSkinButton setBackgroundImage:img2 forState:UIControlStateHighlighted];
    int y = (self.frame.size.height - img1.size.height) / 2 - kTitleSpace;
    int x = self.frame.size.width - img1.size.width - 9;
    [iSkinButton setFrame:CGRectMake(x, y, img1.size.width, img2.size.height)];
    [iSkinButton addTarget:target action:sel forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:iSkinButton];
}

-(void)setSkinHide:(BOOL)aHide
{
    [iSkinButton setHidden:aHide];
}

-(void)setBackButtonHide:(BOOL)aHide
{
    [iBackButton setHidden:aHide];
//    if (!aHide) {
//        [iLeftButton setHidden:YES];
//    }
}

-(void)setLeftButtonHide:(BOOL)aHide
{
    [iLeftButton setHidden:aHide];
}
@end
