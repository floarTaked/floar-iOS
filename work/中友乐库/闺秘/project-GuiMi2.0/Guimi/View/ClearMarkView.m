//
//  ClearMarkView.m
//  闺秘
//
//  Created by floar on 14-7-15.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "ClearMarkView.h"

@implementation ClearMarkView
{
    
    __weak IBOutlet UILabel *titleLabel;
    
    __weak IBOutlet UILabel *subTitleLabel;
    
    __weak IBOutlet UIView *littleMarkView;
    
    __weak IBOutlet UILabel *clearLabel;
    
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    titleLabel.font = getFontWith(YES, 20);
    titleLabel.textColor = colorWithHex(0xD0246C);
    
    subTitleLabel.font = getFontWith(NO, 14);
    subTitleLabel.textColor = colorWithHex(0xF88BB5);
    
    clearLabel.font = getFontWith(NO, 14);
    clearLabel.textColor = colorWithHex(0xF88BB5);
    
    littleMarkView.alpha = 0;
    [self addSubview:littleMarkView];
}

- (IBAction)cancleBtnAction:(id)sender
{
    [MobClick event:clear_traces_dialog_cancel];
    [self.superview removeFromSuperview];
}

- (IBAction)okBtnAction:(id)sender
{
    [MobClick event:clear_traces_dialog_ok];
    littleMarkView.center = self.superview.center;
    [UIView animateWithDuration:1.5 animations:^{
        littleMarkView.alpha = 1.0;
    }];
    [self.superview addSubview:littleMarkView];
    [self removeFromSuperview];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [littleMarkView.superview removeFromSuperview];
    });
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
