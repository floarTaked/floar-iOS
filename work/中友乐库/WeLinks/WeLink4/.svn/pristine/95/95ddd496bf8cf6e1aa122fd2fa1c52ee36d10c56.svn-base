//
//  VcardParser.h
//  VcardLibrary
//
//  Created by Edward Chen on 11/10/13.
//  Copyright (c) 2013 Edward Chen. All rights reserved.
//

#import "VcardParserDelegate.h"

// VcardParser is a event driven vcard parser class.
// It will find each paired key:value and will notify 
// delegate in main thread with callbacks.
// To use it, alloc a VcardParser instance, set the vcard representaiton,
// maybe a file path or vcard string, and set the callback delegate.
// Finally, call start: method, if parser starts successfully, it will 
// return YES and no error. It will return NO and the error info if failed.
// Because parsing is processed in background thread, client can do run loop
// and waiting for parsing finish. u can set a flag in parserDidEndVCard: 
// callback to end the run loop.
// =============================================================================
// Example:
// VcardParser *parser = [[VcardParse alloc] init];
// [parser setVCardFilePath:@"..."];
// NSError *error = nil;
// if ([parser start:&error] == YES)
// {
//     ...
// }
// do
// {
//     [[NSRunLoop currentRunloop] runMode:NSDefaultRunloopMode untilDate:[NSDate distentFuture]];
// } while(parsingFinished == NO);
// [parser release];
typedef enum
{
    Parser,
    ParserDidStartVCard,
    ParserDidEndVCard,
    ParserDidGetVersion,
    ParserFoundLabel,
    ParserFoundValue
}ParseEvent;

@interface VcardParser : NSObject
{
@private
//    id<VcardParserDelegate> delegate_;
    id<VcardParserProtocol> parser_;
    NSString *vcardStringRepresentation_;
    BOOL isSyncronize_;
    EventCallBack callBack;
}

//@property (nonatomic, assign) id<VcardParserDelegate> delegate;

- (void) setVCardRepresentation:(NSString *) vcardRepresentation;
- (void) setVCardFilePath:(NSString *) vcardFilePath;

- (BOOL) isVcardValid:(NSError **) error;

- (id) valueForName:(NSString *) vcardKeyName error:(NSError **) error;
- (NSRange) valueRangeForName:(NSString *) vcardKeyName error:(NSError **) error;
- (BOOL) start:(EventCallBack)call;
- (BOOL) startSynchronously:(BOOL) synchronize block:(EventCallBack)call;
@end
