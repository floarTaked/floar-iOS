//
//  VcardGeneratorBase.h
//  VcardLibrary
//
//  Created by Edward Chen on 11/10/13.
//  Copyright (c) 2013 Edward Chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VcardGeneratorProtocol.h"

@interface VcardGeneratorBase : NSObject<VcardGeneratorProtocol>
{
@protected
    NSMutableString *vcardRepresentation_;
    NSCharacterSet *needTransformedCharacterSet_;
    
    NSMutableString *typesString_;
    NSString *valueString_;
    NSString *encoding_;
    NSString *characterSet_;
    
    NSArray *knownLabelArray_;
}

@property (nonatomic, retain) NSMutableString *typesString;
@property (nonatomic, copy) NSString *valueString;
@property (nonatomic, copy) NSString *encoding;
@property (nonatomic, copy) NSString *characterSet;

- (BOOL) isStringNeedQTEncoding:(NSString *) string;
- (NSString *) transformedString:(NSString *) string;
- (NSString *) transformedString:(NSString *) string forCharacters:(NSCharacterSet *) needTransformedCharacterSet;

@end
