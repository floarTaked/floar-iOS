//
//  CustomCellView.h
//  TableTest
//
//  Created by Stephan on 22.02.09.
//  Copyright 2009 Coriolis Technologies. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomCellBackgroundView.h"
@interface CustomCellView : UITableViewCell
{
    CustomCellBackgroundView *selectedView;
}
@property(nonatomic,strong)UIColor* fillColor;
-(void)setSelectedPosition:(CustomCellBackgroundViewPosition)position;
-(void)setCornerRadius:(float)cornerRadius;
@end

@interface CustomMarginCellView : CustomCellView
@end
@interface CustomWideCellView : CustomCellView
@end