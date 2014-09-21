//
//  TableViewCell.m
//  ShineLabel
//
//  Created by floar on 14-8-2.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell
{
    
    __weak IBOutlet RQShineLabel *cellContentLabel;
}


- (void)awakeFromNib
{
    // Initialization code
}

-(void)setCellContentStr:(NSString *)cellContentStr
{
    _cellContentStr = cellContentStr;
    cellContentLabel.textColor = [UIColor orangeColor];
    cellContentLabel.text = cellContentStr;
    [cellContentLabel shine];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
