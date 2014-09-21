//
//  PublishSecretViewController.m
//  闺秘
//
//  Created by floar on 14-6-24.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "PublishSecretViewController.h"
#import "LogicManager+ImagePiker.h"
#import <UIImage+Screenshot.h>
#import "ShareBlurView.h"
#import "DetailSecretViewController.h"
#import "NetWorkEngine.h"
#import "Feed.h"
#import "NetWorkEngine.h"
#import "Package.h"
#import "UserInfo.h"

#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

@interface PublishSecretViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UITextViewDelegate,UITextFieldDelegate>
{
    UIImageView *bottomImage;
    UITextView *pubTextView;
    UIView *bottonView;
    
    NSMutableArray *bottonImageArray;
    int index;
    NSString *imgStr;
    
    BOOL ownImage;
    
    UILabel *placeHolderLabel;
    
}

@property (weak, nonatomic) IBOutlet UITableView *publishTableView;

@end

@implementation PublishSecretViewController
@synthesize publishTableView;

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
    
    [self.navigationItem setTitleString:@"闺秘"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_close_n"] imageSelected:[UIImage imageNamed:@"btn_close_h"] title:nil inset:UIEdgeInsetsMake(0, -10, 0, 10) target:self selector:@selector(goToBack)];
    [self.navigationItem setRightBarButtonItem:nil imageSelected:nil title:@"发布" inset:UIEdgeInsetsZero target:self selector:@selector(publishSecret)];
    
    publishTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    publishTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    publishTableView.scrollEnabled = NO;
    
    index = arc4random()%12;
    ownImage = NO;
    
    bottonImageArray = [[NSMutableArray alloc] init];
    [bottonImageArray addObjectsFromArray:@[[UIColor redColor],[UIColor greenColor],[UIColor brownColor]]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardMiss)];
    [publishTableView addGestureRecognizer:tap];
    
    //键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    
    //网络
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:PublishSecretCode block:^(int event, id object)
    {
        if (1 == event)
        {
            Package *pack = (Package *)object;
            
            if ([pack handlePublishSecret:pack withErrorCode:NoCheckErrorCode])
            {
                [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"发布成功" actionText:@"确定"];
                [pubTextView resignFirstResponder];
                pubTextView.text = @"";
            }
        }
        
    }];
    
    //UITextView placeHolder
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 120,120,25)];
    placeHolderLabel.text = @"匿名发布秘密";
    placeHolderLabel.font = getFontWith(YES, 17);
    placeHolderLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:placeHolderLabel];
    
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self setNeedsStatusBarAppearanceUpdate];
    }
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
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if (indexPath.row == 0)
    {
        
        [self customContentCell:cell];
    }
    else
    {
        [self customBottomCell:cell];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailSecretViewController *detail = [[DetailSecretViewController alloc] initWithNibName:NSStringFromClass([DetailSecretViewController class]) bundle:nil];
    [self.navigationController pushViewController:detail animated:YES];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 320;
    }
    else
    {
        return 184;
    }
}

-(void)customContentCell:(UITableViewCell *)cell
{
    bottomImage = (UIImageView *)[cell.contentView viewWithTag:10];
    if (bottomImage == nil)
    {
        bottomImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
        bottomImage.tag = 10;
        bottomImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_secretCell_background_%d",index]];
        [cell.contentView addSubview:bottomImage];
    }
    
    pubTextView = (UITextView *)[cell.contentView viewWithTag:20];
    if (pubTextView == nil)
    {
        pubTextView = [[UITextView alloc] initWithFrame:CGRectMake(30, 30, 260, 210)];
        pubTextView.tag = 20;
        pubTextView.delegate = self;
        pubTextView.font = getFontWith(NO, 17);
        pubTextView.tintColor = [UIColor whiteColor];
        pubTextView.textAlignment = NSTextAlignmentCenter;
        pubTextView.textColor = [UIColor whiteColor];
        pubTextView.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:pubTextView];
    }
    
    bottonView = [[UIView alloc] initWithFrame:CGRectMake(0, 320-50, 320, 50)];
    bottonView.tag = 100;
    bottonView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bottonView];
    
    UIButton *photoBtn = (UIButton *)[cell.contentView viewWithTag:30];
    if (photoBtn == nil)
    {
        photoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        photoBtn.tag = 30;
        photoBtn.frame = CGRectMake(10, 2, 44, 44);
        [photoBtn setImage:[UIImage imageNamed:@"btn_photo_n"] forState:UIControlStateNormal];
        [photoBtn setImage:[UIImage imageNamed:@"btn_photo_h"] forState:UIControlStateHighlighted];
        [photoBtn addTarget:self action:@selector(photoAction) forControlEvents:UIControlEventTouchUpInside];
        [bottonView addSubview:photoBtn];
    }
    
    UIButton *changeBottonImgBtn = (UIButton *)[cell.contentView viewWithTag:40];
    if (changeBottonImgBtn == nil)
    {
        changeBottonImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        changeBottonImgBtn.tag = 40;
        changeBottonImgBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-10-44, CGRectGetMinY(photoBtn.frame), 44, 44);
        [changeBottonImgBtn setImage:[UIImage imageNamed:@"btn_change_n"] forState:UIControlStateNormal];
        [changeBottonImgBtn setImage:[UIImage imageNamed:@"btn_change_n"] forState:UIControlStateHighlighted];
        [changeBottonImgBtn addTarget:self action:@selector(changeBottonImgAction) forControlEvents:UIControlEventTouchUpInside];
        [bottonView addSubview:changeBottonImgBtn];
    }
    
}

