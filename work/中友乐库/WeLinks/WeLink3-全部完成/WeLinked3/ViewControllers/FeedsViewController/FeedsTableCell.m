//
//  FeedsTableCell.m
//  WeLinked3
//
//  Created by 牟 文斌 on 2/25/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "FeedsTableCell.h"
#import "FeedsCommentCell.h"
#import "Common.h"
#import "RCLabel.h"
#import "UserInfo.h"
#import "Comment.h"
#import "RCLabel.h"
#import "Article.h"
#import "JobInfo.h"
#import "LogicManager.h"

@interface FeedsTableCell()
@property (weak, nonatomic) IBOutlet UITableView *commentList;
@property (weak, nonatomic) IBOutlet EGOImageView *userHead;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *jobTitle;
@property (weak, nonatomic) IBOutlet UIView *SupportAndCommentContainViwe;
@property (weak, nonatomic) IBOutlet UIView *SupportView;
@property (weak, nonatomic) IBOutlet UILabel *supportNum;
@property (weak, nonatomic) IBOutlet UILabel *commentNum;
@property (weak, nonatomic) IBOutlet UIImageView *commentBG;
@property (weak, nonatomic) IBOutlet UIView *headerLine;
@property (weak, nonatomic) IBOutlet UIView *commentLine;
@property (weak, nonatomic) IBOutlet UIView *supportTopLine;
@property (weak, nonatomic) IBOutlet UIView *supportBottomLine;
@property (weak, nonatomic) IBOutlet UIView *supportButtonBG;

@property (weak, nonatomic) IBOutlet UIView *originView;
@property (weak, nonatomic) IBOutlet RCLabel *feedsLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *commentMaskButton;
@property (weak, nonatomic) IBOutlet UITextField *textInputField;
@property (weak, nonatomic) IBOutlet UIView *commentView;
@property (weak, nonatomic) IBOutlet RCLabel *comment;

@property (weak, nonatomic) IBOutlet UIButton *supportButton;
- (IBAction)support:(id)sender;
- (IBAction)maskClick:(id)sender;

@end

@implementation FeedsTableCell

+(float)cellHeightWithFeed:(Feeds *)feed
{
//    NSLog(@"%d",feed.feedsType);
    float cellHeight = 66;
    //    评论内容
    RCLabel *rcLabel = [[RCLabel alloc] initWithFrame:CGRectMake(20, 20, 280, 41)];
    [rcLabel setText:[NSString stringWithFormat:@"<p><font size = 14 color='#333333' face = Hiragino Kaku Gothic ProN W3>%@ </font></p>",feed.content]];
//    float labelHeight = [UILabel calculateHeightWith:feed.content font:[UIFont fontWithName:@"Hiragino Kaku Gothic ProN W3" size:16] width:280 lineBreakeMode:NSLineBreakByWordWrapping];
//    DLog(@"CellHeight %@ %f %f",feed.content,[rcLabel optimumSize].height,labelHeight);
    
    cellHeight += [rcLabel optimumSize].height + 10; //feed.content.length > 0 ? size.height : 0;

//    DLog(@"feed content %@ height %f",feed.content, [rcLabel optimumSize].height);
    //    判断是否显示原文摘要
    switch (feed.feedsType) {
        case FeedsArticle:
        case FeedsJob:
            cellHeight += 80;
            break;
        case FeedsUserPost:
        {
            NSError *error = nil;
            id data = nil;
            if (feed.targetContent.length) {
                data = [NSJSONSerialization JSONObjectWithData:[feed.targetContent dataUsingEncoding:NSUTF8StringEncoding]
                                                       options:NSJSONReadingMutableLeaves error:&error];
            }
            if(error != nil)
            {
                data = nil;
            }
            if ([[data objectForKey:@"image"] length]) {
                cellHeight += 162;
            }
        }
            break;
        case FeedsUpdateProfile:
            return 95;
            break;
        case FeedsSystem:
            return 197;
            break;
        default:
            break;
    }
    //    赞 评论的人
    cellHeight += 35 ;
//    if (feed.zanUserNum > 0 && feed.commentUserNum > 0) {
//        cellHeight += 35 ;
//    }
    
    //    评论列表高度
//    for (Comment *comment in feed.commentList) {
//        cellHeight += [FeedsCommentCell cellHeightWithComment:comment];
//    }
    cellHeight += 35 * feed.commentList.count;
    
    //    赞评论 View
    switch (feed.feedsType) {
        case FeedsArticle:
        case FeedsJob:
        case FeedsUserPost:
            cellHeight += 50;
            break;
            
        default:
            break;
    }
    
//    用户自己发的和职位信息评论顶部条高度
    if (feed.contentType == FeedContentTypeComment) {
        if (feed.userContent.length) {//评论
            [rcLabel setText:[NSString stringWithFormat:@"<p><font size = 14 color='#333333'face = Hiragino Kaku Gothic ProN W3 >%@</font></p><p><font size = 14 color='#333333'face = Hiragino Kaku Gothic ProN W3 >发表了评论:\n</font></p><p><font size = 15 color='#333333'face = Hiragino Kaku Gothic ProN W3 >“</font></p><p><font size = 14 color='#333333'face = Hiragino Kaku Gothic ProN W3 >%@</font></p><p><font size = 15 color='#333333'face = Hiragino Kaku Gothic ProN W3 >”</font></p>",feed.feedUser,feed.userContent]];
            cellHeight += [rcLabel optimumSize].height + 15;
        }
    }else if(feed.contentType == FeedContentTypeSupport) {//赞
        [rcLabel setText:[NSString stringWithFormat:@"<p><font size = 14 color='#333333'face = Hiragino Kaku Gothic ProN W3 >%@</font></p><p><font size = 14 color='#333333'face = Hiragino Kaku Gothic ProN W3 >赞了</font></p>",feed.feedUser]];
        cellHeight += [rcLabel optimumSize].height + 15;
    }
    
    return cellHeight ;
    
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

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initlize];
}

