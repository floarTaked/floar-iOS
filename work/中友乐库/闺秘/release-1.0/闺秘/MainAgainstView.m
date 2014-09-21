//
//  MainAgainstView.m
//  闺秘
//
//  Created by floar on 14-7-15.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "MainAgainstView.h"
#import "NetWorkEngine.h"
#import "Package.h"

@implementation MainAgainstView
{
    
    __weak IBOutlet UIButton *collectionBtn;
    
    __weak IBOutlet UIButton *againstBtn;
    
    __weak IBOutlet UIButton *removeBtn;
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)awakeFromNib
{
    [collectionBtn setTitleColor:colorWithHex(0xD0246C) forState:UIControlStateNormal];
    collectionBtn.titleLabel.font = getFontWith(NO, 14);
    
    [againstBtn setTitleColor:colorWithHex(0xD0246C) forState:UIControlStateNormal];
    againstBtn.titleLabel.font = getFontWith(NO, 14);
    
    [removeBtn setTitleColor:colorWithHex(0xD0246C) forState:UIControlStateNormal];
    removeBtn.titleLabel.font = getFontWith(NO, 14);
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleReasonReturnValue:) name:@"reportReason" object:nil];
    
    //收藏消息
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:CollectFeedCode block:^(int event, id object) {
        if (1 == event)
        {
            Package *pack = (Package *)object;
            if ([pack handleCollectFeed:pack withErrorCode:NoCheckErrorCode])
            {
                [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"收藏成功" actionText:@"确定"];
            }
        }
    }];
    
    //举报消息
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:ReportFeedCode block:^(int event, id object) {
        if (1 == event)
        {
            Package *pack = (Package *)object;
            if ([pack handleReportFeed:pack withErrorCode:NoCheckErrorCode])
            {
                [[LogicManager sharedInstance]showAlertWithTitle:nil message:@"举报成功" actionText:@"确定"];
            }
        }
    }];
    
    //移除消息
    [[NetWorkEngine shareInstance] registBlockWithUniqueCode:DeleteFeedInMainViewCode block:^(int event, id object) {
        if (1 == event)
        {
            Package *pack = (Package *)object;
            if ([pack handleDeleteFeedInMainView:pack withErrorCode:NoCheckErrorCode])
            {
                [[LogicManager sharedInstance]showAlertWithTitle:nil message:@"删除成功" actionText:@"确定"];
            }
        }
    }];
    
}

- (IBAction)collectionBtnAction:(id)sender
{
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x08];
    
    uint64_t userId = [UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    [pack collectFeedWithUserId:userId userKey:userKey feedId:_feedId];
    
    [[NetWorkEngine shareInstance] sendData:pack UniqueCode:CollectFeedCode block:^(int event, id object) {
        
    }];
}

- (IBAction)againstBtnAction:(id)sender
{
    if (self.makeReportReasonViewShowBlock)
    {
        self.makeReportReasonViewShowBlock();
    }
    //网络消息收到通知后执行
}

- (IBAction)removeBtnAction:(id)sender
{
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x0c];
    
    [pack deleteFeedInMainViewWithUserId:[UserInfo myselfInstance].userId userKey:[UserInfo myselfInstance].userKey feedId:_feedId];
    [[NetWorkEngine shareInstance] sendData:pack UniqueCode:DeleteFeedInMainViewCode block:^(int event, id object) {
        
    }];
    
    if (self.handleMainCellOtherRemoveBlock)
    {
        self.handleMainCellOtherRemoveBlock();
    }
}

-(void)handleReasonReturnValue:(NSNotification *)note
{
    NSString *str = [note object];
    
    Package *pack = [[Package alloc] initWithSubSystem:UserMessageSubsys withSubProcotol:0x09];
    
    uint64_t userId =[UserInfo myselfInstance].userId;
    NSString *userKey = [UserInfo myselfInstance].userKey;
    [pack reportFeedWithUserId:userId userKey:userKey feedId:_feedId uniqueCode:0 reportReason:str];
    
    [[NetWorkEngine shareInstance] sendData:pack UniqueCode:ReportFeedCode block:^(int event, id object) {
        
    }];
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
