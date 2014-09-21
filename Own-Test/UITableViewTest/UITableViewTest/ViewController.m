//
//  ViewController.m
//  UITableViewTest
//
//  Created by floar on 14-9-2.
//  Copyright (c) 2014年 Floar. All rights reserved.
//

#import "ViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <ALDBlurImageProcessor.h>
#import "NTRMath.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,ALDBlurImageProcessorDelegate,UINavigationControllerDelegate>
{
    UIView *view1;
    UIView *view2;
    UIAlertView *errorAlertView;
    UIImageView *img;
    unsigned long red;
    ALDBlurImageProcessor *blurImageProcessor;
}

@property (weak, nonatomic) IBOutlet UITableView *testTableView;

@end

@implementation ViewController
@synthesize testTableView;

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
    
    [self testStringSep];
    
    [UIApplication sharedApplication].statusBarHidden = YES;
    
    view1 = [self customTableViewHeaderView];
    testTableView.tableHeaderView = view1;
    
    
    
//    self.navigationController.delegate = self;
//    self.navigationController.navigationBar.translucent = YES;
    
    UINavigationBar *navBar = self.navigationController.navigationBar;
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 20, 20)];
    imgView.image = [UIImage imageNamed:@"btn_alertClose_h"];
    [navBar addSubview:imgView];
//    navBar.tintColor = [UIColor redColor];
//    navBar.superview.backgroundColor = [UIColor orangeColor];
//    navBar.backgroundColor = [UIColor orangeColor];
    
    
    
    
    blurImageProcessor = [[ALDBlurImageProcessor alloc] initWithImage:img.image];
//    blurImageProcessor.delegate = self;

}

unsigned long getHexColorValueFromString(NSString *string)
{
    unsigned long value = strtoul([string UTF8String], 0, 16);
    return value;
}

-(void)testStringSep
{
    NSString *colorStr = @"color:#414146";
    NSArray *array = [colorStr componentsSeparatedByString:@":"];
    NSMutableString *str1 = [[NSMutableString alloc] initWithString:[array lastObject]];
    [str1 replaceCharactersInRange:NSMakeRange(0, 1) withString:@"0x"];
    
    red = getHexColorValueFromString(str1);
    //先以16为参数告诉strtoul字符串参数表示16进制数字，然后使用0x%X转为数字类型
    //strtoul如果传入的字符开头是“0x”,那么第三个参数是0，也是会转为十六进制的,这样写也可以：
//    unsigned long red = strtoul([@"0x6587" UTF8String],0,0);
    NSLog(@"转换完的数字为：%lx",red);
    
    NSLog(@"-----%@",[self changeUIColorToRGB:colorWithHex(0x414146)]);
}

- (NSString *) changeUIColorToRGB:(UIColor *)color{
    
    const CGFloat *cs=CGColorGetComponents(color.CGColor);
    
    
    NSString *r = [NSString stringWithFormat:@"%@",[self  ToHex:cs[0]*255]];
    NSString *g = [NSString stringWithFormat:@"%@",[self  ToHex:cs[1]*255]];
    NSString *b = [NSString stringWithFormat:@"%@",[self  ToHex:cs[2]*255]];
    return [NSString stringWithFormat:@"#%@%@%@",r,g,b];
    
    
}

//十进制转十六进制
-(NSString *)ToHex:(int)tmpid
{
    NSString *endtmp=@"";
    NSString *nLetterValue;
    NSString *nStrat;
    int ttmpig=tmpid%16;
    int tmp=tmpid/16;
    switch (ttmpig)
    {
        case 10:
            nLetterValue =@"A";break;
        case 11:
            nLetterValue =@"B";break;
        case 12:
            nLetterValue =@"C";break;
        case 13:
            nLetterValue =@"D";break;
        case 14:
            nLetterValue =@"E";break;
        case 15:
            nLetterValue =@"F";break;
        default:nLetterValue=[[NSString alloc]initWithFormat:@"%i",ttmpig];
            
    }
    switch (tmp)
    {
        case 10:
            nStrat =@"A";break;
        case 11:
            nStrat =@"B";break;
        case 12:
            nStrat =@"C";break;
        case 13:
            nStrat =@"D";break;
        case 14:
            nStrat =@"E";break;
        case 15:
            nStrat =@"F";break;
        default:nStrat=[[NSString alloc]initWithFormat:@"%i",tmp];
            
    }
    endtmp=[[NSString alloc]initWithFormat:@"%@%@",nStrat,nLetterValue];
    return endtmp;
}



UIColor* colorWithHex(int value)
{
    float red   = (value & 0xFF0000)>>16;
    float green = (value & 0x00FF00)>>8;
    float blue  = (value & 0x0000FF);
    UIColor* color = [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:1.0];
    return color;
}


