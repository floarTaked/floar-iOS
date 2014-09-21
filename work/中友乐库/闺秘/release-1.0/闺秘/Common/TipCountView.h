//
//  TipView.h
//  Welinked2
//
//  Created by jonas on 12/13/13.
//
//

#import <UIKit/UIKit.h>

@interface TipCountView : UIView
{
    UIImageView* tipView;
    UILabel*     tipLabel;
}
-(void)setTipCount:(int)unreadCount;
@end
