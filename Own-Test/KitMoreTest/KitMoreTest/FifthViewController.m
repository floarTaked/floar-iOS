//
//  FifthViewController.m
//  KitMoreTest
//
//  Created by floar on 14-6-12.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "FifthViewController.h"
#import "TestOneViewController.h"
#import "UIImage-Helpers/UIImage+Screenshot.h"
#import "UIImage-Helpers/UIImage+Blur.h"
#import "CustomButton.h"
#import <POP.h>

#import "TestNetWorkViewController.h"

#import "PopAnimationView.h"

static const int moveImgY1 = 117;
static const int moveImgY2 = 187;

@interface FifthViewController ()<UITextFieldDelegate>
{
    __weak IBOutlet UITextField *field1;
    
    __weak IBOutlet UITextField *filed2;
    
    __weak IBOutlet UIImageView *moveImg;
    
}

//self.squareView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 80.0f,
//self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.squareView
//self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
@property (nonatomic, strong) UIView *squareView;
@property (nonatomic, strong) UISnapBehavior *snapBehavior;
@property (nonatomic, strong) UIDynamicAnimator *animator;

@end

@implementation FifthViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [moveImg moveAnimation];
//    PopAnimationView *popView = [[PopAnimationView alloc] initWithFrame:CGRectMake(0, 300, 320, 60)];
//    [self.view addSubview:popView];
    
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(goToNet)];
    self.navigationItem.rightBarButtonItem = barBtn;
    
    CustomButton *btn = [CustomButton buttonWithRect:CGRectMake(20, 20, 100, 40) btnTitle:@"animation" btnImage:nil btnSelectedImage:nil];
    [btn addButtionAction:^{
        [self testManyViewPopSpringAnimation];
//        popView.animationCenter = CGPointMake(self.view.center.x, 150);
    } buttonControlEvent:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 20, 20)];
    view.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:view];
//    [self testPopWithView:view];
    
    
}

-(void)testField:(UIView *)view
{
    if ([field1 becomeFirstResponder])
    {
        field1.leftView = view;
    }
    else if ([filed2 becomeFirstResponder])
    {
        filed2.leftView = view;
    }
}

-(void)testPopWithView:(UIView *)view
{
    POPSpringAnimation *animation = [POPSpringAnimation animation];
    animation.property = [POPAnimatableProperty propertyWithName:kPOPLayerTranslationX];
    animation.fromValue = @40.0;
    animation.toValue = @0.0;
    animation.springBounciness = 10.0;
    animation.springSpeed = 0.5;
    [view.layer pop_addAnimation:animation forKey:@"pop"];
}

-(void)goToNet
{
    TestNetWorkViewController *netWork = [[TestNetWorkViewController alloc] initWithNibName:NSStringFromClass([TestNetWorkViewController class]) bundle:nil];
    [self.navigationController pushViewController:netWork animated:YES];
}

- (UIView *) newViewWithCenter:(CGPoint)paramCenter  backgroundColor:(UIColor *)paramBackgroundColor{
    UIView *newView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 50.0f, 50.0f)];
    newView.backgroundColor = paramBackgroundColor;
    newView.center = paramCenter;
    return newView;
}

#if 0
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UIView *topView = [self newViewWithCenter:CGPointMake(100.0f, 0.0f)
                              backgroundColor:[UIColor greenColor]];
    UIView *bottomView = [self newViewWithCenter:CGPointMake(100.0f, 50.0f)
                                 backgroundColor:[UIColor redColor]];
    
    [self.view addSubview:topView];
    [self.view addSubview:bottomView];
    
    [super viewDidAppear:animated];
    
    [self createGestureRecognizer];
    [self createSmallSquareView];
    [self createAnimatorAndBehaviors];
    
    //构造动画
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    //gravity
    UIGravityBehavior *gravity = [[UIGravityBehavior alloc]
                                  initWithItems:@[topView, bottomView]];
    [self.animator addBehavior:gravity];
    
    //collision
    UICollisionBehavior *collision = [[UICollisionBehavior alloc]
                                      initWithItems:@[topView, bottomView]];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collision];
    
    //指派不同特性值  弹性bounce
    UIDynamicItemBehavior *moreElasticItem = [[UIDynamicItemBehavior alloc]
                                              initWithItems:@[bottomView]];
    moreElasticItem.elasticity = 1.0f;
    
    UIDynamicItemBehavior *lessElasticItem = [[UIDynamicItemBehavior alloc]
                                              initWithItems:@[topView]];
    lessElasticItem.elasticity = 0.5f;
    [self.animator addBehavior:moreElasticItem];
    [self.animator addBehavior:lessElasticItem];
    
}
- (void) createGestureRecognizer{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
}
#endif

