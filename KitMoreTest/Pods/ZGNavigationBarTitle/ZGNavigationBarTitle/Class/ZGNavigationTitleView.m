//
//  ZGNavigationTitleView.m
//  ZGNavigationBarTitle
//
//  Created by Kyle Fang on 9/8/13.
//  Copyright (c) 2013 Kyle Fang. All rights reserved.
//

#import "ZGNavigationTitleView.h"

@protocol ZGNavigationTitleContentViewDelegate <NSObject>
- (void)drawContent:(CGRect)rect;
@end

@interface ZGNavigationTitleContentView : UIView
@property (nonatomic, weak) id <ZGNavigationTitleContentViewDelegate> delegate;
@end

@implementation ZGNavigationTitleContentView
- (void)drawRect:(CGRect)rect
{
    if ([self.delegate respondsToSelector:@selector(drawContent:)]) {
        [self.delegate drawContent:rect];
    }
}
@end

@interface ZGNavigationTitleView () <ZGNavigationTitleContentViewDelegate>
@property (nonatomic, strong) ZGNavigationTitleContentView *contentView;
@end

@implementation ZGNavigationTitleView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupContentView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupContentView];
    }
    return self;
}

- (void)setupContentView
{
    self.contentView = [[ZGNavigationTitleContentView alloc] initWithFrame:self.frame];
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.contentView.delegate = self;
    [self addSubview:self.contentView];
    self.backgroundColor = [UIColor clearColor];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
}

- (void)setNavigationBarTitle:(NSString *)navigationBarTitle
{
    if (![_navigationBarTitle isEqualToString:navigationBarTitle]) {
        _navigationBarTitle = navigationBarTitle;
        [self.contentView setNeedsDisplay];
    }
}

- (void)setNavigationBarSubtitle:(NSString *)navigationBarSubtitle
{
    if (![_navigationBarSubtitle isEqualToString:navigationBarSubtitle]) {
        if (navigationBarSubtitle.length && !_navigationBarSubtitle.length) {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.4f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromTop;
            [transition setValue:(id) kCFBooleanFalse forKey:kCATransitionFade];
            [self.contentView.layer addAnimation:transition forKey:nil];
        }
        else if (!navigationBarSubtitle.length && _navigationBarSubtitle.length) {
            CATransition *transition = [CATransition animation];
            transition.duration = 0.4f;
            transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            transition.type = kCATransitionPush;
            transition.subtype = kCATransitionFromBottom;
            [transition setValue:(id) kCFBooleanFalse forKey:kCATransitionFade];
            [self.contentView.layer addAnimation:transition forKey:nil];
        }
        _navigationBarSubtitle = navigationBarSubtitle;
        [self.contentView setNeedsDisplay];
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawContent:(CGRect)rect
{
    // Drawing code
    if (self.navigationBarSubtitle.length) {
        CGRect titleRect = rect;
        titleRect.origin.y = 4;
        titleRect.size.height = 20;
        [self.navigationBarTitleFontColor setFill];
//        [self.navigationBarTitle drawInRect:titleRect withFont:[UIFont boldSystemFontOfSize:17] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        NSMutableParagraphStyle *titleparagraphStyle = [[NSMutableParagraphStyle alloc] init];
        titleparagraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        titleparagraphStyle.alignment = NSTextAlignmentCenter;
        [self.navigationBarTitle drawInRect:titleRect withAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:17],NSFontAttributeName,titleparagraphStyle,NSParagraphStyleAttributeName, nil]];
        
        CGRect subtitleRect = rect;
        subtitleRect.origin.y = 24;
        subtitleRect.size.height = rect.size.height - 24;
        [self.navigationBarSubtitleFontColor setFill];
//        [self.navigationBarSubtitle drawInRect:subtitleRect withFont:[UIFont boldSystemFontOfSize:13] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        NSMutableParagraphStyle *subTitleParagraphStytle = [[NSMutableParagraphStyle alloc] init];
        subTitleParagraphStytle.alignment = NSTextAlignmentCenter;
        subTitleParagraphStytle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.navigationBarSubtitle drawInRect:subtitleRect withAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIFont boldSystemFontOfSize:13],subTitleParagraphStytle, nil] forKeys:[NSArray arrayWithObjects:NSFontAttributeName,NSParagraphStyleAttributeName,nil]]];
        
    }
    else {
        CGRect titleRect = rect;
        titleRect.origin.y = (rect.size.height - 24.f) / 2.f;
        titleRect.size.height = 24.f;
        [self.navigationBarTitleFontColor setFill];
//        [self.navigationBarTitle drawInRect:titleRect withFont:[UIFont boldSystemFontOfSize:20] lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.navigationBarTitle drawInRect:titleRect withAttributes:[NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[UIFont boldSystemFontOfSize:20],paragraphStyle, nil] forKeys:[NSArray arrayWithObjects:NSFontAttributeName,NSParagraphStyleAttributeName, nil]]];
    }
}

@end
