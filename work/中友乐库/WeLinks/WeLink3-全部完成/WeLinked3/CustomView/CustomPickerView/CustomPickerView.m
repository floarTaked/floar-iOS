//
//  CustomPickerView.m
//  Welinked2
//
//  Created by jonas on 12/9/13.
//
//

#import "CustomPickerView.h"
#import "DataBaseManager.h"
#import "LogicManager.h"
#import "PublicObject.h"
@implementation CustomPickerView
@synthesize pickerType;
-(id)init
{
    self = [super init];
    if(self)
    {
        basePickerView.delegate = self;
        jobArray = [[PublicDataBaseManager sharedInstance] queryWithClass:[JobObject class] tableName:@"Job" condition:@" where parentCode = '00' "];
        
        provinceArray = [[PublicDataBaseManager sharedInstance] queryWithClass:[CityObject class] tableName:@"City" condition:@" where parentCode = '00000' "];
        
        industryArray = [[PublicDataBaseManager sharedInstance] queryWithClass:[IndustryObject class] tableName:@"Industry" condition:@" where parentCode = '00' "];
        hideState = YES;
    }
    return self;
}
-(void)showWithObject:(id)object block:(EventCallBack)block
{
    hideState = NO;
    callback = block;
    CGRect bounds = [UIScreen mainScreen].bounds;
    [UIView animateWithDuration:0.2 animations:^{
        self.center = CGPointMake(self.frame.size.width/2,bounds.size.height-self.frame.size.height/2);
    }completion:^(BOOL finished)
    {
        if(pickerType < Industry)
        {
            int selectedRow = 0;
            NSNumber* number = (NSNumber*)object;
            if(number != nil)
            {
                selectedRow = [number intValue];
                if(selectedRow < 0)
                {
                    selectedRow = 0;
                }
            }
            [basePickerView reloadAllComponents];
            [basePickerView selectRow:selectedRow inComponent:0 animated:NO];
        }
        else
        {
            if(pickerType == City)
            {
                NSString* code = (NSString*)object;
                if(code != nil && [code length]>=2)
                {
                    NSString* parentCode = [NSString stringWithFormat:@"%@000",[code substringWithRange:NSMakeRange(0, 2)]];
                    int index = 0;
                    for(CityObject* city in provinceArray)
                    {
                        if([city.code isEqualToString:parentCode])
                        {
                            index = [provinceArray indexOfObject:city];
                            break;
                        }
                    }
                    cityArray = [[PublicDataBaseManager sharedInstance] queryWithClass:[CityObject class]
                                                                             tableName:@"City"
                                                                             condition:[NSString stringWithFormat:@" where parentCode='%@'",parentCode]];
                    [basePickerView reloadAllComponents];
                    [basePickerView selectRow:index inComponent:0 animated:NO];
                }
                else
                {
                    CityObject* province = [provinceArray objectAtIndex:0];
                    cityArray = [[PublicDataBaseManager sharedInstance] queryWithClass:[CityObject class]
                                                                             tableName:@"City"
                                                                             condition:[NSString stringWithFormat:@" where parentCode='%@'",province.code]];
                    [basePickerView reloadAllComponents];
                    [basePickerView selectRow:0 inComponent:0 animated:NO];
                }
                
                if(cityArray != nil && [cityArray count]>0)
                {
                    int index = 0;
                    for(CityObject* city in cityArray)
                    {
                        if([city.code isEqualToString:code])
                        {
                            index = [cityArray indexOfObject:city];
                            break;
                        }
                    }
                    [basePickerView reloadAllComponents];
                    [basePickerView selectRow:index inComponent:1 animated:NO];
                }
            }
            else if (pickerType == Industry)
            {
                NSString* code = (NSString*)object;
                if(code != nil && [code length]>=2)
                {
                    NSString* parentCode = [code substringWithRange:NSMakeRange(0, 2)];
                    int index = 0;
                    for(IndustryObject* ind in industryArray)
                    {
                        if([ind.code isEqualToString:parentCode])
                        {
                            index = [industryArray indexOfObject:ind];
                            break;
                        }
                    }
                    subIndustryArray = [[PublicDataBaseManager sharedInstance] queryWithClass:[IndustryObject class]
                                                                                    tableName:@"Industry"
                                                                                    condition:[NSString stringWithFormat:@" where parentCode='%@'",parentCode]];
                    
                    
                    [basePickerView reloadAllComponents];
                    [basePickerView selectRow:index inComponent:0 animated:NO];
                }
                else
                {
                    IndustryObject* ind = [industryArray objectAtIndex:0];
                    subIndustryArray = [[PublicDataBaseManager sharedInstance] queryWithClass:[IndustryObject class]
                                                                                    tableName:@"Industry"
                                                                                    condition:[NSString stringWithFormat:@" where parentCode='%@'",ind.code]];
                    [basePickerView reloadAllComponents];
                    [basePickerView selectRow:0 inComponent:0 animated:NO];
                }
                if(subIndustryArray != nil && [subIndustryArray count]>0)
                {
                    int index = 0;
                    for(IndustryObject* ind in subIndustryArray)
                    {
                        if([ind.code isEqualToString:code])
                        {
                            index = [subIndustryArray indexOfObject:ind];
                            break;
                        }
                    }
                    [basePickerView reloadAllComponents];
                    [basePickerView selectRow:index inComponent:1 animated:NO];
                }
            }
            else if (pickerType == Job)
            {
                NSString* code = (NSString*)object;
                if(code != nil && [code length]>=2)
                {
                    NSString* parentCode = [code substringWithRange:NSMakeRange(0, 2)];
                    int index = 0;
                    for(JobObject* job in jobArray)
                    {
                        if([job.code isEqualToString:parentCode])
                        {
                            index = [jobArray indexOfObject:job];
                            break;
                        }
                    }
                    subJobArray = [[PublicDataBaseManager sharedInstance] queryWithClass:[JobObject class]
                                                                                    tableName:@"Job"
                                                                                    condition:[NSString stringWithFormat:@" where parentCode='%@'",parentCode]];
                    
                    
                    [basePickerView reloadAllComponents];
                    [basePickerView selectRow:index inComponent:0 animated:NO];
                }
                else
                {
                    JobObject* job = [jobArray objectAtIndex:0];
                    subJobArray = [[PublicDataBaseManager sharedInstance] queryWithClass:[JobObject class]
                                                                               tableName:@"Job"
                                                                               condition:[NSString stringWithFormat:@" where parentCode='%@'",job.code]];
                    
                    
                    [basePickerView reloadAllComponents];
                    [basePickerView selectRow:0 inComponent:0 animated:NO];
                }
                if(subJobArray != nil && [subJobArray count]>0)
                {
                    int index = 0;
                    for(JobObject* job in subJobArray)
                    {
                        if([job.code isEqualToString:code])
                        {
                            index = [subJobArray indexOfObject:job];
                            break;
                        }
                    }
                    [basePickerView reloadAllComponents];
                    [basePickerView selectRow:index inComponent:1 animated:NO];
                }
            }
        }
    }];
}
-(void)hide
{
    if(!hideState)
    {
        hideState = YES;
        CGRect bounds = [UIScreen mainScreen].bounds;
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = CGRectMake(0, bounds.size.height,self.frame.size.width,self.frame.size.height);
        } completion:^(BOOL finished) {
        }];
        if(callback)
        {
            callback(0,nil);
        }
    }
}
-(void)confirmPicker
{
    hideState = YES;
    CGRect bounds = [UIScreen mainScreen].bounds;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, bounds.size.height,self.frame.size.width,self.frame.size.height);
    } completion:^(BOOL finished) {
        if(pickerType < Industry)
        {
            int row = [basePickerView selectedRowInComponent:0];
            if(callback)
            {
                callback(1,[NSNumber numberWithInt:row]);
            }
        }
        else
        {
            if (pickerType == Industry)
            {
                int index = [basePickerView selectedRowInComponent:1];
                IndustryObject* ind = [subIndustryArray objectAtIndex:index];
                if(callback)
                {
                    callback(1,ind);
                }
            }
            else if (pickerType == City)
            {
                int index = [basePickerView selectedRowInComponent:1];
                CityObject* city = [cityArray objectAtIndex:index];
                if(callback)
                {
                    callback(1,city);
                }
            }
            else if (pickerType == Job)
            {
                int index = [basePickerView selectedRowInComponent:1];
                JobObject* job = [subJobArray objectAtIndex:index];
                if(callback)
                {
                    callback(1,job);
                }
            }
        }
    }];
}
-(void)pickerView:(UIPickerView *)picker didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerType == Industry)
    {
        if(component == 0)
        {
            IndustryObject* ind = [industryArray objectAtIndex:row];
            NSString* code = ind.code;
            subIndustryArray = [[PublicDataBaseManager sharedInstance] queryWithClass:[IndustryObject class]
                                                                            tableName:@"Industry"
                                                                            condition:[NSString stringWithFormat:@" where parentCode='%@'",code]];
            [picker reloadAllComponents];
        }
    }
    else if (pickerType == City)
    {
        if(component == 0)
        {
            CityObject* city = [provinceArray objectAtIndex:row];
            NSString* code = city.code;
            cityArray = [[PublicDataBaseManager sharedInstance] queryWithClass:[CityObject class]
                                                                            tableName:@"City"
                                                                            condition:[NSString stringWithFormat:@" where parentCode='%@'",code]];
            [picker reloadComponent:1];
        }
    }
    else if (pickerType == Job)
    {
        if(component == 0)
        {
            JobObject* job = [jobArray objectAtIndex:row];
            NSString* code = job.code;
            subJobArray = [[PublicDataBaseManager sharedInstance] queryWithClass:[JobObject class]
                                                                            tableName:@"Job"
                                                                            condition:[NSString stringWithFormat:@" where parentCode='%@'",code]];
            [picker reloadComponent:1];
        }
    }
}
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)picker
{
    if (pickerType == Industry || pickerType == City || pickerType == Job)
    {
        return 2;
    }
    return 1;
}
-(NSInteger) pickerView:(UIPickerView *)picker numberOfRowsInComponent:(NSInteger)component
{
    if(pickerType == JobSalary)
    {
        return 9;
    }
    else if(pickerType == Salary)
    {
        return 8;
    }
    else if (pickerType == JobLevel)
    {
        return 7;
    }
    else if (pickerType == Education)
    {
        return 4;
    }
    else if (pickerType == JobYear)
    {
        return 5;
    }
    else if (pickerType == Sex)
    {
        return 2;
    }
    else if (pickerType == Industry)
    {
        if(component == 0)
        {
            return [industryArray count];
        }
        else if (component == 1)
        {
            return [subIndustryArray count];
        }
    }
    else if (pickerType == City)
    {
        if(component == 0)
        {
            return [provinceArray count];
        }
        else if (component == 1)
        {
            return [cityArray count];
        }
    }
    else if (pickerType == Job)
    {
        if(component == 0)
        {
            return [jobArray count];
        }
        else if (component == 1)
        {
            return [subJobArray count];
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
    if (pickerLabel == nil)
    {
        pickerLabel = [[UILabel alloc] init];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        [pickerLabel setFont:getFontWith(YES, 14)];
    }
    if(pickerType == JobSalary)
    {
        pickerLabel.text = [[LogicManager sharedInstance] getSalary:row];
    }
    else if(pickerType == Salary)
    {
        pickerLabel.text = [[LogicManager sharedInstance] getSalary:row+1];
    }
    else if (pickerType == JobLevel)
    {
        pickerLabel.text = [[LogicManager sharedInstance] getJobLevel:row+1];
    }
    else if (pickerType == Education)
    {
        pickerLabel.text = [[LogicManager sharedInstance] getEducation:row+1];
    }
    else if (pickerType == JobYear)
    {
        pickerLabel.text = [[LogicManager sharedInstance] getJobYear:row+1];
    }
    else if (pickerType == Sex)
    {
        if(row == 0)
        {
            pickerLabel.text = @"男";
        }
        else
        {
            pickerLabel.text = @"女";
        }
    }
    else if (pickerType == Industry)
    {
        if(component == 0)
        {
            IndustryObject* ind = [industryArray objectAtIndex:row];
            pickerLabel.text = ind.name;
        }
        else if (component == 1)
        {
            IndustryObject* ind = [subIndustryArray objectAtIndex:row];
            pickerLabel.text = ind.name;
        }
    }
    else if (pickerType == City)
    {
        if(component == 0)
        {
            CityObject* city = [provinceArray objectAtIndex:row];
            pickerLabel.text = city.name;
        }
        else if (component == 1)
        {
            CityObject* city = [cityArray objectAtIndex:row];
            pickerLabel.text = city.name;
        }
    }
    else if (pickerType == Job)
    {
        if(component == 0)
        {
            JobObject* job = [jobArray objectAtIndex:row];
            pickerLabel.text = job.name;
        }
        else if (component == 1)
        {
            JobObject* job = [subJobArray objectAtIndex:row];
            pickerLabel.text = job.name;
        }
    }
    return pickerLabel;
}
+(CustomPickerView*)sharedInstance
{
    static CustomPickerView* m_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        m_instance = [[[self class] alloc]init];
    });
    return m_instance;
}
@end
