//
//  OCFPropertyParser.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/3/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCFPropertyAttributes.h"

@interface OCFPropertyParser : NSObject

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *getterName;
@property (nonatomic, readonly) NSString *setterName;
@property (nonatomic, readonly) NSMethodSignature *getterSignature;
@property (nonatomic, readonly) NSMethodSignature *setterSignature;
@property (nonatomic, readonly) OCFPropertyAttributes *attributes;

- (void)parseProperty:(objc_property_t)property;

@end
