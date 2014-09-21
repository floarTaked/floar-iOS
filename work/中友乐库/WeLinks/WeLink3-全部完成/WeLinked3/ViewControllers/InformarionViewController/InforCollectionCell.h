//
//  InforCollectionCell.h
//  WeLinked3
//
//  Created by Floar on 14-3-4.
//  Copyright (c) 2014年 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Column.h"

@interface InforCollectionCell : UICollectionViewCell

@property (nonatomic, strong) Column *column;
@property (nonatomic, strong) UIColor *cellColor;

-(void)lastCell;

-(void)transOrNot:(BOOL)isAnimation;

@end
