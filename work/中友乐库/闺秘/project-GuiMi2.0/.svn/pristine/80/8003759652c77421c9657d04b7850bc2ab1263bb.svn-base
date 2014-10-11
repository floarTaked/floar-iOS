//
//  EGOImageView(Extension).m
//  Welinked2
//
//  Created by jonas on 12/23/13.
//
//

#import "EGOImageView(Extension).h"
#import "LogicManager.h"
@implementation EGOImageView(Extension)
- (void)setImageURL:(NSURL *)aURL
{
    int num = [[LogicManager sharedInstance]getPersistenceIntegerWithKey:WITHOUTIMAGE];
    BOOL enable = num ==0 ?NO:YES;
    if(enable)
    {
        self.image = self.placeholderImage;
        self.backgroundColor = [UIColor lightGrayColor];
        return;
    }
	if(!aURL)
    {
		self.image = self.placeholderImage;
		imageURL = nil;
		return;
	}
    else
    {
		imageURL = [aURL retain];
	}
    
    UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    activity.center = self.center;
    activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    activity.hidesWhenStopped = YES;
    [activity startAnimating];
    [self addSubview:activity];
    
    NSMutableString* path = [NSMutableString stringWithString:[imageURL absoluteString]];
    NSString* ext = [path substringFromIndex:[path length]-3];
    if([ext isEqualToString:@"gif"])
    {
        [path appendString:@".tn.png"];
        imageURL = [NSURL URLWithString:path];
    }
    
    for (UIView *view in self.superview.subviews)
    {
        if ([view isKindOfClass:[UILabel class]])
        {
            view.alpha = 0;
        }
    }
    
    [[EGOImageLoader sharedImageLoader] loadImageForURL:imageURL completion:^(UIImage *image, NSURL *imageURL, NSError *error)
    {
        [activity stopAnimating];
        for (UIView *view in self.superview.subviews)
        {
            if ([view isKindOfClass:[UILabel class]])
            {
                view.alpha = 1;
            }
        }
        if(image)
        {
            self.image = image;
            // trigger the delegate callback if the image was found in the cache
            if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)])
            {
                [self.delegate imageViewLoadedImage:self];
            }
        }
        else
        {
            self.image = self.placeholderImage;
            self.image = [UIImage imageNamed:@"img_secretCell_background_8"];
        }
    }];
}
@end
