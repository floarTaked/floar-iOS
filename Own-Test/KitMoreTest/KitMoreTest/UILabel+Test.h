//
//  UILabel+Test.h
//  KitMoreTest
//
//  Created by floar on 14-6-16.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Test)

/*
 1,按照类别定义是不应该出现属性的，但是有点时候确实需要属性
 2,如果在类别中声明了@property的属性，系统是不会自动生成get和set函数的，要自己生成
    A,自己实现get，set函数干其他事情
    B,用runtime特性，使用objc_getAxxx/setAxxx
 3,在类别的.m文件中使用@dynamic
 4,类别是两个文件：头文件和实现问题;扩展单独生成就只有一个头文件;虽然扩展可以增加属性，基本都是和类一起在.m文件出现，单独使用还不如类别用得多，并且扩展的方法是必须实现的
*/
@property (nonatomic, strong) NSString *textString;
@property (nonatomic, assign) BOOL isHidden;


@end
