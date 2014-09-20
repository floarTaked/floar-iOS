//
//  UILabel+Test.m
//  KitMoreTest
//
//  Created by floar on 14-6-16.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "UILabel+Test.h"
#import <objc/runtime.h>

static char UILableTestCategory;

@implementation UILabel (Test)

@dynamic textString,isHidden;

/*
 1,以下两个函数系统自动调用于addsubview之前,全局调用
 2,在Viewcontroller中无法使用,只有在view或者view子类中使用
 */
-(void)willMoveToSuperview:(UIView *)newSuperview
{
//    NSLog(@"%@",newSuperview);
//    NSLog(@"--add-");
}

-(void)didMoveToSuperview
{
    
}

-(void)setTextString:(NSString *)textString
{
//    self.text = textString;
    NSLog(@"%@",textString);
    objc_setAssociatedObject(self, &UILableTestCategory, textString, OBJC_ASSOCIATION_ASSIGN);
}

-(NSString *)textString
{
//    NSString *str = @"category get ";
//    return str;
    return objc_getAssociatedObject(self, &UILableTestCategory);
}

-(void)setIsHidden:(BOOL)isHidden
{
//    NSLog(@"category---%d",isHidden);
    objc_setAssociatedObject(self, &UILableTestCategory, [NSNumber numberWithBool:isHidden], OBJC_ASSOCIATION_ASSIGN);
}


//-(void)setNeedsDisplay
//{
//    NSLog(@"setNeedsDisplay");
//}
//
//-(void)setNeedsLayout
//{
//    NSLog(@"setNeedsLayout");
//}
//
//-(void)drawRect:(CGRect)rect
//{
//    NSLog(@"draw--%@",NSStringFromCGRect(rect));
//}
//
//-(void)layoutSubviews
//{
//    NSLog(@"layoutSubviews");
//}
@end
