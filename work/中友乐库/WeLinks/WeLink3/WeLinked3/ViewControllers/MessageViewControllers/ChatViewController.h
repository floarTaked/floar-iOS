//
//  ChatViewController.h
//  Welinked2
//
//  Created by jonas on 12/17/13.
//
//

#import "MessageView.h"
#import "NetworkEngine.h"


@interface ChatViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet MessageView *list;
    IBOutlet UIView *textInputView;
    IBOutlet UITextField *textField;
    IBOutlet UIImageView* inputBack;
    IBOutlet UIImageView* inputBackground;
    NSTimer* timer;
    int scrollToBottomState;//2 强制滑动 3强制不滑动
    

    NSTimeInterval topTime;
    NSTimeInterval buttomTime;
    
    
    IBOutlet UIView* maskView;
    IBOutlet UIView* actionView;
    IBOutlet EGOImageView* headImageView;
    IBOutlet RCLabel* descLabel;
    IBOutlet UIButton* actionButton;
}
@property(nonatomic,strong)NSString* otherName;
@property(nonatomic,strong)NSString* otherAvatar;
@property(nonatomic,strong)NSString* otherUserId;
@end
