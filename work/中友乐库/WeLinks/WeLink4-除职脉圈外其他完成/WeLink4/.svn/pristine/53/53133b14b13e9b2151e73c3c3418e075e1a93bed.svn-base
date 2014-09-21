//
//  CellView.m
//  WeLinked4
//
//  Created by floar on 14-5-28.
//  Copyright (c) 2014年 jonas. All rights reserved.
//

#import "CellView.h"
#import "HeadView.h"
#import "QuestionView.h"
#import "VoteView.h"
#import "ChatView.h"

@interface CellView ()
{
    HeadView *headerView;
    QuestionView *questionView;
    VoteView *voteView;
    ChatView *chatView;
    
    NSMutableArray *comArray;
    
}


@end

@implementation CellView
@synthesize CustomCellViewHeight;


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initCell];
    }
    return self;
}
-(void)test:(id)sender
{
    
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        [self initCell];
        self.userInteractionEnabled = YES;
    }
    return self;
}

-(void)initCell
{
    self.userInteractionEnabled = YES;
    comArray = [NSMutableArray arrayWithObjects:@"sdjflas",@"sdfjsdflsdjfl",@"sdlfjlsd", nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(makeChatViewShow) name:@"change" object:nil];
    
    headerView = [[HeadView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    headerView.feed = nil;
    [self addSubview:headerView];
    
    questionView = [[QuestionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headerView.frame), 320, 40)];
    questionView.contentString = @"你认为日常生活中应该使用财经记账类的APPslkdfjlsdfjlsdjflfdsfsdjflsjdflsjdflsdf;lsdlfjls";
    questionView.tagString = @"sdjflsdjf";
    [self addSubview:questionView];
    
    voteView = [[VoteView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(questionView.frame), 320, 40)];
    voteView.voteCount = 3;

    [self addSubview:voteView];
    
    chatView =[[ChatView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(voteView.frame)+10, 320, 40)];
    chatView.commentArray = comArray;
    chatView.hidden = YES;
    
    self.frame = CGRectMake(0, 0, 320, CGRectGetMaxY(voteView.frame));
    
    
    [self addSubview:chatView];
}

-(double)CustomCellViewHeight
{
    if (chatView.hidden == YES)
    {
        return CGRectGetMaxY(voteView.frame)-5;
    }
    else if (chatView.hidden == NO)
    {
        return CGRectGetMaxY(chatView.frame)-5;
    }
    else
    {
        NSLog(@"返回高度为0了!!!");
        return 0;
    }
}

#pragma mark - FriendDelegate
-(void)makeChatViewShow
{
    chatView.hidden = NO;
    self.frame = CGRectMake(0, 0, 320, CGRectGetMaxY(chatView.frame));
    [self.friendDelegate reloadTableView];
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
