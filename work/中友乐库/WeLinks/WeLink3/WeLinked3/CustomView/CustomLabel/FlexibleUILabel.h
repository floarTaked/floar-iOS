//
//  FlexibleUILabel.h
//  WeLinked
//
//  Created by jonas on 11/22/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FlexibleUILabel : UILabel
@property(nonatomic,assign)BOOL fixedHeight;
+(float)calculateHeightWith:(NSString*)text font:(UIFont*)font width:(float)width lineBreakeMode:(NSLineBreakMode)mode;
+(float)calculateWidthWith:(NSString*)text font:(UIFont*)font height:(float)height lineBreakeMode:(NSLineBreakMode)mode;
@end
