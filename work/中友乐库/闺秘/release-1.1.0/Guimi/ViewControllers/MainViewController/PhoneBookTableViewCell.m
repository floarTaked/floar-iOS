//
//  PhoneBookTableViewCell.m
//  闺秘
//
//  Created by floar on 14-8-5.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "PhoneBookTableViewCell.h"

@implementation PhoneBookTableViewCell

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)handleBtnAction:(id)sender
{
    if (self.handlePhoneBookAccessBlock)
    {
        self.handlePhoneBookAccessBlock();
    }
}


@end
