//
//  CustomCellView.m
//  TableTest
//
//  Created by Stephan on 22.02.09.
//  Copyright 2009 Coriolis Technologies. All rights reserved.
//

#import "CustomCellView.h"

@implementation CustomCellView
@synthesize fillColor;
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        [self initlize];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithFrame:frame reuseIdentifier:reuseIdentifier])
    {
		// Initialization code
        [self initlize];
	}
	return self;
}

-(void)initlize
{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor whiteColor];
    
    
    selectedView = [[CustomCellBackgroundView alloc] initWithFrame:self.frame];
    selectedView.fillColor = colorWithHex(0x3287E6);//[UIColor colorWithRed:50.0/255 green:170.0/255 blue:10.0/255 alpha:1.0];
    selectedView.borderColor = [UIColor clearColor];
	selectedView.position = CustomCellBackgroundViewPositionMiddle;
	self.selectedBackgroundView = selectedView;
}
-(void)setFillColor:(UIColor *)fill
{
    fillColor = fill;
    selectedView.fillColor = fill;
}
-(void)setSelectedPosition:(CustomCellBackgroundViewPosition)position
{
    if(isSystemVersionIOS7())
    {
        selectedView.position = CustomCellBackgroundViewPositionMiddle;
    }
    else
    {
        selectedView.position = position;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
	[super setSelected:selected animated:animated];
  // Configure the view for the selected state
}
@end

@implementation CustomMarginCellView
- (void)setFrame:(CGRect)frame
{
    frame.origin.x += 10;
    frame.size.width -= 20;
//    self.layer.borderWidth = 0.5;
//    self.layer.borderColor = colorWithHex(0xcccccc).CGColor;
    [super setFrame:frame];
}
@end

@implementation CustomWideCellView
-(void)setFrame:(CGRect)frame
{
    frame.size.width += 80;
    [super setFrame:frame];
}
@end