- (void)initlize
{
    self.commentList.scrollEnabled = NO;
    self.clipsToBounds = YES;
    UITapGestureRecognizer *originTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(originTap)];
    [self.originView addGestureRecognizer:originTap];
    
    UITapGestureRecognizer *headerTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headTap)];
    [self.userHead addGestureRecognizer:headerTap];
    self.userHead.userInteractionEnabled = YES;
    
    self.bgView.layer.borderColor = colorWithHex(0xcccccc).CGColor;
    self.bgView.layer.borderWidth = 0.5;
    
    self.commentBG.image = [[UIImage imageNamed:@"bg_feeds_comment.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10)];
//    self.commentBG.frame = CGRectMake(60, 9, 234, 40);
    
    self.supportButtonBG.layer.cornerRadius = self.supportButton.height / 2;
    self.supportButtonBG.layer.borderColor = colorWithHex(0xCCCCCC).CGColor;
    self.supportButtonBG.layer.borderWidth = 0.5f;
    self.supportButtonBG.clipsToBounds = YES;
    self.commentLine.height = 0.5;
    self.headerLine.height = 0.5;
    self.supportTopLine.height = 0.5;
    self.supportBottomLine.height = 0.5;
    
    self.textInputField.textColor = colorWithHex(0x333333);
    self.SupportAndCommentContainViwe.center = self.center;
}

- (void)originTap
{
    if ([_delegate respondsToSelector:@selector(didClickOriginViewAtCell:)]) {
        [_delegate didClickOriginViewAtCell:self];
    }
}

- (void)headTap
{
    if ([_delegate respondsToSelector:@selector(didClickUserHeadAtCell:)]) {
        [_delegate didClickUserHeadAtCell:self];
    }
}

-(void)setFeeds:(Feeds *)feeds
{
    if (_feeds == feeds) {
        return;
    }
    _feeds = feeds;
    //    用户
    _userHead.imageURL = [NSURL URLWithString:_feeds.userAvatar];
    _userName.text = _feeds.userName;
    _jobTitle.text = [NSString stringWithFormat:@"%@ %@",feeds.userCompany,feeds.userJob];
    //    动态内容
    [_feedsLabel setText:[NSString stringWithFormat:@"<p><font size = 14 color='#333333' face = Hiragino Kaku Gothic ProN W3>%@ </font></p>",_feeds.content]];
    //    评论 赞
    _supportNum.text = [NSString stringWithFormat:@"赞(%d)",_feeds.zanUserNum];
    _commentNum.text = [NSString stringWithFormat:@"评论(%d)",_feeds.commentUserNum];
    [self.commentList reloadData];
    
    _supportButton.selected = _feeds.hasZan;
    
    _timeLabel.text = [Common timeIntervalStringFromTime:_feeds.createTime];
    _timeLabel.font = getFontWith(NO, 10);
    _timeLabel.textColor = colorWithHex(0x999999);
    
//    [self.commentList reloadData];
    self.originView.hidden = NO;
    switch (_feeds.feedsType) {
        case FeedsArticle:
        {
            self.originView.height = 70;
            self.SupportAndCommentContainViwe.height = 50;
            for (UIView *view in self.originView.subviews) {
                [view removeFromSuperview];
            }
            
            NSError* error = nil;
            id data = nil;
            if (_feeds.targetContent.length) {
                data = [NSJSONSerialization JSONObjectWithData:[_feeds.targetContent dataUsingEncoding:NSUTF8StringEncoding]
                                                       options:NSJSONReadingMutableLeaves error:&error];
            }
            if(error != nil)
            {
                data = nil;
            }
            Article *article = [[Article alloc] init];
            
            [article setValuesForKeysWithDictionary:data];
            
            EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(0, 0, 130, 70)];
            imageView.imageURL = [NSURL URLWithString:article.image];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [self.originView addSubview:imageView];
            
            UILabel *summary = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 10, self.width - imageView.width - 60, 40)];
            summary.font = getFontWith(YES, 13);
            summary.textColor = colorWithHex(0x333333);
            summary.text = article.title;
            summary.numberOfLines = 2;
            summary.backgroundColor = [UIColor clearColor];
            [self.originView addSubview:summary];
            
            UILabel *source = [[UILabel alloc] initWithFrame:CGRectMake(summary.x, CGRectGetMaxY(summary.frame) , summary.width, 20)];
            source.font = getFontWith(NO, 10);
            source.textColor = colorWithHex(0x999999);
            source.text = [NSString stringWithFormat:@"来自 %@",article.via];
            [self.originView addSubview:source];
            
        }
            break;
        case FeedsJob:
        {
            self.originView.height = 70;
            self.SupportAndCommentContainViwe.height = 50;
            for (UIView *view in self.originView.subviews) {
                [view removeFromSuperview];
            }
            
            NSError* error = nil;
            id data = nil;
            if (_feeds.targetContent.length) {
                data = [NSJSONSerialization JSONObjectWithData:[_feeds.targetContent dataUsingEncoding:NSUTF8StringEncoding]
                                                       options:NSJSONReadingMutableLeaves error:&error];
            }
            if(error != nil)
            {
                data = nil;
            }
            JobInfo *job = [[JobInfo alloc] init];
            [job setValuesForKeysWithDictionary:data];
            
            EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:CGRectMake(10, 10, 50, 50)];
            imageView.image = [UIImage imageNamed:job.jobImage];
            //            imageView.imageURL = [NSURL URLWithString:job.jobImage];
            [self.originView addSubview:imageView];
            
            UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame) + 10, 10, self.width - imageView.width - 30, 15)];
            title.font = getFontWith(YES, 13);
            title.textColor = colorWithHex(0x333333);
            JobObject *jobObj = [[LogicManager sharedInstance] getPublicObject:job.jobCode type:Job];
            title.text = jobObj.name;
            [self.originView addSubview:title];
            
            UILabel *salary = [[UILabel alloc] initWithFrame:CGRectMake(title.x, CGRectGetMaxY(title.frame) + 10, title.width, 10)];
            salary.font = getFontWith(NO, 10);
            salary.textColor = colorWithHex(0x999999);
            salary.text = [[LogicManager sharedInstance] getSalary:job.salaryLevel];
            [self.originView addSubview:salary];
            
            UILabel *company = [[UILabel alloc] initWithFrame:CGRectMake(title.x, CGRectGetMaxY(salary.frame) + 5, title.width, 10)];
            company.font = getFontWith(NO, 10);
            CityObject *city = [[LogicManager sharedInstance] getPublicObject:job.locationCode type:City];
            company.text = [NSString stringWithFormat:@"%@",city.fullName];
            company.textColor = colorWithHex(0x999999);
            [self.originView addSubview:company];
            
            UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(self.originView.width - 20, self.originView.height/ 2 - 5, 11, 11)];
            arrow.image = [UIImage imageNamed:@"img_arrow.png"];
            [self.originView addSubview:arrow];
        }
            
            break;
        case FeedsUpdateProfile:
            self.originView.height = 0;
            self.SupportAndCommentContainViwe.height = 0;
            self.originView.hidden = YES;
            break;
        case FeedsUserPost:
        {
            
            for ( UIView *view in self.originView.subviews) {
                [view removeFromSuperview];
            }
            
            NSError *error = nil;
            id data = nil;
            if (_feeds.targetContent.length) {
                data = [NSJSONSerialization JSONObjectWithData:[_feeds.targetContent dataUsingEncoding:NSUTF8StringEncoding]
                                                       options:NSJSONReadingMutableLeaves error:&error];
            }
            if(error != nil)
            {
                data = nil;
            }
            self.originView.height = 150;
            self.SupportAndCommentContainViwe.height = 50;
            if (![[data objectForKey:@"image"] length]) {
                self.originView.height = 0;
            }
            EGOImageView *imageView = [[EGOImageView alloc] initWithFrame:self.originView.bounds];
            imageView.imageURL = [NSURL URLWithString:[data objectForKey:@"image"]];
            imageView.contentMode = UIViewContentModeScaleAspectFill;
            imageView.clipsToBounds = YES;
            [self.originView addSubview:imageView];
        }
            
            break;
        default:
            break;
    }
    
    self.userName.font = getFontWith(YES, 14);
    self.userName.textColor = colorWithHex(0x333333);
    self.jobTitle.font = getFontWith(NO, 10);
    self.jobTitle.textColor = colorWithHex(0x999999);
