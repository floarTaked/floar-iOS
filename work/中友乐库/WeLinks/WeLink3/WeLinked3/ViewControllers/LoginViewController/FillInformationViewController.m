//
//  FillInformationViewController.m
//  WeLinked3
//
//  Created by jonas on 3/5/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "FillInformationViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegate.h"
@interface FillInformationViewController ()
{
    UIImagePickerController* imagePicker;
}
@property(nonatomic,strong) ImageEditorViewController *imageEditor;
@property(nonatomic,strong) ALAssetsLibrary *library;
@end

@implementation FillInformationViewController

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
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    HUD.labelText = @"Saving...";
    [self.navigationController.view addSubview:HUD];
    
    imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.wantsFullScreenLayout = NO;
    [self.navigationItem setTitleViewWithText:@"基本资料"];
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack
                                                                 title:nil
                                                                target:self
                                                              selector:@selector(back:)];
    [self.navigationItem setRightBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleSave
                                                                  title:@"保存"
                                                                 target:self
                                                               selector:@selector(save:)];
    
    UIView* head = [[UIView alloc]initWithFrame:CGRectMake(0, 0, table.frame.size.width, 40)];
    UILabel* descLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, table.frame.size.width, 40)];
    descLabel.font = [UIFont systemFontOfSize:14];
    descLabel.textAlignment = NSTextAlignmentCenter;
    descLabel.textColor = colorWithHex(0x444444);
    [descLabel setText:@"详细的个人资料,是快速建立人脉的基础"];
    descLabel.shadowColor = [UIColor whiteColor];
    descLabel.shadowOffset = CGSizeMake(0, 1.0);
    [head addSubview:descLabel];
    head.backgroundColor = [UIColor clearColor];
    
    table.tableHeaderView = head;
    
    UITapGestureRecognizer* tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(endEdit:)];
    tap.numberOfTapsRequired = 1;
    tap.delegate = self;
    [table addGestureRecognizer:tap];
    pikerView = [CustomPickerView sharedInstance];
    [self.navigationController.view addSubview:pikerView];
    
    [[LogicManager sharedInstance] queryLocation:^(int event, id object)
    {
        if(event == 0)
        {
            
        }
        else if (event == 1)
        {
            NSString* city = (NSString*)object;
            if(city != nil && [city length]>0)
            {
                NSString* last = [city substringFromIndex:[city length]-1];
                if(last != nil && [last isEqualToString:@"市"])
                {
                    city = [city substringToIndex:[city length]-1];
                }
               NSArray* arr = [[PublicDataBaseManager sharedInstance]
                               queryWithClass:[CityObject class]
                               tableName:@"City"
                               condition:[NSString stringWithFormat:@" where name like '%%%@%%' or fullName like '%%%@%%' ",city,city]];
                if(arr != nil && [arr count]>0)
                {
                    CityObject* obj = [arr objectAtIndex:0];
                    [UserInfo myselfInstance].city = obj.code;
                    [table reloadData];
                }
            }
        }
    }];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([NSStringFromClass([touch.view class]) isEqualToString:@"UITableViewCellContentView"])
    {
        [self.view endEditing:YES];
        return NO;
    }
    return  YES;
}
-(void)endEdit:(UITapGestureRecognizer*)gues
{
    [self.view endEditing:YES];
}
-(void)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)clearState
{
    [self.view endEditing:YES];
    [UserInfo myselfInstance].name = nameTextFiled.text;
    [UserInfo myselfInstance].company = companyTextFiled.text;
    [pikerView hide];
}
-(BOOL)check
{
    if(newHeadImage == nil && ([UserInfo myselfInstance].avatar == nil || [[UserInfo myselfInstance].avatar length]<=0))
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"请选择头像" actionText:@"确定"];
        return NO;
    }
    if([UserInfo myselfInstance].name == nil || [[UserInfo myselfInstance].name length]<=0)
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"请填写姓名" actionText:@"确定"];
        return NO;
    }
    if([UserInfo myselfInstance].company == nil || [[UserInfo myselfInstance].company length]<=0)
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"请填写公司" actionText:@"确定"];
        return NO;
    }
    if([UserInfo myselfInstance].job == nil || [[UserInfo myselfInstance].job length]<=0)
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"请选择职位" actionText:@"确定"];
        return NO;
    }
    if([UserInfo myselfInstance].city == nil || [[UserInfo myselfInstance].city length]<=0)
    {
        [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"请选择所在地" actionText:@"确定"];
        return NO;
    }
    return YES;
}
-(void)save:(id)sender
{
    [self clearState];
    if(![self check])
    {
        return;
    }
    NSData* avatarData = nil;
    if(newHeadImage != nil)
    {
        avatarData = UIImageJPEGRepresentation(newHeadImage,0.4);
    }
    [HUD show:YES];
    
    if(avatarData == nil)
    {
        [[NetworkEngine sharedInstance] saveUserInfoWithUrl:[UserInfo myselfInstance].avatar
                                                       name:[UserInfo myselfInstance].name
                                                    company:[UserInfo myselfInstance].company
                                                       city:[UserInfo myselfInstance].city
                                                        job:[UserInfo myselfInstance].jobCode
                                                      block:^(int event, id object)
         {
             if(event == 0)
             {
                 [HUD hide:YES];
                 [[LogicManager sharedInstance] showAlertWithTitle:@"" message:(NSString*)object actionText:@"确定"];
             }
             else if (event == 1)
             {
                 if(object != nil)
                 {
                     [headImageView setImage:newHeadImage];
                     
                     HUD.labelText = @"保存成功";
                     HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Checkmark"]];
                     HUD.mode = MBProgressHUDModeCustomView;
                     [HUD hide:YES afterDelay:2];
                     
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                         [(AppDelegate*)([UIApplication sharedApplication].delegate) login];
                     });
                 }
                 else
                 {
                     [HUD hide:YES];
                 }
             }
         }];
    }
    else
    {
        [[NetworkEngine sharedInstance] saveUserInfoWithData:avatarData
                                                name:[UserInfo myselfInstance].name
                                             company:[UserInfo myselfInstance].company
                                                city:[UserInfo myselfInstance].city
                                                 job:[UserInfo myselfInstance].jobCode
                                               block:^(int event, id object)
         {
             if(event == 0)
             {
                 [HUD hide:YES];
                 [[LogicManager sharedInstance] showAlertWithTitle:@"" message:(NSString*)object actionText:@"确定"];
             }
             else if (event == 1)
             {
                 if(object != nil)
                 {
                     [headImageView setImage:newHeadImage];
                     
                     HUD.labelText = @"保存成功";
                     HUD.customView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Checkmark"]];
                     HUD.mode = MBProgressHUDModeCustomView;
                     [HUD hide:YES afterDelay:2];
                     
                     dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(),^{
                         [(AppDelegate*)([UIApplication sharedApplication].delegate) login];
                     });
                 }
             }
         }];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma --mark 选择头像
