//
//  NSDate+Month.m
//  NSDate+Calendar
//
//  Created by Alexey Belkevich on 9/4/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "NSDate+Month.h"
#import "NSDate+Components.h"

@implementation NSDate (Month)

- (NSInteger)month
{
    return [self dateComponentsDate].month;
}

- (NSDate *)dateMonthStart
{
    NSDateComponents *components = [self dateComponentsDate];
    components.day = 1;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)dateMonthEnd
{
    NSDateComponents *components = [self dateComponentsDate];
    components.month++;
    components.day = 0;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)dateMonthAgo
{
    return [self dateByAddingMonth:-1];
}

- (NSDate *)dateMonthAhead
{
    return [self dateByAddingMonth:1];
}

- (NSDate *)dateBySettingMonth:(NSInteger)month
{
    NSDateComponents *components = [self dateComponentsDateTime];
    components.month = month;
    return [[NSCalendar currentCalendar] dateFromComponents:components];
}

- (NSDate *)dateByAddingMonth:(NSInteger)month
{
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.month = month;
    return [[NSCalendar currentCalendar] dateByAddingComponents:components toDate:self options:0];
}
+ (int)dayCountIn:(int)year month:(int)imonth
{
    if((imonth == 1)||(imonth == 3)||(imonth == 5)||(imonth == 7)||(imonth == 8)||(imonth == 10)||(imonth == 12))
    {
        return 31;
    }
    if((imonth == 4)||(imonth == 6)||(imonth == 9)||(imonth == 11))
    {
        return 30;
    }
    if((year%4 == 1)||(year%4 == 2)||(year%4 == 3))
    {
        return 28;
    }
    if(year%400 == 0)
    {
        return 29;
    }
    if(year%100 == 0)
    {
        return 28;
    }
    return 29;
}
@end
