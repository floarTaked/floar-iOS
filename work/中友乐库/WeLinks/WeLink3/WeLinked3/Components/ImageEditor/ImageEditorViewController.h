#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
@protocol ImageEditorFrame
@required
@property(nonatomic,assign) CGRect cropRect;
@end
@class  ImageEditorViewController;
@interface ImageEditorViewController : UIViewController<UIGestureRecognizerDelegate>
{
    MBProgressHUD* HUD;
}
@property(nonatomic,copy) EventCallBack doneCallback;
@property(nonatomic,copy) UIImage *sourceImage;
@property(nonatomic,copy) UIImage *previewImage;
@property(nonatomic,assign) CGSize cropSize;
@property(nonatomic,assign) CGFloat outputWidth;
@property(nonatomic,assign) CGFloat minimumScale;
@property(nonatomic,assign) CGFloat maximumScale;

@property(nonatomic,assign) BOOL panEnabled;
@property(nonatomic,assign) BOOL rotateEnabled;
@property(nonatomic,assign) BOOL scaleEnabled;
@property(nonatomic,assign) BOOL tapToResetEnabled;

- (void)reset:(BOOL)animated;

@end


