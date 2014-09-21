//
//  UIControl(AutoScroll).h
//  WeLinked3
//
//  Created by jonas on 2/26/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AutoScrollUITextField:UITextField
{
    CGPoint oriOffset;
}
@property(nonatomic,strong)UITableView* table;
@end
