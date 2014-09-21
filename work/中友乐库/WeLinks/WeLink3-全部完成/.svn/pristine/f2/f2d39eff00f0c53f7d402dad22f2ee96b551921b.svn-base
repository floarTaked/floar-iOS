//
//  FeedsViewDataManager.m
//  WeLinked3
//
//  Created by 牟 文斌 on 3/3/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "FeedsViewDataManager.h"
#import "Feeds.h"
#import "NetworkEngine.h"

@implementation FeedsViewDataManager

- (void)dealloc
{
    self.feedsList = nil;
    self.delegate = nil;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        self.feedsList = [NSMutableArray array];
        NSArray *array =  [[UserDataBaseManager sharedInstance] queryWithClass:[Feeds class] tableName:nil condition:[NSString stringWithFormat:@"where DBUid = '%@'",[UserInfo myselfInstance].userId]];
        [self.feedsList addObjectsFromArray:array];
    }
    return self;
}

- (void)loadData
{
    [[NetworkEngine sharedInstance] getFeedsListWithBlock:^(int event, id object) {
//         NSLog(@"FeedsList is %@",object);
        if (event == 1) {
            [_feedsList removeAllObjects];
            for (NSDictionary *feedDic in object) {
                Feeds *feed = [[Feeds alloc] init];
                [feed setValuesForKeysWithDictionary:feedDic];
                [self.feedsList addObject:feed];
            }
            if ([_delegate respondsToSelector:@selector(feedsViewDataManagerDidGetFeedsListSuccess:)]) {
                [_delegate feedsViewDataManagerDidGetFeedsListSuccess:self];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(feedsViewDataManagerDidGetFeedsListFailed:)]) {
                [_delegate feedsViewDataManagerDidGetFeedsListFailed:self];
            }
        }
        
    }];
    
}

- (void)loadNextPageData
{
    
    [[NetworkEngine sharedInstance] getNextFeedsWithLastFeed:[self.feedsList lastObject] Block:^(int event, id object) {
//        DLog(@"Next page FeedsList is %@",object);
        if (event == 1) {
            for (NSDictionary *feedDic in object) {
                Feeds *feed = [[Feeds alloc] init];
                [feed setValuesForKeysWithDictionary:feedDic];
                [self.feedsList addObject:feed];
            }
            if ([_delegate respondsToSelector:@selector(feedsViewDataManagerDidGetFeedsListSuccess:)]) {
                [_delegate feedsViewDataManagerDidGetFeedsListSuccess:self];
            }
        }else{
            if ([_delegate respondsToSelector:@selector(feedsViewDataManagerDidGetFeedsListFailed:)]) {
                [_delegate feedsViewDataManagerDidGetFeedsListFailed:self];
            }
        }
        
        
    }];
}

- (void)supportFeed:(Feeds *)feed Block:(EventCallBack)block
{
    [[NetworkEngine sharedInstance] supportFeed:feed type:1 Block:^(int event, id object) {
        DLog(@"support feed is %@",object);
        block(event, object);
        
        
    }];
}

- (void)disSupportFeed:(Feeds *)feed Block:(EventCallBack)block
{
    [[NetworkEngine sharedInstance] supportFeed:feed type:0 Block:^(int event, id object) {
        DLog(@"dissupport feed is %@",object);
        block(event, object);
        
        
    }];
}
@end
