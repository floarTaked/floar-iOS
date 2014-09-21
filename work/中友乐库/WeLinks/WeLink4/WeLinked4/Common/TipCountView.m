//
//  TipView.m
//  Welinked2
//
//  Created by jonas on 12/13/13.
//
//

#import "TipCountView.h"
#define TipSize 18
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
    tipView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, TipSize, TipSize)];
    tipView.image = [[UIImage imageNamed:@"notification"] stretchableImageWithLeftCapWidth:9 topCapHeight:9];
    tipView.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:66.0/255.0 blue:63.0/255.0 alpha:1.0];
    tipView.layer.cornerRadius = TipSize/2;
    [self addSubview:tipView];

    tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, TipSize, TipSize)];
    [tipLabel setTextColor:[UIColor whiteColor]];
    [tipLabel setFont:[UIFont boldSystemFontOfSize:11]];
    tipLabel.backgroundColor = [UIColor clearColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    [tipView addSubview:tipLabel];
    tipView.hidden = YES;
}
-(void)setTipCount:(int)unreadCount
{
    if(unreadCount >0 )
    {
        tipView.hidden = NO;
        NSString* val = [NSString stringWithFormat:@"%d",unreadCount];
        CGSize size = [val sizeWithFont:[UIFont boldSystemFontOfSize:11]];
        CGRect frame = self.frame;
        float width = size.width+5;
        
        frame.size.width = width>tipView.frame.size.width?width:tipView.frame.size.width;
//        frame.size.height = frame.size.width;
        self.frame = frame;
        tipView.layer.cornerRadius = frame.size.width/2;
        
        tipView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        frame = tipLabel.frame;
        frame.size.width = tipView.frame.size.width;
        tipLabel.frame = frame;
        tipLabel.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
        [tipLabel setText:val];
    }
    else
    {
        tipView.hidden = YES;
    }
}
@end
