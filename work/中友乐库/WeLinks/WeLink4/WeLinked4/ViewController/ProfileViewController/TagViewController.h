//
//  TagViewController.h
//  WeLinked3
//
//  Created by jonas on 4/8/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface StateButton:UIButton
{
    UIImageView* selectedStateView;
    EventCallBack callBack;
}
@property(nonatomic,strong)NSString* data;
@property(nonatomic,assign)BOOL selectedState;
@end

@interface TagViewController : UIViewController<UIAlertViewDelegate,UITextFieldDelegate>
{
    UIView* listView;
    NSMutableArray* dataSource;
    NSMutableArray* updateSource;
}
@property(nonatomic,assign)int tagType;//1职业标签"jobTags" : null, (职业标签)    2业务标签 "tags" : null, (业务标签)
@end
