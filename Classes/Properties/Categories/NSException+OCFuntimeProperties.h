//
//  NSException+OCFuntimeProperties.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/9/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSException (OCFuntimeProperties)

+ (instancetype)exceptionUndefinedProperty:(NSString *)propertyName inClass:(Class)theClass;
+ (instancetype)exceptionImplementedProperty:(NSString *)propertyName inClass:(Class)theClass;

@end
