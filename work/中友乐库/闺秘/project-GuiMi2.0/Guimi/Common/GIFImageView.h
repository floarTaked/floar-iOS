//
//  SCGIFImageView.h
//  TestGIF
//
//  Created by shichangone on 11-7-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnimatedGifFrame : NSObject
{
	NSData *data;
	NSData *header;
	double delay;
	int disposalMethod;
	CGRect area;
}
@property (nonatomic, copy) NSData *header;
@property (nonatomic, copy) NSData *data;
@property (nonatomic) double delay;
@property (nonatomic) int disposalMethod;
@property (nonatomic) CGRect area;
@end

@interface GIFImageView : UIImageView
{
	NSData *pointer;
	NSMutableData *buffer;
	NSMutableData *screen;
	NSMutableData *global;
	NSMutableArray *frames;
	
	int sorted;
	int colorS;
	int colorC;
	int colorF;
	int animatedGifDelay;
	int dataPointer;
}
@property(nonatomic,strong)NSString* filePath;
@property (nonatomic, strong) NSMutableArray *frames;
- (id)initWithFile:(NSString*)path;
- (id)initWithData:(NSData*)imageData;

-(void)play;
-(void)stop;

+ (NSMutableArray*)getGifFrames:(NSData*)gifImageData;
+ (BOOL)isGifImage:(NSData*)imageData;
@end
