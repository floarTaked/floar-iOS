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
#import "GIFImageView.h"
@interface PublishSecretViewController ()<UITableViewDataSource,UITableViewDelegate,CLLocationManagerDelegate,UITextViewDelegate,UITextFieldDelegate,MBProgressHUDDelegate>
{
    GIFImageView *bottomImage;
    UITextView *pubTextView;
    UIView *bottonView;
    
    NSMutableArray *bottonImageArray;
    int index;
    NSString *imgStr;
    BOOL hubSuccess;
    BOOL ownImage;
    
    UILabel *placeHolderLabel;
    UIButton *sendBtn;
    UIBarButtonItem *rightBarBtn;
    UIActivityIndicatorView *sendIndicator;
    UIImageView *swipImg;
    
    MBProgressHUD *hud;
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
    
    hubSuccess = NO;
    
    self.view.bounds = [UIScreen mainScreen].bounds;
    
    [self.navigationItem setTitleString:@"闺秘"];
    [self.navigationItem setLeftBarButtonItem:[UIImage imageNamed:@"btn_close_n"] imageSelected:[UIImage imageNamed:@"btn_close_h"] title:nil inset:UIEdgeInsetsMake(0, -15, 0, 15) target:self selector:@selector(goToBack)];
//    [self.navigationItem setRightBarButtonItem:nil imageSelected:nil title:@"发布" inset:UIEdgeInsetsZero target:self selector:@selector(publishSecret)];
    sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    sendBtn.frame = CGRectMake(0, 0, 44, 44);
    [sendBtn setTitle:@"发布" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [sendBtn addTarget:self action:@selector(publishSecret) forControlEvents:UIControlEventTouchUpInside];
    rightBarBtn = [[UIBarButtonItem alloc] initWithCustomView:sendBtn];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
    
    publishTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    publishTableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    publishTableView.scrollEnabled = NO;
    publishTableView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    index = arc4random()%12;
    ownImage = NO;
    
    bottonImageArray = [[NSMutableArray alloc] init];
    [bottonImageArray addObjectsFromArray:@[[UIColor redColor],[UIColor greenColor],[UIColor brownColor]]];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyboardMiss)];
    [publishTableView addGestureRecognizer:tap];
    
    //UITextView placeHolder
    placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 120,120,25)];
    placeHolderLabel.text = @"匿名发布秘密";
    placeHolderLabel.font = getFontWith(YES, 17);
    placeHolderLabel.textColor = [UIColor whiteColor];
    [self.view addSubview:placeHolderLabel];
    
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.delegate = self;
    [self.navigationController.view addSubview:hud];
    
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftAndRightGesture:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftAndRightGesture:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHidden:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardShow:) name:UIKeyboardWillShowNotification object:nil];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)])
    {
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        [self setNeedsStatusBarAppearanceUpdate];
    }
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    DLog(@"memoryWarning:%@",NSStringFromClass([self class]));
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

//- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
//{
//    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
//    {
//        [self.view endEditing:YES];
//        return NO;
//    }
//    return  YES;
//}

-(void)customContentCell:(UITableViewCell *)cell
{
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftAndRightGesture:)];
    [cell.contentView addGestureRecognizer:swipeGesture];
    
    bottomImage = (GIFImageView *)[cell.contentView viewWithTag:10];
    if (bottomImage == nil)
    {
        bottomImage = [[GIFImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
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
    bottomImage.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin;
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
        [MobClick event:move_change_bg];
        changeBottonImgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        changeBottonImgBtn.tag = 40;
        changeBottonImgBtn.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-10-44, CGRectGetMinY(photoBtn.frame), 44, 44);
        [changeBottonImgBtn setImage:[UIImage imageNamed:@"btn_change_n"] forState:UIControlStateNormal];
        [changeBottonImgBtn setImage:[UIImage imageNamed:@"btn_change_n"] forState:UIControlStateHighlighted];
        [changeBottonImgBtn addTarget:self action:@selector(changeBottonImgAction) forControlEvents:UIControlEventTouchUpInside];
        [bottonView addSubview:changeBottonImgBtn];
    }
    
    swipImg = (UIImageView *)[cell.contentView viewWithTag:70];
    if (swipImg == nil)
    {
        swipImg = [[UIImageView alloc] initWithFrame:CGRectMake(60, 10, 200, 25)];
        swipImg.image = [UIImage imageNamed:@"img_swipe"];
        swipImg.alpha = 0;
        [cell.contentView addSubview:swipImg];
        
        //第一次进入发布秘密界面显示bottonImage提示
        [self showSwipBGTip];
    }
    
}

