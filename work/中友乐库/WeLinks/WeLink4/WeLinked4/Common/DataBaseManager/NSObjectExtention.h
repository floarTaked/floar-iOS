//
//  NSObjectExtention.h
//  UnNamed
//
//  Created by jonas on 8/2/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "FMResultSet.h"
#import "DataBaseManager.h"
typedef enum
{
    PublicDataBase,
    UserDataBase
}DatabaseType;
@interface NSObjectExtention : NSObject
{
}
+(DatabaseType)databaseType;
//key INTEGER PRIMARY KEY,
+(NSString*)primaryKey;
//+(NSString*)protocolName;
+(NSMutableDictionary*)getClassPropertyDictionary;
-(NSDictionary*)serialization;
-(void)deserialization:(NSDictionary*)data;

//for database

+(NSString*)queryWithSelect:(NSString*)select condition:(NSString*)condition tableName:(NSString*)tableName;

//for object
+(id)asynchronize:(FMResultSet*)resultSet;
-(BOOL)synchronize:(NSString*)tableName;
+(BOOL)deleteWith:(NSString*)tableName condition:(NSString*)condition;
+(BOOL)executeWithSet:(NSString*)execute condition:(NSString*)condition tableName:(NSString*)tableName;
@end