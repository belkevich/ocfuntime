//
//  OCFProperty.h
//  OCFuntime
//
//  Created by Alexey Belkevich on 12/16/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@class OCFAttributes;

@interface OCFProperty : NSObject

@property (nonatomic, readonly) NSString *getterName;
@property (nonatomic, readonly) NSString *setterName;
@property (nonatomic, readonly) NSMethodSignature *getterSignature;
@property (nonatomic, readonly) NSMethodSignature *setterSignature;
@property (nonatomic, readonly) OCFAttributes *attributes;

- (id)initWithProperty:(objc_property_t)property;

@end
