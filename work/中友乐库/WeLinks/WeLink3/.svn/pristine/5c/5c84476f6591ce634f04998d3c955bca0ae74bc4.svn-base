//
//  CustomPickerView.h
//  Welinked2
//
//  Created by jonas on 12/9/13.
//
//

#import <UIKit/UIKit.h>
#import "Common.h"
#import <NSDate+Calendar.h>
#import "BasePickerView.h"
typedef enum
{
    JobSalary,
    Salary,
    JobLevel,
    Education,
    JobYear,
    Sex,
    Industry,
    City,
    Job
}PickerType;
@interface CustomPickerView : BasePickerView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray* jobArray;
    NSMutableArray* subJobArray;
    
    NSMutableArray* provinceArray;
    NSMutableArray* cityArray;
    
    NSMutableArray* industryArray;
    NSMutableArray* subIndustryArray;
    BOOL hideState;
}
@property(nonatomic,assign)PickerType pickerType;
-(void)showWithObject:(id)object block:(EventCallBack)block;
-(void)hide;
+(CustomPickerView*)sharedInstance;
@end
