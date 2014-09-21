//
//  QuestionView.m
//  WeLinked4
//
//  Created by floar on 14-5-29.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "QuestionView.h"
#import "RCLabel.h"

@implementation QuestionView
{
    CGRect lrect;
    UILabel *questionLabel;
    RCLabel *tagLable;
    
    CGSize labelSize;
    CGSize questionSize;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        lrect = frame;
        
        questionLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        questionLabel.numberOfLines = 0;
        questionLabel.font = getFontWith(YES, 16);
        questionLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:questionLabel];
        
        tagLable = [[RCLabel alloc] initWithFrame:CGRectZero];
        tagLable.font = getFontWith(NO, 10);
        tagLable.textColor = colorWithHex(0xAAAAAA);
        tagLable.textAlignment = NSTextAlignmentLeft;
        [self addSubview:tagLable];
        
    }
    return self;
    
}

-(void)setTagString:(NSString *)tagString
{
    tagLable.text = tagString;
}

-(void)setContentString:(NSString *)contentString
{
    questionLabel.text = contentString;
    
    labelSize = [contentString boundingRectWithSize:CGSizeMake(290, 2000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18],NSFontAttributeName, nil] context:nil].size;
    NSLog(@"laebSize:%@",NSStringFromCGSize(labelSize));
    
    questionLabel.frame = CGRectMake(15, -10, 290, labelSize.height);
    
    tagLable.frame = CGRectMake(CGRectGetMinX(questionLabel.frame),CGRectGetMaxY(questionLabel.frame)-10, 290, 20);
    
    self.frame = CGRectMake(lrect.origin.x, lrect.origin.y, lrect.size.width,CGRectGetMaxY(tagLable.frame));
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
