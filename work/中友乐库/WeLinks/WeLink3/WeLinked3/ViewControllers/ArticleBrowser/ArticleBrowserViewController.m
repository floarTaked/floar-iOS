//
//  ArticleBrowserViewController.m
//  Welinked2
//
//  Created by 牟 文斌 on 12/6/13.
//
//

#import "ArticleBrowserViewController.h"
#import "Article.h"
#import "NetworkEngine.h"
#import "Common.h"
#import "RCLabel.h"
#import "UINavigationBar+Loading.h"
#import "WebViewViewController.h"
#import "CommentListViewController.h"
#import "LogicManager.h"
#import <MBProgressHUD.h>
#import "AppDelegate.h"
#import "WXApi.h"

@interface ArticleBrowserViewController ()<UIWebViewDelegate,EGOImageViewDelegate,UIScrollViewDelegate,WXApiDelegate>
{
    BOOL hasZan;
    BOOL isShareToWeLink;
    BOOL showViewHidden;
    
    __weak IBOutlet UIImageView *bottonImageView;
    
    __weak IBOutlet UIView *showForCover;
    
    __weak IBOutlet UIView *shareView;
    
    __weak IBOutlet UIButton *shareToWeLink;
}

@property (weak, nonatomic) IBOutlet EGOImageView *topViewImageView;

@property (weak, nonatomic) IBOutlet RCLabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *viaSource;
@property (weak, nonatomic) IBOutlet UIImageView *clockImge;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UIWebView *articleContentView;
@property (weak, nonatomic) IBOutlet UIView *toolBar;
@property (weak, nonatomic) IBOutlet UIImageView *sepretorLine;
@property (strong, nonatomic) IBOutlet UIView *titleView;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIButton *supportNum;
@property (weak, nonatomic) IBOutlet UIButton *commentNum;
@property (weak, nonatomic) IBOutlet UIButton *supportButton;

@property (nonatomic, strong) EGOImageView *contentImageView;

@end

@implementation ArticleBrowserViewController
{
    UIActivityIndicatorView *activityView;
//    UIAlertView *shareArticleAlert;
    UIAlertView *allAlertView;
    UIAlertView *shareWeLinkAlert;
    MBProgressHUD *HUD;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    self.article = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    showForCover.hidden = YES;
//    [self.navigationItem setTitleViewWithText:@"文章详情"];
    self.articleContentView.delegate = self;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleWXMessage:) name:@"WXHandleResult" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(HandleWBMessage:) name:@"WBHandleResult" object:nil];
    
    NSString *subString = @"all_default";
    NSRange range = [_article.image rangeOfString:subString];
    if (!range.length)
    {
        self.topViewImageView.imageURL = [NSURL URLWithString:self.article.image];
    }
    else
    {
        self.topViewImageView.backgroundColor = colorWithHex(0xCCCCCC);
    }
    
    
    [self updateUIWithTitle];
    
    self.articleContentView.opaque = NO;
    
    self.articleContentView.scrollView.delegate = self;
    
    [self.navigationItem setLeftBarButtonItemWithWMNavigationItemStyle:WMNavigationItemStyleBack title:nil target:self selector:@selector(backAction:)];
    
    UITapGestureRecognizer *makeShareViewtap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    makeShareViewtap.numberOfTapsRequired = 1;
    [showForCover addGestureRecognizer:makeShareViewtap];
    

}

-(void)HUDCustomAction:(NSString *)title
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.margin = 10.f;
    hud.yOffset = -30.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:1.5];
}