- (void) handleTap:(UITapGestureRecognizer *)paramTap{
    CGPoint tapPoint = [paramTap locationInView:self.view];
    
    if (self.snapBehavior != nil){
        [self.animator removeBehavior:self.snapBehavior];
    }
    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.squareView snapToPoint:tapPoint];
    self.snapBehavior.damping = 0.5f;  //剧列程度
    [self.animator addBehavior:self.snapBehavior];
}
- (void) createSmallSquareView{
    self.squareView = [[UIView alloc] initWithFrame: CGRectMake(0.0f, 0.0f, 80.0f, 80.0f)];
    self.squareView.backgroundColor = [UIColor greenColor];
    self.squareView.center = self.view.center;
    
    [self.view addSubview:self.squareView];
}
- (void) createAnimatorAndBehaviors{
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    UICollisionBehavior *collision = [[UICollisionBehavior alloc] initWithItems:@[self.squareView]];
    collision.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collision];
    
    self.snapBehavior = [[UISnapBehavior alloc] initWithItem:self.squareView snapToPoint:self.squareView.center];
    self.snapBehavior.damping = 0.5f; /* Medium oscillation */
    [self.animator addBehavior:self.snapBehavior];
}


-(void)testManyViewPopSpringAnimation
{
    static BOOL flag = YES;
    NSArray *timeArray = @[@"0.9",@"0.8",@"0.7",@"0.5"];
    for (int i = 0; i < 4; i++)
    {
        PopAnimationView *popView = (PopAnimationView *)[self.view viewWithTag:100+i];
        if (popView == nil)
        {
            popView = [[PopAnimationView alloc] initWithFrame:CGRectMake(0, 568+2, 320, 60)];
            popView.tag = 100 + i;
            [self.view addSubview:popView];
        }
        popView.numLabel = [NSString stringWithFormat:@"---%d",i+1];
        if (flag)
        {
            popView.animationCenter = CGPointMake(self.view.center.x, 150+60*i);
        }
        else{
            [UIView animateWithDuration:[[timeArray objectAtIndex:i] integerValue] animations:^{
                popView.frame = CGRectMake(0, 568+2, popView.frame.size.width, popView.frame.size.height);
            }];
            
        }
    }
    flag = !flag;
}

-(void)testSingleViewPopSpingAnimation
{
    CustomButton *btn = [CustomButton buttonWithRect:CGRectMake(20, 250, 60, 40) btnTitle:@"ViewCtl-Pop" btnImage:nil btnSelectedImage:nil];
    btn.backgroundColor = [UIColor lightGrayColor];
    
    [btn addButtionAction:^{
        TestOneViewController *one = [[TestOneViewController alloc] initWithNibName:NSStringFromClass([TestOneViewController class]) bundle:nil];
        POPSpringAnimation *anim = [POPSpringAnimation animationWithPropertyNamed:kPOPViewCenter];
        anim.toValue = [NSValue valueWithCGPoint:self.view.center];
        anim.dynamicsMass = 3;
        [one pop_addAnimation:anim forKey:@"center"];
        [self presentViewController:one animated:YES completion:^{
            
        }];
    } buttonControlEvent:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];

}

-(void)testImageFromView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 10, 200, 200)];
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    img.image = [UIImage imageNamed:@"emotionShopOne"];
    [view addSubview:img];
    [self.view addSubview:view];
    
    UIImage *shotImg = [UIImage imageFromUIView:view];
    
    UIImageView *blurImage = [[UIImageView alloc] initWithFrame:CGRectMake(10, 210, 200, 200)];
    
    float quality = .00001f;
    float blurred = .2f;
    if (shotImg != nil)
    {
        NSData *shotImgDate = UIImageJPEGRepresentation(shotImg, quality);
        UIImage *blurredImage = [[UIImage imageWithData:shotImgDate] blurredImage:blurred];
        blurImage.image = blurredImage;
        
        [self.view addSubview:blurImage];
    }

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == field1)
    {

            [UIView animateWithDuration:0.5 animations:^{
                moveImg.frame = CGRectMake(CGRectGetMinX(moveImg.frame), moveImgY1-5, CGRectGetWidth(moveImg.frame), CGRectGetHeight(moveImg.frame));
            }];
    }
    else if (textField == filed2)
    {
        NSLog(@"filed2");

            [UIView animateWithDuration:0.5 animations:^{
                moveImg.frame = CGRectMake(CGRectGetMinX(moveImg.frame), moveImgY2-5, CGRectGetWidth(moveImg.frame), CGRectGetHeight(moveImg.frame));
            }];
        
    }
}

@end

@implementation UIImageView (Animation)

-(void)moveAnimation
{
    [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(move1) userInfo:nil repeats:YES];
}

-(void)move1
{
    double x1 = 67;
    double x2 = 77;
    double y = CGRectGetMinY(self.frame);
    int width = CGRectGetWidth(self.frame);
    int height = CGRectGetHeight(self.frame);
    
    [UIView animateWithDuration:0.5 animations:^{
        if (CGRectGetMinX(self.frame) == x1)
        {
            self.frame = CGRectMake(x2, y, width, height);
        }
        else if (CGRectGetMinX(self.frame) == x2)
        {
            self.frame = CGRectMake(x1, y, width, height);
        }
    }];
}

@end