-(void)customBottomCell:(UITableViewCell *)cell
{
    cell.backgroundColor = [UIColor clearColor];
    CustomButton *btn = (CustomButton *)[cell.contentView viewWithTag:50];
    if (btn == nil)
    {
        btn = [CustomButton buttonWithRect:CGRectMake(100, 150, 100, 20) btnTitle:nil btnImage:nil btnSelectedImage:nil];
        btn.tag = 50;
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:@"谁会看这个秘密?" attributes:@{NSFontAttributeName: getFontWith(NO, 12),NSForegroundColorAttributeName:colorWithHex(0xF88BB5)}];
        [btn setAttributedTitle:attribute forState:UIControlStateNormal];
        [btn addButtionAction:^{
            ShareBlurView *blurView = [[ShareBlurView alloc] initWithFrame:CGRectMake(0, 0, 320, [UIScreen mainScreen].bounds.size.height)];
            [blurView shareBlurWithImage:[UIImage imageFromUIView:self.navigationController.view] withBlurType:BlurWhoSeeSecretType];
            [self.navigationController.view addSubview:blurView];
        } buttonControlEvent:UIControlEventTouchUpInside];
        [cell.contentView addSubview:btn];
    }
}

#pragma mark - Actions
-(void)goToBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)publishSecret
{
//    [self sendImage];
    /*
     1,先发地点，再发内容
     2,地点格式：{"city":"深圳","latitude":22.555664,"longitude":113.948302}
     3,内容格式：{content:"内容",img:"http://,或id:1"}
     */
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x01];
    
    //基本数据
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    
    if (pubTextView.text != nil && [pubTextView.text length] > 0 && ![pubTextView.text isEqualToString:@""])
    {
        //内容数据
        NSString *conentStr = pubTextView.text;
        __block NSString *textJsonStr = nil;
        NSMutableDictionary *textDict = [[NSMutableDictionary alloc] init];
        //内容
        [textDict setObject:conentStr forKey:@"content"];
        //组装图片
        if (!ownImage)
        {
            imgStr = [NSString stringWithFormat:@"id:%d",index];
            [textDict setObject:imgStr forKey:@"img"];
            textJsonStr = [[LogicManager sharedInstance] objectToJsonString:textDict];
        }
        else
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            
            [dict setObject:@"png" forKey:@"fileext"];
            [dict setObject:@"upload_image" forKey:@"operation"];
            NSData *imgData = UIImageJPEGRepresentation(bottomImage.image, 0.5);
            
            [[NetWorkEngine shareInstance] postWithData:[[NSURL URLWithString:@"form.cgi" relativeToURL:[NSURL URLWithString:IMAGESERVER]] absoluteString] data:imgData dataKey:@"file" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject)
            {
                NSDictionary *dict = (NSDictionary *)responseObject;
                NSString *imageStr = [dict objectForKey:@"filename"];
                if (imageStr != nil && imageStr.length > 0)
                {
                    imgStr = [NSString stringWithFormat:@"%@/download-image.cgi?%@",DOWNLOADIMAGE,imageStr];
                    if (textDict.count > 0)
                    {
                        [textDict setObject:imgStr forKey:@"img"];
                        textJsonStr = [[LogicManager sharedInstance] objectToJsonString:textDict];
                        
                        //地点数据
                        __block NSString *addressJsonStr = @"";
                        [[LogicManager sharedInstance] queryLocation:^(int event, id object) {
                            if (1 == event)
                            {
                                NSDictionary *dict = (NSDictionary *)object;
                                addressJsonStr = [[LogicManager sharedInstance] objectToJsonString:dict];
                                [pack publishSecretWithUserId:userId userKey:userKey addressJsonStr:addressJsonStr contentJsonStr:textJsonStr];
                            }
                            else if (0 == event)
                            {
                                addressJsonStr = @"";
                                [pack publishSecretWithUserId:userId userKey:userKey addressJsonStr:addressJsonStr contentJsonStr:textJsonStr];
                            }
                            
                            if (textJsonStr.length > 0 && textJsonStr != nil && addressJsonStr.length > 0 && addressJsonStr != nil)
                            {
                                [[NetWorkEngine shareInstance] sendData:pack UniqueCode:PublishSecretCode block:^(int event, id object) {
                                    [pubTextView resignFirstResponder];
                                }];
                            }
                            else
                            {
                                DLog(@"发送数据错误");
                            }
                            
                        }];
                    }
              }
          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              DLog(@"%@",error);
          }];
        }
    }
    else
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"内容不能为空" actionText:@"确定"];
    }
}

