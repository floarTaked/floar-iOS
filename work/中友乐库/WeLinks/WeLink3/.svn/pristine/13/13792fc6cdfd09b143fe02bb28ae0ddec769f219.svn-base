//
//  CommentCell.m
//  WeLinked3
//
//  Created by 牟 文斌 on 3/10/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "CommentCell.h"
#import "Common.h"
#import <EGOImageView.h>

@interface CommentCell()
@property (nonatomic , strong) EGOImageView *userHead;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) UILabel *jobTitle;
@property (nonatomic, strong) UILabel *content;
@property (nonatomic, strong) UILabel *timeLabel;
@end

@implementation CommentCell

+ (float)cellHeightWithComment:(Comment *)comment
{
    float cellHeight = [comment.content sizeWithFont:[UIFont boldSystemFontOfSize:14] constrainedToSize:CGSizeMake(280, 2000)].height;
    CGSize size = CGSizeZero;
    //    评论内容
    if (isSystemVersionIOS7()) {
        size = [comment.content boundingRectWithSize:CGSizeMake(280 , CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:nil].size;
    }else{
        size = [comment.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    }
    cellHeight +=  size.height;
    
    if (cellHeight < 80)
    {
        cellHeight = cellHeight + 45;
    }
    return cellHeight+14;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self initlize];
    }
    return self;
}


- (void)initlize
{
    self.userHead = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 35, 35)];
    [self.contentView addSubview:self.userHead];
    
    self.userName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userHead.frame) + 10, 10, 200, 20)];
    self.userName.font = getFontWith(YES, 14);
    self.userName.textColor = [UIColor blackColor];
    [self.contentView addSubview:self.userName];
    
    self.jobTitle = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(self.userHead.frame)+10, CGRectGetMaxY(self.userName.frame), 200, 10)];
    self.jobTitle.font = getFontWith(NO, 10);
    self.jobTitle.textColor = colorWithHex(0x999999);
    [self.contentView addSubview:self.jobTitle];
    
    self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(240, 10, 50, 10)];
    self.timeLabel.font = getFontWith(NO, 10);
    self.timeLabel.textColor = colorWithHex(0x999999);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:self.timeLabel];
    
    self.content = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.userHead.frame) + 10, 280, 20)];
    self.content.numberOfLines = INT32_MAX;
    self.content.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:self.content];
}

- (void)dealloc
{
    self.userName = nil;
    self.userHead = nil;
    self.content = nil;
    self.timeLabel = nil;
}

- (void)setComment:(Comment *)comment
{
    _comment = comment;
    self.userHead.imageURL = [NSURL URLWithString:_comment.userAvatar];
    self.userName.text = _comment.userName;
    self.jobTitle.text = [NSString stringWithFormat:@"%@ %@",_comment.userCompany,_comment.userJob];
    self.timeLabel.text = [Common timeIntervalStringFromTime:_comment.createTime];
    self.content.text = _comment.content;
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = CGSizeZero;
    //    重绘评论内容，必须有这个方法cell才会改变，没有这个方法仅仅是算出高度
    if (isSystemVersionIOS7()) {
        size = [_comment.content boundingRectWithSize:CGSizeMake(280 , CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:nil].size;
    }else{
        size = [_comment.content sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    }
    self.content.height = size.height;
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
