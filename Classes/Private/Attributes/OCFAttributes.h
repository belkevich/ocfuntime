//
//  OCFAttributes.h
//  OCFuntime
//
//  Created by Alexey Belkevich on 12/16/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef enum
{
    OCFAttributeStorageAssign = 0,
    OCFAttributeStorageRetain = 1,
    OCFAttributeStorageCopy = 2,
    OCFAttributeStorageWeak = 3,

} OCFAttributeStorage;

@interface OCFAttributes : NSObject

@property (nonatomic, readonly) NSString *type;
@property (nonatomic, readonly) OCFAttributeStorage storage;
@property (nonatomic, readonly) BOOL isReadonly;
@property (nonatomic, readonly) BOOL isNonatomic;
@property (nonatomic, readonly) BOOL isDynamic;
@property (nonatomic, readonly) BOOL isSynthesized;

- (id)initWithProperty:(objc_property_t)property;

@end