-(void)photoAction
{
    [[LogicManager sharedInstance] getImage:self block:^(int event, id object) {
        if (object != nil)
        {
            if (bottomImage != nil)
            {
                ownImage = YES;
                bottomImage.image = object;
                [UIView animateWithDuration:1.0 animations:^{
                    placeHolderLabel.alpha = 0;
                }];
            }
        }
    }];
}

-(void)changeBottonImgAction
{
    if (index > 10)
    {
        index = 0;
    }
    index++;
    bottomImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_secretCell_background_%d",index]];
}

-(void)keyboardMiss
{
    [pubTextView resignFirstResponder];
}

#if 0
-(void)postImageWithImage:(UIImage *)image block:(EventCallBack)block
{
    NSData *imgData = UIImageJPEGRepresentation(image, 0.4);
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    
    [dict setObject:@"png" forKey:@"fileext"];
    [dict setObject:@"upload_image" forKey:@"operation"];
    
    [[NetWorkEngine shareInstance] postWithData:[[NSURL URLWithString:@"form.cgi" relativeToURL:[NSURL URLWithString:IMAGESERVER]] absoluteString] data:imgData dataKey:@"file" parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = (NSDictionary *)responseObject;
//        netImageName = [dict objectForKey:@"filename"];
        if (dict != nil && dict.count > 0)
        {
            NSString *strImage = [dict objectForKey:@"filename"];
            if (block)
            {
                block(1,strImage);
            }
        }
        else
        {
            block(0,nil);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}
#endif


#pragma mark - KeyboardShowOrHidden
-(void)keyBoardHidden:(NSNotification *)note
{
    [publishTableView setContentOffset:CGPointMake(0, 0) animated:YES];
    [UIView animateWithDuration:1.0 animations:^{
        placeHolderLabel.alpha = 1;
        placeHolderLabel.text = @"匿名发布秘密";
    }];
    
    [UIView animateWithDuration:0.25 animations:^{
        bottonView.frame = CGRectMake(0, 320-50, 320, 50);
    }];
    
}

-(void)keyBoardShow:(NSNotification *)note
{
    int keyBoardY = [[[note userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size.height;
    int bottonViewY = [UIScreen mainScreen].bounds.size.height-keyBoardY-50-64;
    
    [publishTableView setContentOffset:CGPointMake(0, 30) animated:YES];
    [UIView animateWithDuration:1.1 animations:^{
        bottonView.frame = CGRectMake(0, bottonViewY, 320, 50);
    }];
}

#pragma mark - UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView
{
    [UIView animateWithDuration:1.0 animations:^{
        placeHolderLabel.alpha = 0;
    }];
    textView.selectedRange = NSMakeRange(textView.text.length, 0);
}

-(void)textViewDidBeginEditing:(UITextView *)textView
{
    [UIView animateWithDuration:1.0 animations:^{
        placeHolderLabel.alpha = 0;
    }];
    
    textView.selectedRange = NSMakeRange(50, 0);

}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView.text.length > 0)
    {
        placeHolderLabel.alpha = 0;
    }
    else
    {
        [UIView animateWithDuration:1.0 animations:^{
            placeHolderLabel.alpha = 1.0;
        }];
    }
}

@end
