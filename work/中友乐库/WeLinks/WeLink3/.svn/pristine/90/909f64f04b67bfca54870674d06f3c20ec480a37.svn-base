//
//  ArticleBrowserViewController.h
//  Welinked2
//
//  Created by 牟 文斌 on 12/6/13.
//
//

#import <UIKit/UIKit.h>
#import <EGOImageView.h>

@protocol synchornLikeNumber <NSObject>

-(void)synchornUIWihtLikeNumber:(NSString *)likeNumber;

@end

typedef enum {
    ArticleBrowserTypeWithTitle = 0,
    ArticleBrowserTypeWithNoTitle,
    ArticleBrowserTypeImageView
}ArticleBrowserType;

@class Article;
@interface ArticleBrowserViewController : UIViewController<EGOImageLoaderObserver>
@property (nonatomic, weak) id<synchornLikeNumber>synchornLikeNumdelegate;
@property (nonatomic, strong) Article *article;
@property (nonatomic, assign) ArticleBrowserType articleBrowserType;
@property (nonatomic, strong) UIColor *articleColor;
@end
