//
//  DatePikerView.m
//  Welinked2
//
//  Created by jonas on 12/23/13.
//
//

#import "DatePikerView.h"
#import "LogicManager.h"
@implementation DatePikerView
@synthesize dateComponent,baseYear;
-(id)init
{
    self = [super init];
    if(self)
    {
        basePickerView.delegate = self;
        yearSource = [[NSMutableArray alloc]init];
        monthSource = [[NSMutableArray alloc]init];
        daySource = [[NSMutableArray alloc]init];
        for(int i = 1;i<13;i++)
        {
            [monthSource addObject:[NSNumber numberWithInt:i]];
        }
        self.baseYear = 1970;
        self.dateComponent = YearMonthDay;
    }
    return self;
}
-(void)setDateComponent:(PikerDateComponent)datecom
{
    dateComponent = datecom;
    [basePickerView reloadAllComponents];
}
-(void)setBaseYear:(int)year
{
    [yearSource removeAllObjects];
    baseYear = year;
    for(int i = baseYear;i <= [[NSDate date] year];i++)
    {
        [yearSource addObject:[NSNumber numberWithInt:i]];
    }
    [basePickerView reloadComponent:0];
}

-(void)showWithObject:(id)object block:(EventCallBack)block
{
    callback = block;
    CGRect bounds = [UIScreen mainScreen].bounds;
    [UIView animateWithDuration:0.2 animations:^{
        self.center = CGPointMake(self.frame.size.width/2,bounds.size.height-self.frame.size.height/2);
    }completion:^(BOOL finished){
        if(self.dateComponent == YearYear)
        {
            int beginYear = [[(NSDictionary*)object objectForKey:@"begin"] intValue];
            int endYear = [[(NSDictionary*)object objectForKey:@"end"] intValue];
            [basePickerView selectRow:beginYear-self.baseYear<0?0:beginYear-self.baseYear inComponent:0 animated:YES];
            [basePickerView selectRow:endYear-self.baseYear<0?0:endYear-self.baseYear inComponent:1 animated:YES];
        }
        else
        {
            NSDate* date = nil;
            if(object == nil)
            {
                date = [NSDate dateWithYear:self.baseYear month:1 day:1];
            }
            else
            {
                date = [NSDate dateWithTimeIntervalSince1970:[object doubleValue]/1000];
            }
            [basePickerView selectRow:[date year]-self.baseYear<0?0:[date year]-self.baseYear inComponent:0 animated:YES];
            [basePickerView selectRow:[date month]-1 inComponent:1 animated:YES];
            if(self.dateComponent == YearMonthDay)
            {
                int y = [basePickerView selectedRowInComponent:0];
                int m = [basePickerView selectedRowInComponent:1];
                int days = [NSDate dayCountIn:y month:m];
                [daySource removeAllObjects];
                for(int i = 1;i<days+1;i++)
                {
                    [daySource addObject:[NSNumber numberWithInt:i]];
                }
                [basePickerView reloadComponent:2];
                [basePickerView selectRow:[date day]-1 inComponent:2 animated:YES];
            }
        }
     }];
}
-(void)hide
{
    CGRect bounds = [UIScreen mainScreen].bounds;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, bounds.size.height,self.frame.size.width,self.frame.size.height);
    } completion:^(BOOL finished) {
    }];
}
-(BOOL)checkTime:(NSTimeInterval)begin end:(NSTimeInterval)end
{
    if((begin <= end) || ((begin > end) && (begin == 0 || end == 1)))
    {
        return YES;
    }
    
    return NO;
}
-(void)confirmPicker
{
    if(self.dateComponent == YearYear)
    {
        int begin = [basePickerView selectedRowInComponent:0];
        int end = [basePickerView selectedRowInComponent:1];
        
        if(begin > end)
        {
            [[LogicManager sharedInstance] showAlertWithTitle:nil message:@"起始时间必须小于结束时间" actionText:@"确定"];
            return;
        }
    }
    CGRect bounds = [UIScreen mainScreen].bounds;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, bounds.size.height,self.frame.size.width,self.frame.size.height);
    } completion:^(BOOL finished) {
        if(self.dateComponent == YearYear)
        {
            int begin = [basePickerView selectedRowInComponent:0];
            int end = [basePickerView selectedRowInComponent:1];
            NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:
                                 [NSNumber numberWithInt:begin+self.baseYear],@"begin",
                                 [NSNumber numberWithInt:end+self.baseYear],@"end",nil];
            if(callback)
            {
                callback(0,dic);
            }
        }
        else
        {
            int y = [basePickerView selectedRowInComponent:0];
            int m = [basePickerView selectedRowInComponent:1];
            int d = 0;
            if(self.dateComponent == YearMonthDay)
            {
                d = [basePickerView selectedRowInComponent:2];
            }
            NSDate* date = [NSDate dateWithYear:y+self.baseYear month:m+1 day:d+1];
            if(callback)
            {
                callback(0,[NSNumber numberWithDouble:[date timeIntervalSince1970]*1000]);
            }
        }
    }];
}
#pragma --mark UIPickerViewDelegate UIPickerViewDataSource
-(void)pickerView:(UIPickerView *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(self.dateComponent == YearMonthDay)
    {
        int y = [picker selectedRowInComponent:0]+self.baseYear+1;
        int m = [picker selectedRowInComponent:1]+1;
        int days = [NSDate dayCountIn:y month:m];
        [daySource removeAllObjects];
        for(int i = 1;i<days+1;i++)
        {
            [daySource addObject:[NSNumber numberWithInt:i]];
        }
        [picker reloadComponent:2];
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)picker
{
    if(self.dateComponent == YearYear)
    {
        return 2;
    }
    else if(self.dateComponent == YearMonth)
    {
        return 2;
    }
    else if(self.dateComponent == YearMonthDay)
    {
        return 3;
    }
    return 0;
}
-(NSInteger) pickerView:(UIPickerView *)picker numberOfRowsInComponent:(NSInteger)component
{
    if(self.dateComponent == YearYear)
    {
        return [yearSource count];
    }
    else
    {
        if(component == 0)
        {
            if(yearSource != nil)
            {
                return [yearSource count];
            }
            else
            {
                return 0;
            }
        }
        else if(component == 1)
        {
            if(monthSource != nil)
            {
                return [monthSource count];
            }
            else
            {
                return 0;
            }
        }
        else if(component == 2)
        {
            if(daySource != nil)
            {
                return [daySource count];
            }
            else
            {
                return 0;
            }
        }
    }
    return 0;
}
- (UIView *)pickerView:(UIPickerView *)picker
            viewForRow:(NSInteger)row
          forComponent:(NSInteger)component
           reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel)
    {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:getFontWith(YES, 18)];
    }
    if(self.dateComponent == YearYear)
    {
        pickerLabel.text = [NSString stringWithFormat:@"%d年",[[yearSource objectAtIndex:row] intValue]];
    }
    else
    {
        if(component == 0)
        {
            pickerLabel.text = [NSString stringWithFormat:@"%d年",[[yearSource objectAtIndex:row] intValue]];
        }
        else if(component == 1)
        {
            pickerLabel.text = [NSString stringWithFormat:@"%d月",[[monthSource objectAtIndex:row] intValue]];
        }
        else if (component==2)
        {
            pickerLabel.text = [NSString stringWithFormat:@"%d日",[[daySource objectAtIndex:row] intValue]];
        }
    }
    return pickerLabel;
}
#pragma --mark
+(DatePikerView*)sharedInstance
{
    static DatePikerView* m_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_instance = [[[self class] alloc]init];
    });
    return m_instance;
}

@end
