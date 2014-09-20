//
//  SecondViewController.m
//  KitMoreTest
//
//  Created by floar on 14-6-12.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "SecondViewController.h"
#import "UILabel+Test.h"
#import "CustomButton.h"
#import "CircleProgress.h"
#import <RFToolbarButton.h>
#import "DrawFace.h"
#import "FifthViewController.h"
#import "UIImage+Screenshot.h"
#import "UIImage+Blur.h"


@interface SecondViewController ()<UIScrollViewDelegate>
{
    UIImage *shootImg;
}

@end

@implementation SecondViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBarItem setImage:[UIImage imageNamed:@"msg"]];
        [self.tabBarItem setSelectedImage:[UIImage imageNamed:@"msgSelected"]];
        [self.tabBarItem setImageInsets:UIEdgeInsetsMake(6, 0, -6, 0)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(testTimer:) userInfo:@{@"key": [NSNumber numberWithInt:23]} repeats:YES];
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonItemStyleDone target:self action:@selector(takeBlurAll)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(takeBlurAll)];
    
//    [self testStringByReplacingOccurrencesOfString];
//    [self testCategoryGetAndSetMethod];
//    [self testObserve];
//    [self testScrollView];
//    [self testCustomBtn];
//    [self testCircle];
//    [self testDrawFace];
//    [self testShareSupportBySystem];
    [self testUint_least32_t];
    [self testJsonChineseChactors];
    
//    NSLog(@"%@",NSStringFromCGRect([UIScreen mainScreen].bounds));
    UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [activityView startAnimating];
    [self.view addSubview:activityView];
    
    
    CustomButton *btn = [CustomButton buttonWithRect:CGRectMake(100, 300, 100, 60) btnTitle:@"TestBlur" btnImage:nil btnSelectedImage:nil];
    [btn addButtionAction:^{
        [self testScreenShot];
    } buttonControlEvent:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)testShareSupportBySystem
{
    CustomButton *btn = [CustomButton buttonWithRect:CGRectMake(110, 250, 100, 50) btnTitle:@"UIActivityViewController" btnImage:nil btnSelectedImage:nil];
    [btn sizeToFit];
    NSArray *itemArray = @[UIActivityTypePostToWeibo];
    NSArray *applicationArray = nil;
    
    [btn addButtionAction:^{
        UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:itemArray applicationActivities:applicationArray];
        [self presentViewController:activity animated:YES completion:^{
            
        }];
    } buttonControlEvent:UIControlEventTouchUpInside];
    
    [self.view addSubview:btn];
}

