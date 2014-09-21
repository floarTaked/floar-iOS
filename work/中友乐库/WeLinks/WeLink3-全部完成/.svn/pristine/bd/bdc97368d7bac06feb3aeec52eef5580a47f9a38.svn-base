//
//  InfoDetailCustomCell.m
//  WeLinked3
//
//  Created by Floar on 14-3-4.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "InfoDetailCustomCell.h"
#import <EGOImageView.h>

@implementation InfoDetailCustomCell
{
  
    
    __weak IBOutlet EGOImageView *infoDetailBottonImageView;
    
    __weak IBOutlet UIImageView *cellSupportImageView;
    
    
    __weak IBOutlet UIImageView *cellCommentImageView;
    
    
    __weak IBOutlet UILabel *infoDetailCellContentLabel;
    
    __weak IBOutlet UILabel *infoDetailCellGoodNumLabel;
    
    __weak IBOutlet UILabel *infoDetailCellTalkNumLable;
    
    __weak IBOutlet UIView *infoDetailTopSperView;
    
    CGSize cellSize;
    
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)setArticle:(Article *)article
{
    _article = article;
    infoDetailBottonImageView.backgroundColor = self.cellColor;
    
    NSString *subString = @"all_default";
    NSRange range = [article.image rangeOfString:subString];
    if (!range.length)
    {
        infoDetailBottonImageView.imageURL = [NSURL URLWithString:article.image];
    }
    else
    {
        infoDetailBottonImageView.image = nil;
        infoDetailBottonImageView.backgroundColor = self.cellColor;
    }
    
    infoDetailCellContentLabel.text = article.title;
    infoDetailCellContentLabel.font = getFontWith(YES, 19);
    infoDetailCellGoodNumLabel.text = [NSString stringWithFormat:@"%d",article.likeNum];
    
    cellSize = [article.title sizeWithFont:getFontWith(YES, 19) constrainedToSize:CGSizeMake(infoDetailCellContentLabel.frame.size.width, 2000)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCommentNum:) name:@"changeInfoViewCommentNum" object:nil];
    
    infoDetailCellTalkNumLable.text = [NSString stringWithFormat:@"%d",article.commentNum];
    
    [self setNeedsLayout];
}

-(void)changeCommentNum:(NSNotification *)note
{

    Article *articleNote = [note object];
    if (_article.articleID == articleNote.articleID)
    {
        _article.commentNum = articleNote.commentNum;
        [_changeCommentNumDelegate changeCommentNum];
    }
}

-(void)layoutSubviews
{
    //cellContentLabel的frame
    infoDetailCellContentLabel.frame = CGRectMake(infoDetailCellContentLabel.frame.origin.x, infoDetailCellContentLabel.frame.origin.y, infoDetailCellContentLabel.frame.size.width, cellSize.height);
    //根据cellContentLabel高度调整下面控件高度
    float y = CGRectGetMaxY(infoDetailCellContentLabel.frame) + 5;
    float x = CGRectGetMinX(infoDetailCellContentLabel.frame)+3;
    
    cellSupportImageView.frame = CGRectMake(x, y-2, cellSupportImageView.frame.size.width, cellSupportImageView.frame.size.height);
    infoDetailCellGoodNumLabel.frame = CGRectMake(CGRectGetMaxX(cellSupportImageView.frame) + 5, y, infoDetailCellGoodNumLabel.frame.size.width, infoDetailCellGoodNumLabel.frame.size.height);
    
    cellCommentImageView.frame = CGRectMake(CGRectGetMaxX(infoDetailCellGoodNumLabel.frame), y, cellCommentImageView.frame.size.width, cellCommentImageView.frame.size.height);
    infoDetailCellTalkNumLable.frame = CGRectMake(CGRectGetMaxX(cellCommentImageView.frame)+5, y, infoDetailCellTalkNumLable.frame.size.width, infoDetailCellTalkNumLable.frame.size.height);
    
    [super layoutSubviews];
}

@end
