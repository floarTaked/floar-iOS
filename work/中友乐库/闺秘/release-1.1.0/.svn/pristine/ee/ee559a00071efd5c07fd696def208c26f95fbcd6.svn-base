//
//  Tips.m
//  闺秘
//
//  Created by floar on 14-7-23.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "Tips.h"
#import "LogicManager.h"
#import <QuartzCore/QuartzCore.h>

@implementation Tips
{
    __weak IBOutlet UIImageView *tipsBG;
    
    __weak IBOutlet UILabel *contentLabel;
    
    __weak IBOutlet UIImageView *tipStandImage;
    
    __weak IBOutlet UILabel *tipSubtitile;
    
    __weak IBOutlet UIImageView *tipSubImage;
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
    contentLabel.textColor = colorWithHex(lightRedColor);
    tipSubtitile.textColor = colorWithHex(DeepRedColor);
    
    UIEdgeInsets edge = UIEdgeInsetsMake(10, 10, 10, 10);
    [tipsBG setImage:[[UIImage imageNamed:@"img_tipsBG"]resizableImageWithCapInsets:edge]];
}

-(void)setContentStr:(NSString *)contentStr
{
    _contentStr = contentStr;
    contentLabel.text = contentStr;
}

-(void)customTipsViewWithPoint:(CGPoint)point tipType:(TipsType)type withSubTitle:(NSString *)title withSubImageStr:(NSString *)imageStr subImageSize:(CGSize)subImageSize
{
    tipStandImage.frame = CGRectMake(point.x, point.y, tipStandImage.width, tipStandImage.height);
    if (type == TipsAddressType || type == TipsFriendType)
    {
        tipSubtitile.text = title;
        
        CGSize strSize = [[LogicManager sharedInstance] calculateCGSizeWith:title height:20 width:90 font:[UIFont systemFontOfSize:12]];
        
        tipStandImage.frame = CGRectMake(point.x, point.y, strSize.width, tipStandImage.height);
//        UIEdgeInsets edge = UIEdgeInsetsMake(65, 5, 1, 5);
//        [tipStandImage setImage:[[UIImage imageNamed:@"img_tipsStand_down.png"]resizableImageWithCapInsets:edge]];
        tipSubImage.image = [UIImage imageNamed:imageStr];
        
        [tipSubImage removeFromSuperview];
        tipSubtitile.frame = CGRectMake(CGRectGetMinX(tipStandImage.frame), CGRectGetMaxY(tipStandImage.frame), tipSubtitile.width, tipSubtitile.height);
    }
    else if (type == TipsSupportType)
    {
        [tipSubtitile removeFromSuperview];
        tipSubImage.image = [UIImage imageNamed:imageStr];
        tipSubImage.frame = CGRectMake(CGRectGetMinX(tipStandImage.frame)+8, CGRectGetMaxY(tipStandImage.frame), subImageSize.width , subImageSize.height);
    }
    else if (type == TipsAvatorType)
    {
        [tipSubtitile removeFromSuperview];
        tipStandImage.image = [UIImage imageNamed:_standImgStr];
        tipSubImage.image = [UIImage imageNamed:imageStr];
        if ([_standImgStr isEqualToString:@"img_tipsStand_up"])
        {
            tipSubImage.frame = CGRectMake(CGRectGetMinX(tipStandImage.frame)+2, -45, subImageSize.width, subImageSize.height);
        }
        else
        {
            tipSubImage.frame = CGRectMake(CGRectGetMinX(tipStandImage.frame), CGRectGetMaxY(tipStandImage.frame)+2, subImageSize.width, subImageSize.height);
        }
    }
    else if (type == TipsFeedCollectedType)
    {
        tipStandImage.frame = CGRectMake(point.x, point.y, 160, tipStandImage.height);
        UIEdgeInsets edge = UIEdgeInsetsMake(10, 10, 10, 10);
        [tipStandImage setImage:[[UIImage imageNamed:@"img_tipsStand_up"]resizableImageWithCapInsets:edge]];
        
        [tipSubImage removeFromSuperview];
        [tipSubtitile removeFromSuperview];
    }
    else if (type == TipsCellShareType)
    {
        tipStandImage.image = [UIImage imageNamed:@"img_tipsStand_up"];
        tipSubImage.frame = CGRectMake(CGRectGetMinX(tipStandImage.frame), CGRectGetMinY(tipStandImage.frame)-33, subImageSize.width, subImageSize.height);
        tipSubImage.image = [UIImage imageNamed:imageStr];
        [tipSubtitile removeFromSuperview];
        
    }
}

- (IBAction)tipsOkBtnAction:(id)sender
{
    if (self.handleTipsOKBtnActionBlock)
    {
        self.handleTipsOKBtnActionBlock();
    }
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
