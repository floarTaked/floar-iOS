//
//  CustomButton.h
//  KitMoreTest
//
//  Created by floar on 14-6-18.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^buttionAction)();

@interface CustomButton : UIButton

@property (nonatomic, strong) id extraData;

/*
 1,这样写要报错(点击事件报错),或许是没有严格按照OC的init方法来，RFButton其实最终还是回到系统的init方法中,自定义的+方法之下就是标准的OC自定义init函数的写法,而这个方法之下就是调用了系统的init方法
 2,在UIButton中必须指定UIButtonType并且必须先UIButtonType+方法生成button,再更改button的frame
        A,RFButton中并没有涉及到UIButtonType,但是设置了backgroundColor,如果不设置是看不到button的,因为button的background和父视图的background同一个颜色
 3,为什么要加参数？！不用添加参数,如果不在同一个域可以给button设置id类型的extraData，如果是同一个域block是可以访问的
 4,block会再次retain block内的变量,因此要做内存管理,使用__weak或者__block
*/
//-(CustomButton *)initButtonWithRect:(CGRect)rect buttonType:(UIButtonType)type;

+(instancetype)buttonWithRect:(CGRect)rect btnTitle:(NSString *)title btnImage:(NSString *)image btnSelectedImage:(NSString *)selectedImage;

-(void)addButtionAction:(buttionAction)action buttonControlEvent:(UIControlEvents)controlEvent;

@end