-(void)setAvatar:(UIImage*)image
{
    headImageView.image = image;
    newHeadImage = image;
}
- (void)showCamera
{
    [self initEditController];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    [imagePicker setCameraDevice:UIImagePickerControllerCameraDeviceFront];
    [imagePicker setCameraFlashMode:UIImagePickerControllerCameraFlashModeAuto];
    imagePicker.showsCameraControls = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)showPhotoLibrary
{
    [self initEditController];
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    [self presentViewController:imagePicker animated:YES completion:nil];
}
#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self showCamera];
            break;
        case 1:
            [self showPhotoLibrary];
            break;
        case 2:
            break;
        default:
            break;
    }
}
-(void)takePhoto:(id)sender
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                                 delegate:self
                                                        cancelButtonTitle:@"取消"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"拍照",@"相册",nil];
        [actionSheet showInView:self.view];
    }
    else
    {
        [self showPhotoLibrary];
    }
}
-(void)initEditController
{
    self.library = [[ALAssetsLibrary alloc] init];
    self.imageEditor = [[ImageEditorViewController alloc] initWithNibName:@"ImageEditorViewController" bundle:nil];
    __weak UIImagePickerController* piker =  imagePicker;
    __weak typeof(self) weakSelf = self;
    self.imageEditor.doneCallback = ^(int event,id object)
    {
        if(event == 1)
        {
            if(object != nil)
            {
                [weakSelf setAvatar:object];
            }
        }
        else
        {
            [piker popViewControllerAnimated:YES];
        }
    };
}
#pragma --mark UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    [picker dismissViewControllerAnimated:NO completion:nil];
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image =  [info objectForKey:UIImagePickerControllerOriginalImage];
    NSURL *assetURL = [info objectForKey:UIImagePickerControllerReferenceURL];
    
    [self.library assetForURL:assetURL resultBlock:^(ALAsset *asset) {
        UIImage *preview = [UIImage imageWithCGImage:[asset aspectRatioThumbnail]];
        
        self.imageEditor.sourceImage = image;
        self.imageEditor.previewImage = preview;
        [self.imageEditor reset:NO];
        
        [picker dismissViewControllerAnimated:NO completion:nil];
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:self.imageEditor animated:YES];
        self.hidesBottomBarWhenPushed = NO;
    } failureBlock:^(NSError *error) {
        NSLog(@"Failed to get asset from library");
    }];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:nil];
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self clearState];
}
#pragma --mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [pikerView hide];
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self clearState];
    return YES;
}
#pragma --mark TableView

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        return 70;
    }
    return 55;
}
- (CustomMarginCellView *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* Identifier = @"Cell";
    CustomMarginCellView* cell = [tableView dequeueReusableCellWithIdentifier:Identifier];
    if(cell == nil)
    {
        cell = [[CustomMarginCellView alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:Identifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        UIView* cellBackgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        cellBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.backgroundView = cellBackgroundView;
        
        
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.font = getFontWith(YES, 14);
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.font = getFontWith(NO, 12);
        cell.detailTextLabel.textColor = colorWithHex(0x3287E6);
    }
    cell.textLabel.text = @"";
    cell.imageView.image = nil;
    cell.detailTextLabel.text = @"";
    if(indexPath.row == 0)
    {
        cell.textLabel.text = @"形象照";
        headImageView = (EGOImageView*)[cell.contentView viewWithTag:100];
        if(headImageView == nil)
        {
            headImageView = [[EGOImageView alloc]initWithFrame:CGRectMake(cell.contentView.frame.size.width-80, 10, 50, 50)];
            headImageView.tag = 100;
            headImageView.placeholderImage = [UIImage imageNamed:@"defaultHead"];
            [cell.contentView addSubview:headImageView];
        }
        if(newHeadImage == nil)
        {
            [headImageView setImageURL:[NSURL URLWithString:[UserInfo myselfInstance].avatar]];
        }
        else
        {
            headImageView.image = newHeadImage;
        }
        [self customLine:cell height:70];
    }
    else if(indexPath.row == 1)
    {
        cell.textLabel.text = @"真实姓名";
        [self customLine:cell height:55];
        nameTextFiled = [self customTextFiled:cell];
        [nameTextFiled setText:[UserInfo myselfInstance].name];
    }
    else if(indexPath.row == 2)
    {
        cell.textLabel.text = @"公司";
        [self customLine:cell height:55];
        companyTextFiled = [self customTextFiled:cell];
        [companyTextFiled setText:[UserInfo myselfInstance].company];
    }
    else if(indexPath.row == 3)
    {
        cell.textLabel.text = @"职位";
        [self customLine:cell height:55];
        
        NSString* job = [UserInfo myselfInstance].job;
        if(job == nil || [job length]<=0)
        {
            cell.detailTextLabel.text = @"待补充";
        }
        else
        {
            cell.detailTextLabel.text = job;
        }
    }
    else if(indexPath.row == 4)
    {
        cell.textLabel.text = @"所在地";
        if([UserInfo myselfInstance].city == nil || [[UserInfo myselfInstance].city length]<=0)
        {
            cell.detailTextLabel.text = @"待补充";
        }
        else
        {
            CityObject* city = [[LogicManager sharedInstance] getPublicObject:[UserInfo myselfInstance].city type:City];
            cell.detailTextLabel.text = city.name;
        }
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if(indexPath.row == 0)
    {
        [self takePhoto:nil];
    }
    if(indexPath.row == 3)
    {
        //职位
        pikerView.pickerType = Job;
        [pikerView showWithObject:[UserInfo myselfInstance].jobCode block:^(int event, id object)
         {
             if(event == 1)
             {
                 JobObject* job = (JobObject*)object;
                 [UserInfo myselfInstance].jobCode = job.code;
                 [self clearState];
                 [tableView reloadData];
             }
         }];
    }
    else if (indexPath.row == 4)
    {
        //所在地
        pikerView.pickerType = City;
        [pikerView showWithObject:[UserInfo myselfInstance].city block:^(int event, id object)
         {
             if(event == 1)
             {
                 CityObject* ct = (CityObject*)object;
                 [UserInfo myselfInstance].city = ct.code;
                 [self clearState];
                 [tableView reloadData];
             }
         }];
    }
}
-(void)customLine:(UITableViewCell*)cell height:(float)height
{
    if(cell == nil || cell.contentView == nil)
    {
        return;
    }
    UIView* line = [cell.contentView viewWithTag:2];
    if(line == nil)
    {
        line = [[UIView alloc]initWithFrame:CGRectMake(0, height-0.5, cell.frame.size.width, 0.5)];
        line.backgroundColor = colorWithHex(0xCCCCCC);
        line.tag = 2;
        [cell.contentView addSubview:line];
    }
}
-(UITextField*)customTextFiled:(UITableViewCell*)cell
{
    if(cell == nil || cell.contentView == nil)
    {
        nil;
    }
    AutoScrollUITextField* textField = (AutoScrollUITextField*)[cell.contentView viewWithTag:200];
    if(textField == nil)
    {
        textField = [[AutoScrollUITextField alloc]initWithFrame:CGRectMake(115, 5, cell.frame.size.width-150, 50)];
        textField.table = table;
        textField.tag = 200;
        textField.returnKeyType = UIReturnKeyDone;
        textField.delegate = self;
        [cell.contentView addSubview:textField];
        textField.backgroundColor = [UIColor clearColor];
        textField.textAlignment = NSTextAlignmentRight;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.font = getFontWith(NO, 12);
        textField.textColor = colorWithHex(0x3287E6);
        if ([textField respondsToSelector:@selector(setAttributedPlaceholder:)])
        {
            textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"待补充"
                                                                              attributes:@{NSForegroundColorAttributeName:colorWithHex(0x3287E6)}];
        }
    }
    return textField;
}
@end
