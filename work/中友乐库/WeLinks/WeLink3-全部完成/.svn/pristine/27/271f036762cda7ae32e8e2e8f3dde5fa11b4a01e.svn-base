//
//  FlexibleUILabel.m
//  WeLinked
//
//  Created by jonas on 11/22/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//

#import "FlexibleUILabel.h"

@implementation FlexibleUILabel
@synthesize fixedHeight;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.fixedHeight = NO;
        // Initialization code
    }
    return self;
}
-(void)setText:(NSString *)text
{
    if(text == nil)
    {
        text = @"";
    }
    [super setText:text];
    [self setNumberOfLines:0];
    CGRect rect = self.frame;
    if(fixedHeight)
    {
        CGSize labelsize = [text sizeWithFont:self.font
                            constrainedToSize:CGSizeMake(99999, rect.size.height)
                                lineBreakMode:self.lineBreakMode];
        rect.size = labelsize;
        [self setFrame:rect];
    }
    else
    {
        CGSize labelsize = [text sizeWithFont:self.font
                            constrainedToSize:CGSizeMake(rect.size.width, 99999)
                                lineBreakMode:self.lineBreakMode];
        rect.size = labelsize;
        [self setFrame:rect];
    }
}
+(float)calculateHeightWith:(NSString*)text font:(UIFont*)font width:(float)width lineBreakeMode:(NSLineBreakMode)mode
{
    if(text == nil)
    {
        text = @"";
    }
    CGSize labelsize = [text sizeWithFont:font constrainedToSize:CGSizeMake(width, 99999) lineBreakMode:mode];
    return labelsize.height;
}
+(float)calculateWidthWith:(NSString*)text font:(UIFont*)font height:(float)height lineBreakeMode:(NSLineBreakMode)mode
{
    if(text == nil)
    {
        text = @"";
    }
    CGSize labelsize = [text sizeWithFont:font constrainedToSize:CGSizeMake(99999,height) lineBreakMode:mode];
    return labelsize.width;
}
@end
