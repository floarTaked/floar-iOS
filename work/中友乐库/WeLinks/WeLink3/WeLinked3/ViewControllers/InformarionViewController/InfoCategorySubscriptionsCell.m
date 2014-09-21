//
//  InfoCategorySubscriptionsCell.m
//  WeLinked3
//
//  Created by yohunl on 14-3-3.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "InfoCategorySubscriptionsCell.h"

@implementation InfoCategorySubscriptionsCell
{
    
    __weak IBOutlet EGOImageView *infoCategorySubscriptionsLeftImageView;
    
    __weak IBOutlet UILabel *categorySubscriptionsLable;
    
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
    infoCategorySubscriptionsLeftImageView.imageURL = [NSURL URLWithString:column.img];
    categorySubscriptionsLable.text = column.title;
    [self setNeedsDisplay];
}

-(void)layoutSubviews
{
    [super layoutSubviews];
}

@end
