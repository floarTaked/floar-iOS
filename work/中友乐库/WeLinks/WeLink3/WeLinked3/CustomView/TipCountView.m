//
//  TipView.m
//  Welinked2
//
//  Created by jonas on 12/13/13.
//
//

#import "TipCountView.h"

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
    self.frame = CGRectMake(0, 0, 20, 14);
    tipView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 14)];
//    tipView.image = [[UIImage imageNamed:@"notification"] stretchableImageWithLeftCapWidth:12 topCapHeight:12];
    tipView.backgroundColor = [UIColor colorWithRed:221.0/255.0 green:66.0/255.0 blue:63.0/255.0 alpha:1.0];
    tipView.layer.cornerRadius = 7;
    [self addSubview:tipView];

    tipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 20, 14)];
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
        float width = size.width+10;
        
        frame.size.width = width>tipView.frame.size.width?width:tipView.frame.size.width;
        self.frame = frame;
        
        tipView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
        
        frame = tipLabel.frame;
        frame.size.width = tipView.frame.size.width;
        tipLabel.frame = frame;
        [tipLabel setText:val];
    }
    else
    {
        tipView.hidden = YES;
    }
}
@end