-(void)customBottomCell:(UITableViewCell *)cell
{
    cell.backgroundColor = [UIColor clearColor];
    CustomButton *btn = (CustomButton *)[cell.contentView viewWithTag:50];
    if (btn == nil)
    {
        if ([UIScreen mainScreen].bounds.size.height > 480)
        {
            btn = [CustomButton buttonWithRect:CGRectMake(110, 150, 100, 20) btnTitle:nil btnImage:nil btnSelectedImage:nil];
        }
        else
        {
            btn = [CustomButton buttonWithRect:CGRectMake(110, 60, 100, 20) btnTitle:nil btnImage:nil btnSelectedImage:nil];
        }
        btn.tag = 50;
        NSAttributedString *attribute = [[NSAttributedString alloc] initWithString:@"谁会看这个秘密?" attributes:@{NSFontAttributeName: getFontWith(NO, 12),NSForegroundColorAttributeName:colorWithHex(0xD0246C)}];
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
    [MobClick event:publish_close];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)leftAndRightGesture:(UISwipeGestureRecognizer *)swipe
{
    int i = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"publishChangeBG"];
    
    if (0 == i)
    {
        [UIView animateWithDuration:1.0 animations:^{
            swipImg.alpha = 1.0;
        }];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:1.0 animations:^{
                swipImg.alpha = 0;
            } completion:^(BOOL finished) {
                [swipImg removeFromSuperview];
            }];
           [[LogicManager sharedInstance] setPersistenceData:@2 withKey:@"publishChangeBG"];
        });
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft)
    {
        [self changeBottonImgAction];
    }
    else if (swipe.direction == UISwipeGestureRecognizerDirectionRight)
    {
        [self changeBottonImgAction];
    }
}