//    self.feedsLabel.font = getFontWith(NO, 13);
//    self.feedsLabel.textColor = colorWithHex(0x333333);
    self.commentNum.textColor = colorWithHex(0x999999);
    self.supportNum.textColor = colorWithHex(0x999999);
    
    self.SupportAndCommentContainViwe.backgroundColor = colorWithHex(0xf1f1f1);
    self.originView.backgroundColor = colorWithHex(0xf1f1f1);
    
    //    用户自己发的和职位信息评论顶部条高度
    if (_feeds.contentType == FeedContentTypeComment) {
        if (_feeds.userContent.length) {//评论
            [_comment setText:[NSString stringWithFormat:@"<p><font size = 14 color='#333333' face = Hiragino Kaku Gothic ProN W3 >%@  </font></p><p><font size = 14 color='#999999' face = Hiragino Kaku Gothic ProN W3 >发表了评论:\n</font></p><img width=12 height=9 src='img_front_quotes.png'></img><p><font size = 15 color='#333333' face = Hiragino Kaku Gothic ProN W3 >%@</font></p><img width=12 height=9 src='img_back_quotes.png'></img>",_feeds.feedUser,_feeds.userContent]];
//            DLog(@"comment is %@",_comment.visibleText);
        }
    }else if(_feeds.contentType == FeedContentTypeSupport){//赞
        [_comment setText:[NSString stringWithFormat:@"<p><font size = 14 color='#333333' face = Hiragino Kaku Gothic ProN W3 >%@</font></p><p><font size = 14 color='#333333' face = Hiragino Kaku Gothic ProN W3 >赞了</font></p>",_feeds.feedUser]];
    }

    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
