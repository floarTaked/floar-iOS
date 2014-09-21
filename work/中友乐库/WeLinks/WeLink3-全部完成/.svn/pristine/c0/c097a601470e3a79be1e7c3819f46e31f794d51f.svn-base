//
//  ListView.m
//  ListView
//
//  Created by jonas on 12/4/13.
//
//

#import "MessageView.h"
@implementation MessageView
@synthesize source;
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self)
    {
        [self initlize];
    }
    return self;
}
-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        [self initlize];
    }
    return self;
}
-(id)init
{
    self = [super init];
    if(self)
    {
        CGRect frame = [UIScreen mainScreen].bounds;
        self.frame = CGRectMake(0, 0, frame.size.width, frame.size.height);
        [self initlize];
    }
    return self;
}
-(void)initlize
{
    source = [[NSMutableArray alloc]init];
    self.dataSource = self;
    self.delegate = self;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    self.userInteractionEnabled = YES;
    self.separatorStyle = UITableViewCellSeparatorStyleNone;
    UIPanGestureRecognizer* touch = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(touch:)];
    touch.delegate = self;
    [self addGestureRecognizer:touch];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([otherGestureRecognizer.view isKindOfClass:[UITableView class]])
    {
        return YES;
    }
    return NO;
}
-(void)touch:(UIPanGestureRecognizer*)guesture
{
    if(call)
    {
        call(EVENT_TOUCH,self);
    }
}
-(void)reloadData
{
    for (int i = 0; i < [source count]; i++)
    {
        MessageData *object = [self.source objectAtIndex:i];
        if([object isKindOfClass:[SnapMessageData class]])
        {
            [self.source removeObject:object];
        }
    }
    [source sortUsingComparator:^NSComparisonResult(id obj1, id obj2)
     {
         MessageData* data1 = (MessageData*)obj1;
         MessageData* data2 = (MessageData*)obj2;
         NSNumber* number1 = [NSNumber numberWithDouble:data1.createTime];
         NSNumber* number2 = [NSNumber numberWithDouble:data2.createTime];
         return [number1 compare:number2];
     }];
    NSDate *last = [NSDate dateWithTimeIntervalSince1970:0];
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (MessageData* data in source)
    {
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:data.createTime/1000];
        if ([date timeIntervalSinceDate:last] > 120)
        {
            SnapMessageData* snap = [[SnapMessageData alloc]init];
            snap.createTime = data.createTime/1000;
            [arr addObject:snap];
            last = [NSDate dateWithTimeIntervalSince1970:data.createTime/1000];
        }
        [arr addObject:data];
    }
    source = arr;
    [super reloadData];
}
-(void)setCallBack:(EventCallBack)callBack
{
    call = callBack;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageData* data = [source objectAtIndex:indexPath.row];
    if(data == nil || [data getAdapter] == nil)
    {
        return 0;
    }
    return [[data getAdapter] getHeight];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(source == nil)
    {
        return 0;
    }
    else
    {
        return [source count];
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MessageData* data = [source objectAtIndex:indexPath.row];
    [data setCallBack:call];
    NSString* reuseIdentifier = [NSString stringWithFormat:@"CellType_%d_%d",data.msgType,data.isSender];
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    if(data != nil && [data getAdapter] != nil)
    {
        [[data getAdapter] fillCell:cell];
    }
    return cell;
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(call)
    {
        call(EVENT_SCROLL,self);
    }
    static float prevY = 1;
    float offsetY = self.contentOffset.y;
    
    if(prevY >=0 && offsetY < 0)
    {
        if(call)
        {
            call(EVENT_LOADMORE,self);
        }
    }
    prevY = offsetY;
}
@end
