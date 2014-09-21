//
//  SCGIFImageView.m
//  TestGIF
//
//  Created by shichangone on 11-7-12.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "GIFImageView.h"

@implementation AnimatedGifFrame
@synthesize data, delay, disposalMethod, area, header;
@end




@interface GIFImageView ()
- (void) decodeGIF:(NSData *)GIFData;
- (void) readExtensions;
- (void) readDescriptor;
- (bool) getBytes:(int)length;
- (bool) skipBytes: (int) length;
- (NSData*) getFrameAsDataAtIndex:(int)index;
- (UIImage*) getFrameAsImageAtIndex:(int)index;
- (void)loadImageData;
@end


@implementation GIFImageView
@synthesize frames,filePath;

+ (BOOL)isGifImage:(NSData*)imageData
{
	const char* buf = (const char*)[imageData bytes];
	if (buf[0] == 0x47 && buf[1] == 0x49 && buf[2] == 0x46 && buf[3] == 0x38)
    {
		return YES;
	}
	return NO;
}

+ (NSMutableArray*)getGifFrames:(NSData*)gifImageData
{
	GIFImageView* gifImageView = [[GIFImageView alloc] initWithData:gifImageData];
	if (!gifImageView)
    {
		return nil;
	}
	NSMutableArray* gifFrames = gifImageView.frames;
	return gifFrames;
}
-(void)play
{
    [self startAnimating];
}
-(void)stop
{
    [self stopAnimating];
}
- (id)initWithFile:(NSString*)path
{
    filePath = path;
	NSData* imageData = [NSData dataWithContentsOfFile:filePath];
	return [self initWithData:imageData];
}

- (id)initWithData:(NSData*)imageData
{
	if (imageData.length < 4)
    {
		return nil;
	}
	
	if (![GIFImageView isGifImage:imageData])
    {
		UIImage* image = [UIImage imageWithData:imageData];
		return [super initWithImage:image];
	}
	
	[self decodeGIF:imageData];
	
	if (frames.count <= 0)
    {
		UIImage* image = [UIImage imageWithData:imageData];
		return [super initWithImage:image];
	}
	
	self = [super init];
	if (self)
    {
		[self loadImageData];
	}
	return self;
}

- (void)setGIF_frames:(NSMutableArray *)gifFrames
{
	frames = gifFrames;
	[self loadImageData];
}

- (void)loadImageData
{
	// Add all subframes to the animation
	NSMutableArray *array = [[NSMutableArray alloc] init];
	for (NSUInteger i = 0; i < [frames count]; i++)
	{		
		[array addObject: [self getFrameAsImageAtIndex:i]];
	}
	
	NSMutableArray *overlayArray = [[NSMutableArray alloc] init];
	UIImage *firstImage = [array objectAtIndex:0];
	CGSize size = firstImage.size;
	CGRect rect = CGRectZero;
	rect.size = size;
    self.frame = rect;
	
	UIGraphicsBeginImageContext(size);
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	
	int i = 0;
	AnimatedGifFrame *lastFrame = nil;
	for (UIImage *image in array)
	{
		// Get Frame
		AnimatedGifFrame *frame = [frames objectAtIndex:i];
		
		// Initialize Flag
		UIImage *previousCanvas = nil;
		
		// Save Context
		CGContextSaveGState(ctx);
		// Change CTM
		CGContextScaleCTM(ctx, 1.0, -1.0);
		CGContextTranslateCTM(ctx, 0.0, -size.height);
		
		// Check if lastFrame exists
		CGRect clipRect;
		
		// Disposal Method (Operations before draw frame)
		switch (frame.disposalMethod)
		{
			case 1: // Do not dispose (draw over context)
                    // Create Rect (y inverted) to clipping
				clipRect = CGRectMake(frame.area.origin.x, size.height - frame.area.size.height - frame.area.origin.y, frame.area.size.width, frame.area.size.height);
				// Clip Context
				CGContextClipToRect(ctx, clipRect);
				break;
			case 2: // Restore to background the rect when the actual frame will go to be drawed
                    // Create Rect (y inverted) to clipping
				clipRect = CGRectMake(frame.area.origin.x, size.height - frame.area.size.height - frame.area.origin.y, frame.area.size.width, frame.area.size.height);
				// Clip Context
				CGContextClipToRect(ctx, clipRect);
				break;
			case 3: // Restore to Previous
                    // Get Canvas
				previousCanvas = UIGraphicsGetImageFromCurrentImageContext();
				
				// Create Rect (y inverted) to clipping
				clipRect = CGRectMake(frame.area.origin.x, size.height - frame.area.size.height - frame.area.origin.y, frame.area.size.width, frame.area.size.height);
				// Clip Context
				CGContextClipToRect(ctx, clipRect);
				break;
		}
		
		// Draw Actual Frame
		CGContextDrawImage(ctx, rect, image.CGImage);
		// Restore State
		CGContextRestoreGState(ctx);
		
		//delay must larger than 0, the minimum delay in firefox is 10.
		if (frame.delay <= 0) {
			frame.delay = 10;
		}
		[overlayArray addObject:UIGraphicsGetImageFromCurrentImageContext()];
		
		// Set Last Frame
		lastFrame = frame;
		
		// Disposal Method (Operations afte draw frame)
		switch (frame.disposalMethod)
		{
			case 2: // Restore to background color the zone of the actual frame
                    // Save Context
				CGContextSaveGState(ctx);
				// Change CTM
				CGContextScaleCTM(ctx, 1.0, -1.0);
				CGContextTranslateCTM(ctx, 0.0, -size.height);
				// Clear Context
				CGContextClearRect(ctx, clipRect);
				// Restore Context
				CGContextRestoreGState(ctx);
				break;
			case 3: // Restore to Previous Canvas
                    // Save Context
				CGContextSaveGState(ctx);
				// Change CTM
				CGContextScaleCTM(ctx, 1.0, -1.0);
				CGContextTranslateCTM(ctx, 0.0, -size.height);
				// Clear Context
				CGContextClearRect(ctx, lastFrame.area);
				// Draw previous frame
				CGContextDrawImage(ctx, rect, previousCanvas.CGImage);
				// Restore State
				CGContextRestoreGState(ctx);
				break;
		}
		
		// Increment counter
		i++;
	}
	UIGraphicsEndImageContext();
	
	[self setImage:[overlayArray objectAtIndex:0]];
	[self setAnimationImages:overlayArray];
	
	// Count up the total delay, since Cocoa doesn't do per frame delays.
	double total = 0;
	for (AnimatedGifFrame *frame in frames)
    {
		total += frame.delay;
	}
	
	// GIFs store the delays as 1/100th of a second,
	// UIImageViews want it in seconds.
	[self setAnimationDuration:total/100];
	
	// Repeat infinite
	[self setAnimationRepeatCount:0];
	
	[self stop];
}
	 