#pragma mark - 计算各个控件位置
    if (_feeds.contentType > 0 && _feeds.feedsType != FeedsArticle) {
        _commentView.height = [_comment optimumSize].height + 15;
        _comment.height = [_comment optimumSize].height;
        _commentView.y = 10;
        self.commentLine.height = 0.5;
    }else{
        _commentView.height = 0;
        _comment.height = 0;
    }
    
    //    DLog(@"layout feed content %@ height %f",_feeds.content, [_feedsLabel optimumSize].height);
    self.userHead.y = MAX(20, _commentView.bottom + 10);
    self.userName.y = self.userHead.y;
    self.jobTitle.y = self.userName.bottom;
    self.headerLine.y = self.userHead.bottom + 10;
    self.headerLine.height = 0.5;
    _supportButton.selected = _feeds.hasZan;
    
    self.feedsLabel.y = self.headerLine.bottom + 5;
    //    self.feedsLabel.height = _feeds.content.length ? size.height +10 : 0;
    self.feedsLabel.height = [self.feedsLabel optimumSize].height;
//    self.feedsLabel.backgroundColor = [UIColor redColor];
//    DLog(@"content String %@%f frame is %@",[self.feedsLabel visibleText],self.feedsLabel.height ,NSStringFromCGRect(self.feedsLabel.frame));
    self.feedsLabel.width = 280;
    //    原文
    self.originView.y = CGRectGetMaxY(self.feedsLabel.frame) + 5;
    //    赞和评论人列表
    self.SupportView.y = self.originView.bottom + 10;
    if (self.originView.height == 0) {//没有图片的情况
        self.SupportView.y = self.feedsLabel.bottom + 5;
    }
    self.SupportView.height = 35 + _feeds.commentList.count * 35;

    //    评论列表
    self.commentList.y = 26;
    self.commentList.height = 35 * _feeds.commentList.count;
