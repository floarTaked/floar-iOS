//
//  InfoDetailSubscriptionCell.m
//  WeLinked3
//
//  Created by yohunl on 14-3-3.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "InfoDetailSubscriptionCell.h"
#import "NetworkEngine.h"


//未订阅状态图片
#define NEEDSUB @"needsubscribe"
//已订阅状态图片
#define DIDSUB @"didsubscribe"

@implementation InfoDetailSubscriptionCell
{
    
    __weak IBOutlet UIImageView *detailSubscriptionRightImageView;
    
    __weak IBOutlet EGOImageView *detailSubscriptionLeftImageView;

    
    __weak IBOutlet UILabel *detailSubscriptionLabel;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setColumn:(Column *)column
{
    _column = column;
    detailSubscriptionLabel.text = column.title;
    detailSubscriptionLeftImageView.imageURL = [NSURL URLWithString:column.img];
    if (0 == [column.isSubscribe intValue])
    {
        detailSubscriptionRightImageView.image = [UIImage imageNamed:NEEDSUB];
        
    }
    else if (1 == [column.isSubscribe intValue])
    {
        detailSubscriptionRightImageView.image = [UIImage imageNamed:DIDSUB];
    }
    
    [self setNeedsDisplay];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

- (IBAction)detailSubscriptionCellBtnAction:(UIButton *)btn
{
    int index = btn.tag - 50;
    [_cellChangeDelegate changeStateWithCellIndex:index];
    //执行代理方法
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeInformarion" object:nil];
    
    if (detailSubscriptionRightImageView.image == [UIImage imageNamed:NEEDSUB])
    {
        [MobClick event:ARTICLE4];
        detailSubscriptionRightImageView.image = [UIImage imageNamed:DIDSUB];
        
    }
    else
    {
        detailSubscriptionRightImageView.image = [UIImage imageNamed:NEEDSUB];
    }
}

-(void)dealloc
{
    self.column = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
