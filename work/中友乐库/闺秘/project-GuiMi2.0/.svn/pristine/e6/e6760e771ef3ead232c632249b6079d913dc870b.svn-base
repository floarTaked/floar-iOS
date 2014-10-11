//
//  DataBaseEngine.h
//  UnNamed
//
//  Created by jonas on 8/1/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>
#import "NSObjectExtention.h"
#import "FMDatabase.h"
#import "FMResultSet.h"
@interface DataBase : NSObject
{
    FMDatabase* database;
}
-(void)open;
-(void)close;
-(BOOL)registerTable:(NSString*)sql;
- (BOOL)executeUpdate:(NSString*)sql, ... ;
- (BOOL)executeUpdateWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (BOOL)executeUpdate:(NSString*)sql withArgumentsInArray:(NSArray *)arguments;

- (FMResultSet *)executeQuery:(NSString*)sql, ... ;
//- (FMResultSet *)executeQueryWithFormat:(NSString*)format, ... NS_FORMAT_FUNCTION(1,2);
-(NSMutableArray*)queryWithClass:(Class)cls tableName:(NSString*)tableName condition:(NSString*)condition;
-(NSMutableArray*)queryWithClass:(Class)cls tableName:(NSString*)tableName select:(NSString*)select condition:(NSString*)condition;
- (BOOL)tableExists:(NSString*)tableName;
- (BOOL)columnExists:(NSString*)tableName columnName:(NSString*)columnName;
@end

@interface PublicDataBaseManager : DataBase
+ (PublicDataBaseManager*)sharedInstance;
@end
@interface UserDataBaseManager : DataBase
+ (UserDataBaseManager*)sharedInstance;
@end