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
//        self.backgroundColor = [UIColor redColor];
        return;
    }
    
    
	if(imageURL)
    {
		[[EGOImageLoader sharedImageLoader] removeObserver:self forURL:imageURL];
		[imageURL release];
		imageURL = nil;
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
	[[EGOImageLoader sharedImageLoader] removeObserver:self];
	UIImage* anImage = [[EGOImageLoader sharedImageLoader] imageForURL:aURL shouldLoadWithObserver:self];
	if(anImage)
    {
		self.image = anImage;
		// trigger the delegate callback if the image was found in the cache
		if([self.delegate respondsToSelector:@selector(imageViewLoadedImage:)])
        {
			[self.delegate imageViewLoadedImage:self];
		}
	}
    else
    {
		self.image = self.placeholderImage;
	}
}
@end
