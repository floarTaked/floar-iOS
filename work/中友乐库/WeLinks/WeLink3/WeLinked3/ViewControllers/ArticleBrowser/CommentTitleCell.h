//
//  CommentTitleCell.h
//  WeLinked3
//
//  Created by floar on 14-4-14.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import "CustomCellView.h"
#import "Article.h"
#import "Feeds.h"

@interface CommentTitleCell : CustomMarginCellView

//@property (nonatomic, strong) Article *article;
@property (nonatomic, strong) NSDictionary *dateDic;
@property (nonatomic, assign) BOOL isFromFeedList;

-(void)jobArticleCell;
-(void)articleTitleViewCell;
-(void)userPostCell;

-(void)articleFromArticel:(Article *)article;

@end
