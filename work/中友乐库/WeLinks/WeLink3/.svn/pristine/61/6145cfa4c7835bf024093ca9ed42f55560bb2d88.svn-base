//
//  InfoDetailCustomCell.h
//  WeLinked3
//
//  Created by Floar on 14-3-4.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Article.h"

@protocol changeUICommentNum <NSObject>

-(void)changeCommentNum;

@end


@interface InfoDetailCustomCell : UITableViewCell

@property (nonatomic, strong) Article *article;
@property (nonatomic, strong) UIColor *cellColor;
@property (nonatomic, weak) id<changeUICommentNum>changeCommentNumDelegate;

@end