//    self.supportBottomLine.y = self.SupportView.height - 10;
    self.supportBottomLine.height = 0.5;
    
//    评论输入框
    self.SupportAndCommentContainViwe.y = self.height - self.SupportAndCommentContainViwe.height;
    if (self.SupportAndCommentContainViwe.height) {
        self.SupportView.y = self.SupportAndCommentContainViwe.y - self.SupportView.height;
    }
    
    //    评论区域点击
    self.commentMaskButton.frame = self.SupportView.frame;
}

- (void)reloadCommentList
{
    [self.commentList reloadData];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _feeds.commentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    FeedsCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[FeedsCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    cell.comment = [_feeds.commentList objectAtIndex:indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];
//    CGRect rect = [tableView convertRect:rectInTableView toView:self.feedsController.view];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Comment *comment = [self.feeds.commentList objectAtIndex:indexPath.row];
    return [FeedsCommentCell cellHeightWithComment:comment];
}

- (void)dealloc
{
    self.delegate = nil;
    self.feedsController = nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(didSelectCell:)]) {
        [_delegate didSelectCell:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if ([_delegate respondsToSelector:@selector(addNewComment: Cell:)]) {
        [_delegate addNewComment:textField.text Cell:self];
    }
    return YES;
}

- (IBAction)commentButton:(id)sender
{
    if ([_delegate respondsToSelector:@selector(didSelectCell:)]) {
        [_delegate didSelectCell:self];
    }
}

- (IBAction)support:(id)sender
{
    if (!self.feeds.hasZan) {
        [UIView animateWithDuration:0.8 animations:^{
            self.supportButton.transform = CGAffineTransformMakeScale(2.5, 2.5);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.8 animations:^{
                self.supportButton.transform = CGAffineTransformIdentity;
            }];

        }];
    }
    if ([_delegate respondsToSelector:@selector(didClickSupportAtCell:)]) {
        [_delegate didClickSupportAtCell:self];
    }
}

- (IBAction)maskClick:(id)sender
{
    if ([_delegate respondsToSelector:@selector(didClickCommentViewAtCell:)]) {
        [_delegate didClickCommentViewAtCell:self];
    }
}

- (void)clearCommentField
{
    _textInputField.text = @"";
}

@end
