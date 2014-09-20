//
//  HeaderViewOfTableView.h
//  UITableViewTest
//
//  Created by floar on 14-9-3.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderViewOfTableView : UIView

@property (nonatomic, assign) double offSetY;


-(void)scrollViewDidScroll:(UIScrollView *)scrollView;

@end