- (void) decodeGIF:(NSData *)GIFData
{
	pointer = GIFData;
	
    buffer = [[NSMutableData alloc] init];
	global = [[NSMutableData alloc] init];
	screen = [[NSMutableData alloc] init];
	frames = [[NSMutableArray alloc] init];
	
    // Reset file counters to 0
	dataPointer = 0;
	
	[self skipBytes: 6]; // GIF89a, throw away
	[self getBytes: 7]; // Logical Screen Descriptor
	
    // Deep copy
	[screen setData: buffer];
	
    // Copy the read bytes into a local buffer on the stack
    // For easy byte access in the following lines.
    int length = [buffer length];
	unsigned char aBuffer[length];
	[buffer getBytes:aBuffer length:length];
	
	if (aBuffer[4] & 0x80) colorF = 1; else colorF = 0; 
	if (aBuffer[4] & 0x08) sorted = 1; else sorted = 0;
	colorC = (aBuffer[4] & 0x07);
	colorS = 2 << colorC;
	
	if (colorF == 1)
    {
		[self getBytes: (3 * colorS)];
        
        // Deep copy
		[global setData:buffer];
	}
	
	unsigned char bBuffer[1];
	while ([self getBytes:1] == YES)
    {
        [buffer getBytes:bBuffer length:1];
        
        if (bBuffer[0] == 0x3B)
        { // This is the end
            break;
        }
        
        switch (bBuffer[0])
        {
            case 0x21:
                // Graphic Control Extension (#n of n)
                [self readExtensions];
                break;
            case 0x2C:
                // Image Descriptor (#n of n)
                [self readDescriptor];
                break;
        }
	}
    buffer = nil;
    screen = nil;
    global = nil;
}

- (void) readExtensions
{
	// 21! But we still could have an Application Extension,
	// so we want to check for the full signature.
	unsigned char cur[1], prev[1];
    [self getBytes:1];
    [buffer getBytes:cur length:1];
    
	while (cur[0] != 0x00)
    {
		
		// TODO: Known bug, the sequence F9 04 could occur in the Application Extension, we
		//       should check whether this combo follows directly after the 21.
		if (cur[0] == 0x04 && prev[0] == 0xF9)
		{
			[self getBytes:5];
            
			AnimatedGifFrame *frame = [[AnimatedGifFrame alloc] init];
			
			unsigned char tbuffer[5];
			[buffer getBytes:tbuffer length:5];
			frame.disposalMethod = (tbuffer[0] & 0x1c) >> 2;
			//NSLog(@"flags=%x, dm=%x", (int)(buffer[0]), frame.disposalMethod);
			
			// We save the delays for easy access.
			frame.delay = (tbuffer[1] | tbuffer[2] << 8);
			
			unsigned char board[8];
			board[0] = 0x21;
			board[1] = 0xF9;
			board[2] = 0x04;
			
			for(int i = 3, a = 0; a < 5; i++, a++)
			{
				board[i] = tbuffer[a];
			}
			
			frame.header = [NSData dataWithBytes:board length:8];
            
			[frames addObject:frame];
			break;
		}
		
		prev[0] = cur[0];
        [self getBytes:1];
		[buffer getBytes:cur length:1];
	}	
}

