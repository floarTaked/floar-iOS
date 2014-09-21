//
//  HeartBeatManager.m
//  Welinked2
//
//  Created by jonas on 12/13/13.
//
//

#import "HeartBeatManager.h"
#import "NetworkEngine.h"
@implementation HeartBeatManager
-(id)init
{
    self = [super init];
    if(self)
    {
        methods = [[NSMutableDictionary alloc]init];
        data = [[NSMutableDictionary alloc]init];
    }
    return self;
}
-(void)registerInvokeMethod:(NSString*)key callback:(EventCallBack)callback
{
    if(key == nil || callback == nil)
    {
        return;
    }
    NSMutableArray* calls = [methods objectForKey:key];
    if(calls == nil)
    {
        calls = [NSMutableArray array];
        [methods setObject:calls forKey:key];
    }
    if(![calls containsObject:callback])
    {
        [calls addObject:callback];
    }
    
    for (EventCallBack call in calls)
    {
        id object = [data objectForKey:key];
        if(call != nil)
        {
            call(1,object);
        }
        else
        {
            [self fireEvent:1 object:key];
        }
    }
}
-(void)setDataWithKey:(NSString*)key value:(id)value
{
    if(value == nil || key == nil)
    {
        return;
    }
    [data setObject:value forKey:key];
}
-(void)fireData:(id)sender
{
    for(NSString* key in data)
    {
        NSMutableArray* calls = [methods objectForKey:key];
        for (EventCallBack call in calls)
        {
            id object = [data objectForKey:key];
            if(call != nil)
            {
                call(1,object);
            }
            else
            {
                [self fireEvent:1 object:key];
            }
        }
    }
}
-(void)queryNetwork
{
    [[NetworkEngine sharedInstance] updateData:^(int event, id object)
     {
         beatFinished = YES;
         if(event == 0)
         {
             
         }
         else if (event == 1)
         {
             //newfriend:新的联系人 friends:联系人列表 msg:消息 feeds:职脉圈
             NSDictionary* dic = (NSDictionary*)object;
             for(NSString* key in dic)
             {
                 id object = [dic objectForKey:key];
                 if(object != nil)
                 {
                     [data setObject:object forKey:key];
                 }
             }
         }
     }];
}
-(void)fireNetwork:(id)sender
{
    if(!beatFinished)
    {
        return;
    }
    else
    {
        beatFinished = NO;
    }
    [self queryNetwork];
}
-(void)fireEvent:(int)event object:(id)object
{
    if(object == nil)
    {
        return;
    }
    if([object isEqualToString:@"friends"])
    {
        NSNumber* number = [data objectForKey:@"friends"];
        if(number != nil && [number intValue] > 0)
        {
            [[NetworkEngine sharedInstance] getMyFriends:^(int event, id object)
            {
                if(event == 1)
                {
                    [self setDataWithKey:@"friends" value:[NSNumber numberWithInt:0]];
                }
            }];
        }
    }
}
-(void)start
{
    if(networkTimer == nil || ![networkTimer isValid])
    {
        networkTimer = [NSTimer timerWithTimeInterval:15 target:self
                                             selector:@selector(fireNetwork:)
                                             userInfo:nil
                                              repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:networkTimer forMode:NSDefaultRunLoopMode];
        beatFinished = YES;
        [networkTimer fire];
    }
    
    
    if(dataTimer == nil || ![dataTimer isValid])
    {
        dataTimer = [NSTimer timerWithTimeInterval:2
                                            target:self
                                          selector:@selector(fireData:)
                                          userInfo:nil
                                           repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:dataTimer forMode:NSDefaultRunLoopMode];
        [dataTimer fire];
    }
}
-(void)end
{
    if(networkTimer != nil && [networkTimer isValid])
    {
        [networkTimer invalidate];
        networkTimer = nil;
    }
    if(dataTimer != nil && [dataTimer isValid])
    {
        [dataTimer invalidate];
        dataTimer = nil;
    }
}
+(HeartBeatManager*)sharedInstane
{
    static HeartBeatManager* m_instace = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_instace = [[HeartBeatManager alloc]init];
    });
    return m_instace;
}
@end
