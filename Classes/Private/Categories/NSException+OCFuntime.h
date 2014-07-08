//
//  NSException+OCFuntime.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/8/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSException (OCFuntime)

+ (instancetype)exceptionUnexistedMethod:(SEL)method inClass:(Class)theClass;
+ (instancetype)exceptionUndefinedProperty:(NSString *)propertyName inClass:(Class)theClass;
+ (instancetype)exceptionImplementedProperty:(NSString *)propertyName inClass:(Class)theClass;

@end
