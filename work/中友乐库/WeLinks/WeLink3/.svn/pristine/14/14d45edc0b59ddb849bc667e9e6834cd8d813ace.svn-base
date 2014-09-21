//
//  DatePikerView.h
//  Welinked2
//
//  Created by jonas on 12/23/13.
//
//

#import <UIKit/UIKit.h>
#import <NSDate+Calendar.h>
#import "Common.h"
#import "BasePickerView.h"
typedef enum
{
    YearYear,
    YearMonth,
    YearMonthDay,
}PikerDateComponent;
@interface DatePikerView : BasePickerView<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray* yearSource;
    NSMutableArray* monthSource;
    NSMutableArray* daySource;
}
@property(nonatomic,assign)PikerDateComponent dateComponent;
@property(nonatomic,assign)int baseYear;
-(void)showWithObject:(id)object block:(EventCallBack)block;
-(void)hide;
+(DatePikerView*)sharedInstance;
@end