- (void) readDescriptor
{
	[self getBytes:9];
    
    // Deep copy
	NSMutableData *screenTmp = [NSMutableData dataWithData:buffer];
	
	unsigned char aBuffer[9];
	[buffer getBytes:aBuffer length:9];
	
	CGRect rect;
	rect.origin.x = ((int)aBuffer[1] << 8) | aBuffer[0];
	rect.origin.y = ((int)aBuffer[3] << 8) | aBuffer[2];
	rect.size.width = ((int)aBuffer[5] << 8) | aBuffer[4];
	rect.size.height = ((int)aBuffer[7] << 8) | aBuffer[6];
    
	AnimatedGifFrame *frame = [frames lastObject];
	frame.area = rect;
	
	if (aBuffer[8] & 0x80) colorF = 1; else colorF = 0;
	
	unsigned char code = colorC, sort = sorted;
	
	if (colorF == 1)
    {
		code = (aBuffer[8] & 0x07);
        
		if (aBuffer[8] & 0x20)
        {
            sort = 1;
        }
        else
        {
        	sort = 0;
        }
	}
	
	int size = (2 << code);
	
	size_t blength = [screen length];
	unsigned char bBuffer[blength];
	[screen getBytes:bBuffer length:blength];
	
	bBuffer[4] = (bBuffer[4] & 0x70);
	bBuffer[4] = (bBuffer[4] | 0x80);
	bBuffer[4] = (bBuffer[4] | code);
	
	if (sort)
    {
		bBuffer[4] |= 0x08;
	}
	
    NSMutableData *string = [NSMutableData dataWithData:[@"GIF89a" dataUsingEncoding: NSUTF8StringEncoding]];
	[screen setData:[NSData dataWithBytes:bBuffer length:blength]];
    [string appendData: screen];
    
	if (colorF == 1)
    {
		[self getBytes:(3 * size)];
		[string appendData:buffer];
	}
    else
    {
		[string appendData:global];
	}
	
	// Add Graphic Control Extension Frame (for transparancy)
	[string appendData:frame.header];
	
	char endC = 0x2c;
	[string appendBytes:&endC length:sizeof(endC)];
	
	size_t clength = [screenTmp length];
	unsigned char cBuffer[clength];
	[screenTmp getBytes:cBuffer length:clength];
	
	cBuffer[8] &= 0x40;
	
	[screenTmp setData:[NSData dataWithBytes:cBuffer length:clength]];
	
	[string appendData: screenTmp];
	[self getBytes:1];
	[string appendData: buffer];
	
	while (true)
    {
		[self getBytes:1];
		[string appendData: buffer];
		
		unsigned char dBuffer[1];
		[buffer getBytes:dBuffer length:1];
		
		long u = (long) dBuffer[0];
        
		if (u != 0x00)
        {
			[self getBytes:u];
			[string appendData: buffer];
        }
        else
        {
            break;
        }
        
	}
	
	endC = 0x3b;
	[string appendBytes:&endC length:sizeof(endC)];
	
	// save the frame into the array of frames
	frame.data = string;
}

- (bool)getBytes:(int)length
{
    if (buffer != nil)
    {
        buffer = nil;
    }
    
	if ((NSInteger)[pointer length] >= dataPointer + length) // Don't read across the edge of the file..
    {
		buffer = (NSMutableData*)[pointer subdataWithRange:NSMakeRange(dataPointer, length)];
        dataPointer += length;
		return YES;
	}
    else
    {
        return NO;
	}
}

- (bool) skipBytes: (int) length
{
    if ((NSInteger)[pointer length] >= dataPointer + length)
    {
        dataPointer += length;
        return YES;
    }
    else
    {
    	return NO;
    }
}

- (NSData*) getFrameAsDataAtIndex:(int)index
{
	if (index < (NSInteger)[frames count])
	{
		return ((AnimatedGifFrame *)[frames objectAtIndex:index]).data;
	}
	else
	{
		return nil;
	}
}

- (UIImage*) getFrameAsImageAtIndex:(int)index
{
    NSData *frameData = [self getFrameAsDataAtIndex: index];
    UIImage *image = nil;
    
    if (frameData != nil)
    {
		image = [UIImage imageWithData:frameData];
    }
    return image;
}
@end
