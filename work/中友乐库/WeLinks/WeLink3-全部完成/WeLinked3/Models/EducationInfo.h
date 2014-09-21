//
//  EducationInfo.h
//  WeLinked3
//
//  Created by jonas on 2/27/14.
//  Copyright (c) 2014 WeLinked. All rights reserved.
//

#import "NSObjectExtention.h"
@interface EducationInfo : NSObjectExtention
@property(nonatomic,assign)int       canDel;
@property(nonatomic,strong)NSString* identity;
@property(nonatomic,strong)NSString* userId;
@property(nonatomic,strong)NSString* department;
@property(nonatomic,assign)int education;//1=大专及以下 2=本科 3=硕士 4=博士及以上
@property(nonatomic,strong)NSString* school;
@property(nonatomic,strong)NSString* specialty;
@property(nonatomic,strong)NSString* year;
@property(nonatomic,strong)NSString* educationDesc;
@end