-(UIView *)customTableViewHeaderView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    
    view2 = [[UIView alloc] initWithFrame:view.bounds];
    view2.backgroundColor = [UIColor orangeColor];
    view2.clipsToBounds = YES;
    [view addSubview:view2];
    
    img = [[UIImageView alloc] initWithFrame:view.bounds];
    img.image = [UIImage imageNamed:@"1"];
    
    UIView *view33 = [[UIView alloc] initWithFrame:CGRectMake(40, 40, 100, 100)];
    view33.backgroundColor = colorWithHex(red);
    [img addSubview:view33];
    
    [view2 addSubview:img];
    return view;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"%d",indexPath.section *10+indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}

#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    self.offSetY = scrollView.contentOffset.y;
}


#pragma mark - ALDBlurImageProcessor Notifications
-( void )stopListeningToALDImageProcessorNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: ALDBlurImageProcessorImageReadyNotification
                                                  object: nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver: self
                                                    name: ALDBlurImageProcessorImageProcessingErrorNotification
                                                  object: nil];
}

-( void )startListeningToALDImageProcessorNotifications
{
    [self stopListeningToALDImageProcessorNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(onNewBlurredImage:)
                                                 name: ALDBlurImageProcessorImageReadyNotification
                                               object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(onBlurImageProcessorError:)
                                                 name: ALDBlurImageProcessorImageProcessingErrorNotification
                                               object: nil];
}

-( void )onNewBlurredImage:( NSNotification * )notification
{
    [self applyBlurredImage: notification.userInfo[ ALDBlurImageProcessorImageReadyNotificationBlurrredImageKey ]];
}

-( void )onBlurImageProcessorError:( NSNotification * )notification
{
    [self showBlurImageProcessorErrorCode: notification.userInfo[ ALDBlurImageProcessorImageProcessingErrorNotificationErrorCodeKey ]];
}

#pragma mark - Helpers

-( void )applyBlurredImage:( UIImage * )image
{
    img.image = image;
}

-( void )showBlurImageProcessorErrorCode:( NSNumber * )errorCode
{
    if( errorAlertView )
        return;
    
    errorAlertView = [[UIAlertView alloc] initWithTitle: @"Blur Processing Error"
                                                message: [NSString stringWithFormat: @"Could not generate blurred image: vImage_Error %@", errorCode]
                                               delegate: nil
                                      cancelButtonTitle: @"Ok"
                                      otherButtonTitles: nil];
    
    errorAlertView.delegate = self;
    [errorAlertView show];
}



#pragma mark - Actions
-(void)setOffSetY:(double)offSetY
{
    _offSetY = offSetY;
    CGRect originalRect = view1.frame;
    if (offSetY < 0)
    {
        originalRect.origin.y = offSetY;
        
        originalRect.size.height = -offSetY+originalRect.size.height;
        view2.frame = originalRect;
        
        CGPoint center =  img.center;
        center.y = view2.frame.size.height / 2;
        img.center = center;

        CGFloat scale = fabsf(offSetY)/170;
        img.transform = CGAffineTransformMakeScale(1+scale, 1+scale);
    }
    else
    {
//        img.alpha = 0;
        if (originalRect.origin.y != 0)
        {
            originalRect.origin.y = 0;
            originalRect.size.height = view1.frame.size.height;
            view2.frame = originalRect;
        }
        CGPoint center = view2.center;
        center.y = view2.frame.size.height/2 + 0.5*offSetY;
        img.center = center;
        double original = offSetY/100;
        
        [blurImageProcessor asyncBlurWithRadius:5
                                     iterations:lerp(original, 0, 11)
                                   successBlock:^(UIImage *blurredImage) {
                                       img.image = blurredImage;
                                   }errorBlock:^(NSNumber *errorCode) {
                                       NSLog(@"%@",errorCode);
                                   }];

    }
}

//- (void) navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    // 如果进入的是当前视图控制器
//    if (viewController == self) {
//        // 背景设置为黑色
//        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.000 green:0.000 blue:0.000 alpha:1.000];
//        // 透明度设置为0.3
//        self.navigationController.navigationBar.alpha = 0.300;
//        // 设置为半透明
//        self.navigationController.navigationBar.translucent = YES;
//    } else {
//        // 进入其他视图控制器
//        self.navigationController.navigationBar.alpha = 1;
//        // 背景颜色设置为系统默认颜色
//        self.navigationController.navigationBar.tintColor = nil;
//        self.navigationController.navigationBar.translucent = NO;
//    }
//}

@end