- (void)backAction:(id)sender
{
    [self.navigationController.navigationBar hideLoadingIndicator];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    
    NSArray *array = [[UserDataBaseManager sharedInstance] queryWithClass:[Article class] tableName:nil condition:[NSString stringWithFormat:@"where articleID = '%@'",_article.articleID]];
    Article *article = [array lastObject];
    isShareToWeLink = article.shareToWeLink;
    if (isShareToWeLink)
    {
        [shareToWeLink setImage:[UIImage imageNamed:@"btn_weLink_h"] forState:UIControlStateNormal];
    }
    else
    {
        [shareToWeLink setImage:[UIImage imageNamed:@"btn_weLink_n"] forState:UIControlStateNormal];
    }
    
    [activityView startAnimating];
    activityView.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar showLoadingIndicator];
    
    __weak ArticleBrowserViewController *blockSelf = self;
    [[NetworkEngine sharedInstance] getArticleInfo:_article.articleID block:^(int event, id object) {
        if (1 == event)
        {
            self.article = object;
            //从网上获取赞的状态
            if (1 == article.hasZan)
            {
                hasZan = YES;
                [_supportButton setImage:[UIImage imageNamed:@"btn_support_did"] forState:UIControlStateNormal];
                _article.hasZan = hasZan;
                [self updateUIWithTitle];
            }
            else
            {
                [_supportButton setImage:[UIImage imageNamed:@"btn_support_n"] forState:UIControlStateNormal];
                hasZan = NO;
            }
            //从网上获取分享到WeLink的状态
//            if (1 == [[object objectForKey:@"shareToWeLink"] intValue])
//            {
//                isShareToWeLink = YES;
//                [shareToWeLink setImage:[UIImage imageNamed:@"btn_comment_h"] forState:UIControlStateNormal];
//            }
//            else
//            {
//                [shareToWeLink setImage:[UIImage imageNamed:@"btn_comment_n"] forState:UIControlStateNormal];
//                isShareToWeLink = NO;
//            }
            
            [activityView stopAnimating];
            [self.navigationController.navigationBar hideLoadingIndicator];
            //对传递过来的article的部分数据进行重新赋值
            [blockSelf updateUIWithTitle];
        }
        else
        {
            [self HUDCustomAction:@"请检查网络状况"];
        }
    }];
}


#pragma mark - ViewButton事件
- (IBAction)shareToWeixin:(id)sender {
    
    NSString* image = _article.image;

    if (image !=nil && [image length]>0) {
        
        [[EGOImageLoader sharedImageLoader] loadImageForURL:[NSURL URLWithString:image] observer:self];

    } else
    {
        [self shareTOWechat:[UIImage imageNamed:@"icon"]];
    }
    
//    [self effortOfHUBWithView:showForCover andTitle:@"分享中..."];
    
}

-(void)alertViewAction:(NSString *)title
{
    allAlertView = [[UIAlertView alloc] initWithTitle:nil message:title delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
    [self performSelector:@selector(makeSupportAlertViewHidden) withObject:self afterDelay:0.7];
    
    [allAlertView show];
}

//点赞
- (IBAction)supportAction:(id)sender
{
    if (hasZan)
    {
        [self HUDCustomAction:@"您已经赞"];
    }
    else
    {
        //统计赞次数
        [MobClick event:ARTICLE3];
        
        //赞动画
        CGAffineTransform old = _supportButton.transform;
        [UIView animateWithDuration:0.4 animations:^{
            [_supportButton setImage:[UIImage imageNamed:@"btn_support_did"] forState:UIControlStateNormal];
            CGAffineTransform new = CGAffineTransformScale(old, 1.5, 1.5);
            _supportButton.transform = new;
            
        } completion:^(BOOL finished)
         {
             _supportButton.transform = old;
             
         }];
        
        [[NetworkEngine sharedInstance] supportArticleWithArticleID:_article.articleID andType:@"1" Block:^(int event, id object)
        {
            if (1 == event)
            {
                _article.likeNum++;
                [self.synchornLikeNumdelegate synchornUIWihtLikeNumber:[NSString stringWithFormat:@"%d",_article.likeNum]];
                NSLog(@"%@",self.article.articleID);
                [self updateUIWithTitle];
                //将更改后的赞更新到数据库
                hasZan = !hasZan;
                _article.hasZan = hasZan;
                [_article synchronize:nil];
            }
            
        }];
    }
}

-(void)makeSupportAlertViewHidden
{
    [allAlertView dismissWithClickedButtonIndex:0 animated:YES];
}

//评论
- (IBAction)commentAction:(id)sender
{
    CommentListViewController *commentList = [[CommentListViewController alloc] init];
    commentList.isFromFeedList = NO;
    commentList.article = self.article;
    [self.navigationController pushViewController:commentList animated:YES];

}

//自定义分享View分享到新浪
- (IBAction)xinlangActionBtn:(id)sender
{
    //统计分享到新浪次数
    [MobClick event:CONTACTS8];
    
//    [[LogicManager sharedInstance] sendWeiBo:_article.title];
    [[LogicManager sharedInstance] sendWeiBo:_article.articleID title:_article.title image:_article.image];
}

-(void)effortOfHUBWithView:(UIView *)appearView andTitle:(NSString *)title
{
    HUD = [[MBProgressHUD alloc]initWithView:appearView];
    HUD.labelText = title;
    [HUD show:YES];
    [appearView addSubview:HUD];
    [self performSelector:@selector(makeHUBHidden) withObject:self afterDelay:1.5];
    
}

-(void)makeHUBHidden
{
    [HUD hide:YES afterDelay:1.0];
    HUD.labelText = @"分享成功";
    [self performSelector:@selector(tapAction) withObject:self afterDelay:1.0];
}


- (IBAction)goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)shareToWeLink:(id)sender
{
    if (isShareToWeLink)
    {
        [self HUDCustomAction:@"您已经分享到职脉圈"];
    }
    else
    {
        [[NetworkEngine sharedInstance] shareArticleToWeLinkWithArticleId:_article.articleID Block:^(int event, id object)
         {
             if (1 == event)
             {
                 [self effortOfHUBWithView:self.navigationController.view andTitle:@"分享中..."];
                 
                 CGAffineTransform old = shareToWeLink.transform;
                 [UIView animateWithDuration:0.4 animations:^{
                     [shareToWeLink setImage:[UIImage imageNamed:@"btn_weLink_h.png"] forState:UIControlStateNormal];
                     CGAffineTransform new = CGAffineTransformScale(old, 1.5, 1.5);
                     shareToWeLink.transform = new;
                     
                 } completion:^(BOOL finished)
                  {
                      shareToWeLink.transform = old;
                      
                  }];
             }
             else
             {
                 NSLog(@"---%@",object);
             }
             isShareToWeLink = !isShareToWeLink;
             _article.shareToWeLink = isShareToWeLink;
             [_article synchronize:nil];
         }];
    }
    [self tapAction];
}

