//
//  TipView.m
//  Welinked2
//
//  Created by jonas on 12/13/13.
//
//

#import "TipCountView.h"
#define TipSize 22
@implementation TipCountView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initlize];
    }
    return self;
}
-(id)init
{
    self = [super init];
    if(self)
    {
        [self initlize];
    }
    return self;
}
-(void)initlize
{
    self.backgroundColor = [UIColor clearColor];
    self.frame = CGRectMake(0, 0, TipSize, TipSize);
    darkView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, TipSize, TipSize)];
    darkView.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0.1 alpha:0.5];
    darkView.layer.cornerRadius = 2;
    [self addSubview:darkView];

    tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TipSize, TipSize)];
    [tipLabel setTextColor:[UIColor whiteColor]];
    [tipLabel setFont:[UIFont boldSystemFontOfSize:11]];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:tipLabel];
    self.hidden = YES;
}
-(void)setTipCount:(int)unreadCount
{
    if(unreadCount >0 )
    {
        self.hidden = NO;
        NSString* val = [NSString stringWithFormat:@"%d",unreadCount];
        CGSize size = [val sizeWithFont:[UIFont boldSystemFontOfSize:11]];
        CGRect frame = self.frame;
        float width = size.width+5;
        
        frame.size.width = width>darkView.frame.size.width?width:darkView.frame.size.width;
//        frame.size.height = frame.size.width;
        self.frame = frame;
        darkView.layer.cornerRadius = 2;
        
        darkView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        frame = tipLabel.frame;
        frame.size.width = darkView.frame.size.width;
        tipLabel.frame = frame;
        tipLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [tipLabel setText:val];
    }
    else
    {
        self.hidden = YES;
    }
}
@end