-(void)testDrawFace
{
    DrawFace *draw = [[DrawFace alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    [self.view addSubview:draw];
}

-(void)testJsonChineseChactors
{
    NSString *jsonStr = nil;
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"深圳" forKey:@"city"];
    [dict setObject:[NSNumber numberWithDouble:23.642] forKey:@"lat"];
    [dict setObject:[NSNumber numberWithDouble:43.232] forKey:@"long"];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:nil];
    if (jsonData != nil)
    {
        jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    NSLog(@"%@",jsonStr);
}

-(void)testCircle
{
    CircleProgress *progress = [[CircleProgress alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    [self.view addSubview:progress];
    progress.trackColor = [UIColor blackColor];
    progress.progressColor = [UIColor orangeColor];
    progress.progress = 0.2;
    progress.progressWidth = 10;
}

-(void)testCustomBtn
{
    NSArray *array = [NSArray arrayWithObjects:@"第一个",@"第二个",@"第三个",@"第四个", nil];
    for (int i = 0; i < 4; i++)
    {
        CustomButton *btn = [CustomButton buttonWithRect:CGRectMake(10+i*84, 200, 64, 49) btnTitle:nil btnImage:@"cardHolderSelected" btnSelectedImage:@"cardHolder"];
        btn.tag = 10+i;
        btn.extraData = [array objectAtIndex:i];
        __weak CustomButton *weakBtn = btn;
        [btn addButtionAction:^{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:weakBtn.extraData delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        } buttonControlEvent:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
    }
    
    
}

-(void)testScrollView
{
    UIScrollView *scroll = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    scroll.contentSize = CGSizeMake(0, [UIScreen mainScreen].bounds.size.height*5);
    scroll.contentOffset=  CGPointMake(0, 0);
    scroll.delegate = self;
    scroll.contentInset = UIEdgeInsetsMake(60, 0, 0, 0);
    [self.view addSubview:scroll];
    
    //为什么监听不了?!
    [self addObserver:scroll forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, -60, 320, 48)];
    label.backgroundColor = [UIColor orangeColor];
    label.text = @"text---scroll";
    label.textColor = [UIColor redColor];
    [scroll addSubview:label];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        scroll.contentInset = UIEdgeInsetsMake(30, 0, 0, 0);
    });
}

-(void)testObserve
{
    [self addObserver:self forKeyPath:@"titleTest" options:NSKeyValueObservingOptionNew context:nil];
    [self addObserver:self forKeyPath:@"otherTitle" options:NSKeyValueObservingOptionNew context:nil];
    
    [self willChangeValueForKey:@"titleTest"];
    self.titleTest = @"sdfsl";
    //    [self didChangeValueForKey:@"titleTest"];
    
    self.otherTitle = @"other";
    self.otherTitle = @"other---change";
    
    [self willChangeValueForKey:@"titleTest"];
    self.titleTest = @"你好的发送到";
    [self didChangeValueForKey:@"titleTest"];

}

-(void)testCategoryGetAndSetMethod
{
    //类别确实是需要自己手动添加get和set函数
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
//    label.frame = CGRectMake(50, 50, 100, 40);
    label.text = @"你好";
    label.textString = @"category";
    label.isHidden = YES;
    NSLog(@"!!!%@---%d",label.textString,label.isHidden);
    
    [self.view addSubview:label];
}

-(void)testStringByReplacingOccurrencesOfString
{
    NSString *s = @"哈根达斯,4223|帝王蟹,3717|三文鱼,3255|提拉米苏,2733|生蚝,1860|烤鳗,1451|生鱼片,1430|龙虾色拉,1252|北极贝,1230|鲍鱼片,772|芒果冰沙,730|烤鳗鱼,706|龙虾沙拉,692|海鲜泡饭,600|冰淇淋,508|芒果汁,499|鲍片,357|佛跳墙,308|鲍鱼,295|HGDS,262 ";
    s = [s stringByReplacingOccurrencesOfString:@"|" withString:@""];
    NSCharacterSet *charSet = [NSCharacterSet characterSetWithCharactersInString:@"1234567890"];
    s = [[s componentsSeparatedByCharactersInSet:charSet] componentsJoinedByString:@""];
}

-(void)testScreenShot
{
    static BOOL flag = YES;
    
    UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 300, 250)];
    shootImg = [UIImage screenshot];
    img.image = shootImg;
    [self.view addSubview:img];
    
    if (flag)
    {
        img.hidden = NO;
    }
    else
    {
        img.hidden = YES;
    }
    flag = !flag;

}

-(void)testUint_least32_t
{
    NSString *str = @"ZALB";
    NSData *data = [[NSData alloc] initWithBase64EncodedString:str options:NSUTF8StringEncoding];
    NSLog(@"%@",data);
    
    NSData *bigData = [NSData dataWithBytes:[str cStringUsingEncoding:NSUTF8StringEncoding] length:[str length]];
    NSLog(@"%@",bigData);
}

-(BOOL)isSecretAllNum:(NSString *)secret
{
    if (secret == nil || [secret length] <= 0)
    {
        return NO;
    }
    NSString *regex = @"[0-9]";
    NSPredicate *password = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return  [password evaluateWithObject:secret];
}


-(void)testBlur
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(10, 260, 300, 200)];
    
    UIImageView *blurImg = [[UIImageView alloc] initWithFrame:CGRectMake(0,0, 300, 200)];
    
    float quality = .00001f;
    float blurred = .2f;
    if (shootImg != nil)
    {
        NSData *shotImgDate = UIImageJPEGRepresentation(shootImg, quality);
        UIImage *blurredImage = [[UIImage imageWithData:shotImgDate] blurredImage:blurred];
        blurImg.image = blurredImage;
        
        [view addSubview:blurImg];
        [self.view addSubview:view];
    }
}

-(void)takeBlurAll
{
    [self testBlur];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - normalObserver
+(BOOL)automaticallyNotifiesObserversForKey:(NSString *)key
{
    if ([key isEqualToString:@"titleTest"])
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"titleTest"])
    {
        NSLog(@"change--%@",[change objectForKey:NSKeyValueChangeNewKey]);
    }
    else if ([keyPath isEqualToString:@"otherTitle"])
    {
        NSLog(@"@@@---%@",[change objectForKey:NSKeyValueChangeNewKey]);
    }
    else if ([keyPath isEqualToString:@"contentOffset"])
    {
        NSLog(@"contentOffset---%@",NSStringFromCGSize([[change objectForKey:NSKeyValueChangeNewKey] CGSizeValue]));
    }
}

-(void)testTimer:(id)object1
{
    NSLog(@"------%d",[[[object1 userInfo] objectForKey:@"key"] intValue]);
    
}

@end