-(void)makeShareWeLinkAlertHidden
{
    [shareWeLinkAlert dismissWithClickedButtonIndex:0 animated:YES];
}

//调出自定义分享View
- (IBAction)shareToSNS:(id)sender
{
    if (showViewHidden)
    {
//        [UIView animateWithDuration:2.0 animations:^{
            showForCover.hidden = YES;
//        bottonImageView.image = nil;  
//        }];
    }
    else
    {
        showForCover.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
//        [UIView animateWithDuration:2.0 animations:^{
            showForCover.hidden = NO;
        if (self.view.frame.size.height<500)
        {
            showForCover.frame = CGRectMake(0, 20, showForCover.frame.size.width,480-49-64+47);
            shareView.frame = CGRectMake(0, CGRectGetMaxY(showForCover.frame)-shareView.frame.size.height-18, shareView.frame.size.width, shareView.frame.size.height);
        }
        bottonImageView.image = [UIImage imageNamed:@"img_article_botton1"];
//        }];
    }
    showViewHidden = !showViewHidden;
}

-(void)tapAction
{
    showForCover.hidden = YES;
    showViewHidden = !showViewHidden;
}

#pragma mark - UI
- (void)updateUIWithTitle
{
    if (!_article)
    {
        return;
    }
//    self.titleLabel.y = 10;
    self.titleLabel.y = CGRectGetMaxY(self.topViewImageView.frame)-CGRectGetHeight(self.titleLabel.frame)-CGRectGetHeight(self.viaSource.frame);
    self.titleLabel.x = 15;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = getFontWith(YES, 19);
    self.viaSource.text = _article.via;
    self.viaSource.textColor = [UIColor whiteColor];
    self.time.text = [Common timeIntervalStringFromTime:_article.publishTime];
    self.time.textColor = [UIColor whiteColor];
    [MBProgressHUD showHUDAddedTo:self.articleContentView animated:YES];
    [self.articleContentView loadHTMLString:_article.content baseURL:nil];
    CGSize size;
    [self.titleLabel setText:_article.title];

    self.titleLabel.height = self.titleLabel.optimumSize.height;
    if (isSystemVersionIOS7()) {
        size = [self.viaSource.text boundingRectWithSize:CGSizeMake(self.view.frame.size.width , CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:self.viaSource.font,NSFontAttributeName, nil] context:nil].size;
    }else{
        size = [self.viaSource.text sizeWithFont:self.viaSource.font constrainedToSize:CGSizeMake(self.view.frame.size.width, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    }
    self.viaSource.frame = CGRectMake(15, CGRectGetMinY(self.titleLabel.frame)-20, size.width + 10, CGRectGetHeight(self.viaSource.frame));
    self.clockImge.x = CGRectGetMaxX(self.viaSource.frame) + 5;
    self.clockImge.y = CGRectGetMaxY(self.viaSource.frame) - self.clockImge.height - 3;
    self.time.x = CGRectGetMaxX(self.clockImge.frame);
    self.time.y = self.viaSource.y;
    
    float offset = CGRectGetMaxY(self.titleLabel.frame);
//    float offset = 20;
    
    [self.titleView addSubview:self.viaSource];
    [self.titleView addSubview:self.clockImge];
    [self.titleView addSubview:self.time];
    [self.titleView addSubview:self.sepretorLine];
    
    self.titleView.frame = CGRectMake(0, 0, 320, offset);
    self.titleView.y = -offset-15;
    self.titleView.backgroundColor = [UIColor clearColor];
    [self.articleContentView.scrollView addSubview:self.titleView];
    
//    self.loadingView.y = self.articleContentView.scrollView.contentSize.height;
    
    self.articleContentView.scrollView.contentInset = UIEdgeInsetsMake(offset+42, 0, 0, 0);
    self.articleContentView.scalesPageToFit = NO;
    
    if (isSystemVersionIOS7()) {
        size = [[NSString stringWithFormat:@"%d",_article.likeNum] boundingRectWithSize:CGSizeMake(280 , CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:nil].size;
    }else{
        size = [[NSString stringWithFormat:@"%d",_article.likeNum] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    }

    self.supportNum.width = size.width + 10;
    if (_article.likeNum == 0) {
        self.supportNum.width = 0;
    }
    [self.supportNum setTitle:[NSString stringWithFormat:@"%d",_article.likeNum] forState:UIControlStateNormal];
    [self.supportNum setTitle:[NSString stringWithFormat:@"%d",_article.likeNum] forState:UIControlStateHighlighted];
    [self.supportNum setBackgroundImage:[[UIImage imageNamed:@"img_gray_dot.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5)] forState:UIControlStateNormal ];
    [self.supportNum setBackgroundImage:[[UIImage imageNamed:@"img_gray_dot.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5)] forState:UIControlStateHighlighted ];
    
    if (isSystemVersionIOS7()) {
        size = [[NSString stringWithFormat:@"%d",_article.commentNum] boundingRectWithSize:CGSizeMake(280 , CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName, nil] context:nil].size;
    }else{
        size = [[NSString stringWithFormat:@"%d",_article.commentNum] sizeWithFont:[UIFont systemFontOfSize:14] constrainedToSize:CGSizeMake(280, CGFLOAT_MAX) lineBreakMode:NSLineBreakByWordWrapping];
    }
    self.commentNum.width = size.width + 10;
    if (_article.commentNum == 0)
    {
        self.commentNum.width = 0;
    }
    [self.commentNum setTitle:[NSString stringWithFormat:@"%d",_article.commentNum] forState:UIControlStateNormal ];
    [self.commentNum setTitle:[NSString stringWithFormat:@"%d",_article.commentNum] forState:UIControlStateHighlighted ];
    [self.commentNum setBackgroundImage:[[UIImage imageNamed:@"img_gray_dot.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5)] forState:UIControlStateNormal];
    [self.commentNum setBackgroundImage:[[UIImage imageNamed:@"img_gray_dot.png"] resizableImageWithCapInsets:UIEdgeInsetsMake(7.5, 7.5, 7.5, 7.5)] forState:UIControlStateHighlighted];
}

- (void)updateUIWithImageViewWithImageURL:(NSString *)url
{
    [MBProgressHUD showHUDAddedTo:self.articleContentView animated:YES];
    [self.articleContentView setScalesPageToFit:YES];
    [self.articleContentView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)updateUIWithVedioWithvedioURL:(NSString *)url
{
    [MBProgressHUD showHUDAddedTo:self.articleContentView animated:YES];
    [self.articleContentView setScalesPageToFit:YES];
    [self.articleContentView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

#pragma mark -
- (void)imageViewLoadedImage:(EGOImageView*)imageView
{
    imageView.width = imageView.image.size.width;
    imageView.height = imageView.image.size.height;
    self.articleContentView.scrollView.contentSize = imageView.frame.size;
    self.articleContentView.scrollView.maximumZoomScale = 3;
    self.articleContentView.scalesPageToFit = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [MBProgressHUD hideAllHUDsForView:self.articleContentView animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if (navigationType == UIWebViewNavigationTypeLinkClicked)
    {
        WebViewViewController *view = [[WebViewViewController alloc] init];
        view.request = request;
        [self.navigationController pushViewController:view animated:YES];
        return NO;
    }
    return YES;
}

- (void)imageLoaderDidLoad:(NSNotification*)notification
{
    NSDictionary* dic = (NSDictionary*)[notification userInfo];
    if(dic != nil)
    {
        UIImage* image = [dic objectForKey:@"image"];
        if(image != nil)
        {
            image = [image resizeWithSize:CGSizeMake(100, 100)];
        }
        else
        {
            image = [UIImage imageNamed:@"icon"];
        }
        [self shareTOWechat:image];
    }
    else
    {
        [self shareTOWechat:[UIImage imageNamed:@"icon"]];
    }
}

- (void)imageLoaderDidFailToLoad:(NSNotification*)notification
{
    [self shareTOWechat:[UIImage imageNamed:@"icon"]];
}

-(void)shareTOWechat:(UIImage*)image
{
    //分享到朋友圈次数
    [MobClick event:CONTACTS7];
    
    NSString* identify = _article.articleID;
    NSString* title = _article.title;
//    NSString* describe = _article.summary;
    NSString *describe = @"职脉";
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = describe;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = [NSString stringWithFormat:@"%@/html/article?id=%@",SERVERROOTURL,identify];
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
    
}

#pragma mark - 处理微信、微博返回的处理结果
-(void)handleWXMessage:(NSNotification *)note
{
    SendMessageToWXResp *result = [note object];
    if (result.errCode == 0)
    {
        [self HUDCustomAction:@"微信朋友圈分享成功"];
    }
    else if (result.errCode == -2)
    {
        [self HUDCustomAction:@"分享已取消"];
    }
    else if (result.errCode == -1)
    {
        [self HUDCustomAction:@"信息错误"];
    }
    else if (result.errCode == -3)
    {
        [self HUDCustomAction:@"网络不佳,发送分享失败"];
    }
    else if (result.errCode == -4)
    {
        [self HUDCustomAction:@"未授权给微信"];
    }
    else
    {
        [self HUDCustomAction:@"微信不支持"];
    }
    [self tapAction];
        
}

-(void)HandleWBMessage:(NSNotification *)note
{
    WBBaseResponse *result = [note object];
    if (result.statusCode == WeiboSDKResponseStatusCodeSuccess)
    {
        [self HUDCustomAction:@"新浪微博分享成功"];
    }
    else if (result.statusCode == WeiboSDKResponseStatusCodeSentFail)
    {
        [self HUDCustomAction:@"信息错误"];
    }
    else if (result.statusCode == WeiboSDKResponseStatusCodeUserCancel)
    {
        [self HUDCustomAction:@"已取消分享"];
    }
    else if (result.statusCode == WeiboSDKResponseStatusCodeUserCancelInstall)
    {
        [self HUDCustomAction:@"已取消安装新浪微博"];
    }
    else if (result.statusCode == WeiboSDKResponseStatusCodeUnsupport)
    {
        [self HUDCustomAction:@"新浪微博不支持"];
    }
    else if (result.statusCode == WeiboSDKResponseStatusCodeAuthDeny)
    {
        [self HUDCustomAction:@"未授权新浪微博"];
    }
    else
    {
        [self HUDCustomAction:@"未知错误"];
    }
    [self tapAction];
}


@end
