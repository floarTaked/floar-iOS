//
//  SelectFriendCell.m
//  WeLinked3
//
//  Created by 牟 文斌 on 2/27/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "SelectFriendCell.h"
#import "PublicObject.h"
#import "LogicManager.h"
#import <EGOImageView.h>

@interface SelectFriendCell ()
@property (weak, nonatomic) IBOutlet UILabel *canRecommendNum;
@property (weak, nonatomic) IBOutlet EGOImageView *userIcon;
@property (weak, nonatomic) IBOutlet UIButton *selectButton;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *company;
- (IBAction)selectAction:(id)sender;


@end

@implementation SelectFriendCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.contentView.clipsToBounds = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setSelectFriend:(BOOL)selectFriend
{
    _selectFriend = selectFriend;
    _selectButton.selected = _selectFriend;
}

- (IBAction)selectAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(selectCell:)]) {
        [_delegate selectCell:self];
    }
    _selectButton.selected = !_selectButton.selected;
}

- (void)dealloc
{
    self.delegate = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [self.userIcon setImageURL:[NSURL URLWithString:_userInfo.avatar]];
    self.userName.text = _userInfo.name;
    self.company.text = [NSString stringWithFormat:@"%@ %@",_userInfo.company,_userInfo.job];
    self.canRecommendNum.text = [NSString stringWithFormat:@"可推荐51人"];
}
@end
