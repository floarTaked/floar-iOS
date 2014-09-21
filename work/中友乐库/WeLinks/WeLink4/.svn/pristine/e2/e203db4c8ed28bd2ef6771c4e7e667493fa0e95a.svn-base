//
//  VcardGenerator.m
//  VcardLibrary
//
//  Created by Edward Chen on 11/10/13.
//  Copyright (c) 2013 Edward Chen. All rights reserved.
//

#import "VcardGenerator.h"
#import "Vcard2_1Generator.h"
#import "Vcard3_0Generator.h"
#import "Vcard2_1QRCodeGenerator.h"

NSString * const vN = @"N"; // name
NSString * const vFN = @"FN"; // formatted name
NSString * const vPHOTO = @"PHOTO"; // photograph
NSString * const vADR = @"ADR"; // delivery address
NSString * const vTEL = @"TEL"; // telephone
NSString * const vEMAIL = @"EMAIL"; // email
NSString * const vNICKNAME = @"NICKNAME";
NSString * const vTITLE = @"TITLE"; // title
NSString * const vORG = @"ORG"; // organization name or organization unit
NSString * const vNOTE = @"NOTE"; // Note
NSString * const vURL = @"URL"; // URL internet location
NSString * const vBDAY = @"BDAY"; // birthday
NSString * const vPREF = @"PREF"; // preferred item

@implementation VcardGenerator

+ (id<VcardGeneratorProtocol>) vcardGeneratorForVersion:(VcardVersion) vcardVersion
{
    switch (vcardVersion)
    {
        case VcardVersion2_1:
        {
            return [[Vcard2_1Generator alloc] init];
        }
            break;
        case VcardVersion3_0:
        {
            return [[Vcard3_0Generator alloc] init];
        }
            break;
        case VcardVersion2_1QRCode:
        {
            return [[Vcard2_1QRCodeGenerator alloc] init];
        }
        default:
        {
            return [[Vcard2_1Generator alloc] init];
        }
            break;
    }
}

@end
