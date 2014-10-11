//
//  EmojiView.h
//  Guimi
//
//  Created by jonas on 9/15/14.
//  Copyright (c) 2014 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>
// 人物
#define Emoji_People_key    @"People"
// 物品
#define Emoji_Objects_key   @"Objects"
// 自然
#define Emoji_Nature_key    @"Nature"
// 地点
#define Emoji_Places_key    @"Places"
// 符号
#define Emoji_Symbols_key   @"Symbols"
@interface EmojiView : UIView<UICollectionViewDataSource,UICollectionViewDelegate>
{
    IBOutlet UIPageControl* pageControl;
    IBOutlet UICollectionView* collection;
    int pageIndex;
    NSDictionary* dataSource;
    NSDictionary* viewSource;
    EventCallBack block;
    NSString* key;
}
-(void)setEventBlock:(EventCallBack)callBack;
@end
