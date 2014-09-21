//
//  NSObjectExtention.m
//  UnNamed
//
//  Created by jonas on 8/2/13.
//  Copyright (c) 2013 jonas. All rights reserved.
//

#import "NSObjectExtention.h"
typedef enum
{
    INT,
    LONG,
    DOUBLE,
    FLOAT,
    CHAR,
    TEXT,
    DATE
} VariableType;

@interface NSObjectExtention(Private)
+(NSString*)createSql:(NSString*)tableName;
+(NSDictionary*)propertys;
+(BOOL)registTable:(NSString*)tableName;
+(NSString*)updateSql:(NSString*)tableName;
@end

@implementation NSObjectExtention
static const char * property_getType( objc_property_t property )
{
	const char * attrs = property_getAttributes( property );
	if ( attrs == NULL )
		return ( NULL );
	
	static char buffer[256];
	const char * e = strchr( attrs, ',' );
	if ( e == NULL )
		return ( NULL );
	
	int len = (int)(e - attrs);
	memcpy( buffer, attrs, len );
	buffer[len] = '\0';
	
	return (buffer);
}
-(id)init
{
    self = [super init];
    if(self)
    {
//        [[self class] registTable:nil];
    }
    return self;
}
+(DatabaseType)databaseType
{
    return UserDataBase;
}
-(NSDictionary*)serialization
{
    NSDictionary* dic = [[self class] propertys];
    NSMutableDictionary* serializationDic = nil;
    if(dic != nil)
    {
        serializationDic = [[NSMutableDictionary alloc]initWithCapacity:[dic.allKeys count]];
        for(NSString* name in dic.allKeys)
        {
            id obj = [self valueForKey:name];
            [serializationDic setObject:obj==nil?[NSNull null]:obj forKey:name];
        }
    }
    return serializationDic;
}
-(void)deserialization:(NSDictionary*)data
{
    if(data != nil)
    {
        for(NSString* name in data.allKeys)
        {
            id obj = [data objectForKey:name];
            [self setValue:obj forKey:name];
        }
    }
}
+(NSString*)primaryKey
{
    return nil;
}
//+(NSString*)protocolName
//{
//    return nil;
//}
+(NSMutableDictionary*)getClassPropertyDictionary
{
    static NSMutableDictionary* dic = nil;
    if(dic == nil)
    {
        dic = [[NSMutableDictionary alloc]init];
    }
    NSString* className = [NSStringFromClass([self class]) uppercaseString];
    NSMutableDictionary* classDic = [dic objectForKey:className];
    if(classDic == nil)
    {
        classDic = [[NSMutableDictionary alloc]init];
        [dic setObject:classDic forKey:className];
    }
    return classDic;
}
+(NSDictionary*)propertys
{
    NSMutableDictionary* dic = [[self class] getClassPropertyDictionary];
    if([dic.allKeys count] <= 0)
    {
        Class cls = [self class];
//        //处理Protocol
//        NSString* protocolName = [[self class] protocolName];
//        if(protocolName != nil)
//        {
//            u_int protocolCount = 0;
//            Protocol* proto = objc_getProtocol([protocolName cStringUsingEncoding:NSUTF8StringEncoding]);
//            objc_property_t* protocolProperties = protocol_copyPropertyList(proto, &protocolCount);
//            for (int i = 0; i < protocolCount ; i++)
//            {
//                const char* propertyName = property_getName(protocolProperties[i]);
//                const char* propertyType = property_getType(protocolProperties[i]);
//                NSString* name = [NSString stringWithFormat:@"%s",propertyName];
//                NSString* type = [NSString stringWithFormat:@"%s",propertyType];
//                if([type isEqualToString:@"T@\"NSString\""])
//                {
//                    [dic setValue:@"TEXT" forKey:name];
//                }
//                else if([type isEqualToString:@"Ti"])
//                {
//                    [dic setValue:@"INT" forKey:name];
//                }
//                else if([type isEqualToString:@"Tc"])
//                {
//                    [dic setValue:@"CHAR" forKey:name];
//                }
//                else if([type isEqualToString:@"Tl"])
//                {
//                    [dic setValue:@"LONG" forKey:name];
//                }
//                else if([type isEqualToString:@"Td"])
//                {
//                    [dic setValue:@"DOUBLE" forKey:name];
//                }
//                else if([type isEqualToString:@"Tf"])
//                {
//                    [dic setValue:@"FLOAT" forKey:name];
//                }
//                else if([type isEqualToString:@"T@\"NSDate\""])
//                {
//                    [dic setValue:@"DATE" forKey:name];
//                }
//            }
//            free(protocolProperties);
//        }        
        //处理Property

        
        //处理属性
        u_int count;
        objc_property_t *properties = class_copyPropertyList(cls, &count);
        for (int i = 0; i < count ; i++)
        {
            const char* propertyName = property_getName(properties[i]);
            const char* propertyType = property_getType(properties[i]);
            NSString* name = [NSString stringWithFormat:@"%s",propertyName];
            NSString* type = [NSString stringWithFormat:@"%s",propertyType];
            
            if([type isEqualToString:@"T@\"NSString\""])
            {
                [dic setValue:@"TEXT" forKey:name];
            }
            else if([type isEqualToString:@"Ti"])
            {
                [dic setValue:@"INT" forKey:name];
            }
            else if([type isEqualToString:@"Tc"])
            {
                [dic setValue:@"CHAR" forKey:name];
            }
            else if([type isEqualToString:@"Tl"])
            {
                [dic setValue:@"LONG" forKey:name];
            }
            else if([type isEqualToString:@"Td"])
            {
                [dic setValue:@"DOUBLE" forKey:name];
            }
            else if([type isEqualToString:@"Tf"])
            {
                [dic setValue:@"FLOAT" forKey:name];
            }
            else if([type isEqualToString:@"T@\"NSDate\""])
            {
                [dic setValue:@"DATE" forKey:name];
            }
        }
        free(properties);
        
        //处理成员
        Ivar* ivars = class_copyIvarList(cls, &count);
        for (int i = 0; i < count ; i++)
        {
            const char* ivarName = ivar_getName(ivars[i]);
            const char* ivarType = ivar_getTypeEncoding(ivars[i]);
            NSString* name = [NSString stringWithFormat:@"%s",ivarName];
            NSString* type = [NSString stringWithFormat:@"%s",ivarType];
//            NSLog(@"===name:%@,type:%@",name,type);
            if([type isEqualToString:@"@\"NSString\""])
            {
                [dic setValue:@"TEXT" forKey:name];
            }
            else if([type isEqualToString:@"i"])
            {
                [dic setValue:@"INT" forKey:name];
            }
            else if([type isEqualToString:@"c"])
            {
                [dic setValue:@"CHAR" forKey:name];
            }
            else if([type isEqualToString:@"l"])
            {
                [dic setValue:@"LONG" forKey:name];
            }
            else if([type isEqualToString:@"d"])
            {
                [dic setValue:@"DOUBLE" forKey:name];
            }
            else if([type isEqualToString:@"f"])
            {
                [dic setValue:@"FLOAT" forKey:name];
            }
            else if([type isEqualToString:@"NSDate"])
            {
                [dic setValue:@"DATE" forKey:name];
            }
        }
        free(ivars);
    }
    return (NSDictionary*)dic;
}
+(BOOL)registTable:(NSString*)tableName
{
    static NSMutableDictionary* registedDic = nil;
    if(tableName == nil)
    {
        tableName = [NSStringFromClass([self class]) uppercaseString];
    }
    if(registedDic == nil)
    {
        registedDic = [[NSMutableDictionary alloc]init];
    }
    id obj = [registedDic objectForKey:tableName];
    BOOL m_registed = YES;
    if(obj == nil || [(NSNumber*)obj intValue] == 0)
    {
        m_registed = NO;
    }
    if(!m_registed)
    {
        DataBase* db = nil;
        if([[self class] databaseType] == PublicDataBase)
        {
            db = [PublicDataBaseManager sharedInstance];
        }
        else
        {
            db = [UserDataBaseManager sharedInstance];
        }
        FMResultSet *rs = [db executeQuery:@"select count(*) as 'count' from sqlite_master where type ='table' and name = ?",tableName];
        while ([rs next])
        {
            NSInteger count = [rs intForColumn:@"count"];
            NSLog(@"isTableOK %d %@", count,tableName);
            if (0 == count)
            {
                //没有数据表 直接创建
                NSString* sql = [[self class] createSql:tableName];
                m_registed = [db registerTable:sql];
            }
            else
            {
                //有数据表 升级
                NSDictionary* dic = [[self class] propertys];
                for(NSString* column in dic.allKeys)
                {
                    if(![db columnExists:tableName columnName:column])
                    {
                        [db executeUpdate:[NSString stringWithFormat:@"ALTER TABLE %@ add COLUMN %@ %@;",tableName,column,[dic objectForKey:column]]];
                    }
                }
                m_registed = YES;
            }
        }
        [registedDic setObject:[NSNumber numberWithInt:m_registed?1:0] forKey:tableName];
    }
    return  m_registed;
}
+(NSString*)createSql:(NSString*)tableName
{
    static NSMutableDictionary* createSqlDic = nil;
    if(createSqlDic == nil)
    {
        createSqlDic = [[NSMutableDictionary alloc]init];
    }
    if(tableName == nil)
    {
        tableName = [NSStringFromClass([self class]) uppercaseString];
    }
    NSMutableString* sql = [createSqlDic objectForKey:tableName];
    if(sql == nil)
    {
        NSDictionary* dic = [[self class] propertys];
        if(dic != nil)
        {
            sql = [[NSMutableString alloc]init];
            [sql appendFormat:@"create table if not exists %@ (",tableName] ;
            int i = 0;
            for(NSString* name in dic.allKeys)
            {
                NSString* type = [dic objectForKey:name];
                [sql appendString:name];
                [sql appendString:@" "];
                [sql appendString:type];
                if([name isEqualToString:[[self class] primaryKey]])
                {
                    [sql appendString:@" PRIMARY KEY"];
                }
                if(i < [dic.allKeys count]-1)
                {
                    [sql appendString:@","];
                }
                i++;
            }
            [sql appendString:@")"];
        }
        if(sql != nil)
        {
            [createSqlDic setObject:sql forKey:tableName];
        }
    }
    return sql;
}
+(NSString*)updateSql:(NSString*)tableName
{
    static NSMutableDictionary* updateSqlDic = nil;
    if(tableName == nil)
    {
        tableName = [NSStringFromClass([self class]) uppercaseString];
    }
    if(updateSqlDic == nil)
    {
        updateSqlDic = [[NSMutableDictionary alloc]init];
    }
    NSMutableString* sql = [updateSqlDic objectForKey:tableName];
    if(sql == nil)
    {
        NSDictionary* dic = [[self class] propertys];
        if(dic != nil)
        {
            sql = [[NSMutableString alloc]init];
            [sql appendFormat:@"insert or replace into %@ (",tableName];
            int i = 0;
            NSMutableString* valueString = [NSMutableString string];
            [valueString appendString:@" values ("];
            for(NSString* name in dic.allKeys)
            {
                [sql appendString:name];

                [valueString appendString:@"?"];
                if(i < [dic.allKeys count]-1)
                {
                    [sql appendString:@","];
                    [valueString appendString:@","];
                }
                i++;
            }
            [sql appendString:@")"];
            [valueString appendString:@")"];
            [sql appendString:valueString];
        }
        if(sql != nil)
        {
            [updateSqlDic setObject:sql forKey:tableName];
        }
    }
    return sql;
}
+(NSString*)queryWithSelect:(NSString*)select condition:(NSString*)condition tableName:(NSString*)tableName
{
    [[self class] registTable:tableName];
    if(tableName == nil)
    {
        tableName = [NSStringFromClass([self class]) uppercaseString];
    }
    NSMutableString* sql = [NSMutableString stringWithFormat:@" %@ %@ %@",
                            select==nil?@"select * from":select,
                            tableName,
                            condition==nil?@"":condition];
    return sql;
}
+(id)asynchronize:(FMResultSet*)resultSet
{
    id obj = [[[self class] alloc]init];
    NSDictionary* dic = [[self class] propertys];
    if(dic != nil)
    {
        for(NSString* name in dic.allKeys)
        {
            NSString* type = [dic objectForKey:name];
            if([type isEqualToString:@"TEXT"])
            {
                [obj setValue:[resultSet stringForColumn:name] forKey:name];
            }
            else if([type isEqualToString:@"INT"])
            {
                [obj setValue:[NSNumber numberWithInt:[resultSet intForColumn:name]] forKey:name];
            }
            else if([type isEqualToString:@"CHAR"])
            {
                [obj setValue:[NSNumber numberWithChar:[resultSet intForColumn:name]] forKey:name];
            }
            else if([type isEqualToString:@"LONG"])
            {
                [obj setValue:[NSNumber numberWithLong:[resultSet longForColumn:name]] forKey:name];
            }
            else if([type isEqualToString:@"DOUBLE"])
            {
                [obj setValue:[NSNumber numberWithDouble:[resultSet doubleForColumn:name]] forKey:name];
            }
            else if([type isEqualToString:@"FLOAT"])
            {
                [obj setValue:[NSNumber numberWithFloat:[resultSet doubleForColumn:name]] forKey:name];
            }
            else if([type isEqualToString:@"DATE"])
            {
                [obj setValue:[resultSet dateForColumn:name] forKey:name];
            }
        }
    }
    return obj;
}
-(BOOL)synchronize:(NSString*)tableName
{
    if([[self class] registTable:tableName])
    {
        NSDictionary* dic = [[self class] propertys];
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        for(NSString* name in dic.allKeys)
        {
            id obj = [self valueForKey:name];
            [arr addObject:obj==nil?[NSNull null]:obj];
        }
        NSString* sql = [[self class] updateSql:tableName];
        if(dic == nil || sql == nil)
        {
            return NO;
        }
        DataBase* db = nil;
        if([[self class] databaseType] == PublicDataBase)
        {
            db = [PublicDataBaseManager sharedInstance];
        }
        else
        {
            db = [UserDataBaseManager sharedInstance];
        }
        return [db executeUpdate:sql withArgumentsInArray:arr];
    }
    return NO;
}
+(BOOL)deleteWith:(NSString*)tableName condition:(NSString*)condition
{
    NSString* sql = nil;
    if(condition == nil)
    {
        sql = [NSString stringWithFormat:@" delete  from %@ ;commit;",
               tableName == nil?NSStringFromClass([self class]):tableName];
    }
    else
    {
        sql = [NSString stringWithFormat:@" delete  from %@ %@ ;commit;",
               tableName == nil?NSStringFromClass([self class]):tableName,condition];
    }
    DataBase* db = nil;
    if([[self class] databaseType] == PublicDataBase)
    {
        db = [PublicDataBaseManager sharedInstance];
    }
    else
    {
        db = [UserDataBaseManager sharedInstance];
    }
    return [db executeUpdate:sql];
}
@end