-(void)publishSecret
{
    [MobClick event:publish_button];
//    [self sendImage];
    /*
     1,先发地点，再发内容
     2,地点格式：{"city":"深圳","latitude":22.555664,"longitude":113.948302}
     3,内容格式：{content:"内容",img:"http://,或id:1"}
     */
    if (pubTextView.text != nil && [pubTextView.text length] > 0 && ![pubTextView.text isEqualToString:@""])
    {
        self.navigationItem.rightBarButtonItem = nil;
        sendIndicator = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
        sendIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhite;
        sendIndicator.color = [UIColor whiteColor];
        sendIndicator.hidesWhenStopped = YES;
        [sendIndicator startAnimating];
        UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:sendIndicator];
        self.navigationItem.rightBarButtonItem = barBtn;

        [MobClick event:publish];
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
            
            __block NSString *addressJsonStr = nil;
            [[LogicManager sharedInstance] queryLocation:^(int event, id object) {
                if (1 == event)
                {
                    NSDictionary *dict = (NSDictionary *)object;
                    addressJsonStr = [[LogicManager sharedInstance] objectToJsonString:dict];
                }
                else if (0 == event)
                {
                    addressJsonStr = @"";
                }
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (hubSuccess != YES)
                    {
                        [pubTextView resignFirstResponder];
                        self.navigationItem.rightBarButtonItem = rightBarBtn;
                        [hud show:YES];
                        [hud bringSubviewToFront:publishTableView];
                        hud.labelText = @"发布秘密失败";
                        [hud hide:YES afterDelay:1.0];
                    }
                });
                [[NetWorkEngine shareInstance] publishSecretWith:addressJsonStr contentJsonStr:textJsonStr block:^(int event, id object)
                {
                    [pubTextView resignFirstResponder];
                    if (1 == event)
                    {
                        Package *returnPack = (Package *)object;
                        if (0x01 == [returnPack getProtocalId])
                        {
                            [returnPack reset];
                            uint32_t result = [returnPack readInt32];
                            if (0 == result)
                            {
                                uint64_t feedId = [returnPack readInt64];
                                DLog(@"发布消息成功feedId:%llu",feedId);
                                //触发收藏操作向服务器反馈，本地会有一份collectedFeeds，同时服务器也有一份，而服务器那份的数据来自客户端向服务器上报的
                                [self collectionFeedWithFeedId:feedId];
                                
                                hubSuccess = YES;
                                [sendIndicator stopAnimating];
                                self.navigationItem.rightBarButtonItem = rightBarBtn;
                                [pubTextView resignFirstResponder];
                                pubTextView.text = @"";
                                
                                [hud show:YES];
                                [hud bringSubviewToFront:publishTableView];
                                hud.labelText = @"发送秘密成功";
                                
                                Feed *feed = [[Feed alloc] init];
                                feed.DBUid = [UserInfo myselfInstance].userId;
                                feed.feedId = feedId;
                                feed.contentStr = conentStr;
                                feed.contentJson = textJsonStr;
                                feed.likeNum = 0;
                                feed.commentNum = 0;
                                feed.addressStr = @"朋友";
                                feed.isOwnZanFeed = 0;
                                feed.canComment = 1;
                                feed.createTime = [[NSDate date] timeIntervalSince1970];
                                feed.imageStr = [NSString stringWithFormat:@"img_secretCell_background_%d",index];
                                [feed synchronize:nil];
                                
                                [hud hide:YES afterDelay:1.0 complete:^{
                                    [self.navigationController popViewControllerAnimated:YES];
                                }];
                            }
                            else if (-4 == result)
                            {
                                [hud show:YES];
                                hud.labelText = @"发送表情，程序错误";
                                [hud hide:YES afterDelay:1.0 complete:^{
                                    [self.navigationController popViewControllerAnimated:YES];
                                }];
                            }
                        }
                    }
                }];
            }];
            
        }
        else
        {
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
            [dict setObject:@"upload_image" forKey:@"operation"];
            NSData *imgData = nil;
            NSString* mimeType = @"image/png";
            if(bottomImage.frames == nil || [bottomImage.frames count]<=0)
            {
                [dict setObject:@"png" forKey:@"fileext"];
                imgData = UIImageJPEGRepresentation(bottomImage.image, 0.5);
            }
            else
            {
                mimeType = @"image/gif";
                [dict setObject:@"gif" forKey:@"fileext"];
                imgData = [NSData dataWithContentsOfFile:bottomImage.filePath];
                if(imgData != nil)
                {
                    unlink([bottomImage.filePath UTF8String]);
                }
            }
            
            NSString* path = [[NSURL URLWithString:@"form.cgi" relativeToURL:[NSURL URLWithString:IMAGESERVER]] absoluteString];
            [[NetWorkEngine shareInstance] postWithData:path
                                                   data:imgData
                                                dataKey:@"file"
                                               mimeType:mimeType
                                             parameters:dict
                                                success:^(AFHTTPRequestOperation *operation, id responseObject)
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
                             }
                             else if (0 == event)
                             {
                                 addressJsonStr = @"";
                             }
                             
                             dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                 if (hubSuccess != YES)
                                 {
                                     [pubTextView resignFirstResponder];
                                     self.navigationItem.rightBarButtonItem = rightBarBtn;
                                     [hud show:YES];
                                     hud.labelText = @"发布秘密失败";
                                     [hud hide:YES afterDelay:1.0];
                                 }

                             });

                             [[NetWorkEngine shareInstance] publishSecretWith:addressJsonStr contentJsonStr:textJsonStr block:^(int event, id object)
                             {
                                 [pubTextView resignFirstResponder];
                                 if (1 == event)
                                 {
                                     Package *returnPack = (Package *)object;
                                     if (0x01 == [returnPack getProtocalId])
                                     {
                                         [returnPack reset];
                                         uint32_t result = [returnPack readInt32];
                                         if (0 == result)
                                         {
                                             [sendIndicator stopAnimating];
                                             self.navigationItem.rightBarButtonItem = rightBarBtn;
                                             [pubTextView resignFirstResponder];
                                             pubTextView.text = @"";
                                             
                                             uint64_t feedId = [returnPack readInt64];
                                             DLog(@"发布消息成功feedId:%llu",feedId);
                                             
                                             [self collectionFeedWithFeedId:feedId];
                                             hubSuccess = YES;
                                             [hud show:YES];
                                             hud.labelText = @"发送秘密成功";
                                             [hud hide:YES afterDelay:1.0 complete:^{
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             }];
                                             
                                             Feed *feed = [[Feed alloc] init];
                                             feed.DBUid = [UserInfo myselfInstance].userId;
                                             feed.feedId = feedId;
                                             feed.contentStr = conentStr;
                                             feed.contentJson = textJsonStr;
                                             feed.likeNum = 0;
                                             feed.commentNum = 0;
                                             feed.addressStr = @"朋友";
                                             feed.isOwnZanFeed = 0;
                                             feed.canComment = 1;
                                             feed.imageStr = imgStr;
                                             feed.createTime = [[NSDate date] timeIntervalSince1970];
                                             [feed synchronize:nil];
                                         }
                                         else if (-4 == result)
                                         {
                                             [hud show:YES];
                                             hud.labelText = @"暂不支持表情";
                                             [hud hide:YES afterDelay:1.0 complete:^{
                                                 [self.navigationController popViewControllerAnimated:YES];
                                             }];
                                         }
                                     }
                                 }
 
                             }];
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
    [[LogicManager sharedInstance] getImage:self block:^(int event, id object)
    {
        if(event == -1)
        {
            //开始处理Gif
            runOnMainQueueWithoutDeadlocking(^{
                hud.labelText = @"Compressing...";
                [hud show:YES];
            });
        }
        else if (event == -2)
        {
            //正在处理Gif
            runOnMainQueueWithoutDeadlocking(^{
                NSNumber* number = (NSNumber*)object;
                NSString* degreeString = [NSString stringWithFormat:@"%.1f%%",[number floatValue]*100.0];
                hud.labelText = @"Compressing...";
                hud.detailsLabelText = degreeString;
            });
        }
        else if (event == -3)
        {
            //处理完成
            runOnMainQueueWithoutDeadlocking(^{
                [hud hide:YES];
                hud.detailsLabelText = @"";
                ownImage = YES;
                bottomImage.image = nil;
                bottomImage = [bottomImage initWithFile:[(NSURL*)object path]];
                [bottomImage play];
                [UIView animateWithDuration:1.0 animations:^{
                    placeHolderLabel.alpha = 0;
                }];
            });
        }
        else if (event == -4)
        {
            //出错
            [hud hide:YES];
        }
        else
        {
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
        }
    }];
}

-(void)showSwipBGTip
{
    int i = [[LogicManager sharedInstance] getPersistenceIntegerWithKey:@"publishChangeBG"];
    if (0 == i)
    {
        [UIView animateWithDuration:1.5 animations:^{
            swipImg.alpha = 1.0;
        }];
        
        [UIView animateWithDuration:2.0 delay:1.5 options:UIViewAnimationOptionTransitionNone animations:^{
            swipImg.alpha = 0.0;
        } completion:^(BOOL finished) {
            [[LogicManager sharedInstance] setPersistenceData:@2 withKey:@"publishChangeBG"];
            [swipImg removeFromSuperview];
        }];
    }
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

//向服务器报告并本地收藏
-(void)collectionFeedWithFeedId:(uint64_t)feedId
{
    [[NetWorkEngine shareInstance] collectFeedWith:feedId block:^(int event, id object)
    {
        if (1 == event)
        {
            Package *returnPack = (Package *)object;
            [returnPack reset];
            uint32_t result = [returnPack readInt32];
            if (0 == result)
            {
                DLog(@"发送收藏成功");
            }
        }
    }];
}


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
    [UIView animateWithDuration:0.5 animations:^{
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
    
    textView.selectedRange = NSMakeRange(50, 50);
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
