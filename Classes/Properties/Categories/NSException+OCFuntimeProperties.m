//
//  NSException+OCFuntimeProperties.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/9/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "NSException+OCFuntimeProperties.h"
#import "NSException+OCFuntimeCore.h"

@implementation NSException (OCFuntimeProperties)

+ (instancetype)exceptionUndefinedProperty:(NSString *)propertyName inClass:(Class)theClass
{
    NSString *reason = [NSString stringWithFormat:@"Property with name '%@' doesn't defined in "
                                                  "class '%@'", propertyName,
                                                  NSStringFromClass(theClass)];
    return [self exceptionWithSuffix:@"Property doesn't defined" reason:reason];
}

+ (instancetype)exceptionImplementedProperty:(NSString *)propertyName inClass:(Class)theClass
{
    NSString *reason = [NSString stringWithFormat:@"Property with name '%@' is already "
                                                  "implemented in class '%@'", propertyName,
                                                  NSStringFromClass(theClass)];
    return [self exceptionWithSuffix:@"Property already implemented" reason:reason];
}


@end
