//
//  NSException+OCFuntime.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 7/8/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "NSException+OCFuntime.h"

@implementation NSException (OCFuntime)

#pragma mark - public

+ (instancetype)exceptionUnexistedMethod:(SEL)method inClass:(Class)theClass
{
    NSString *reason = [NSString stringWithFormat:@"Method '%@' not found in class '%@'",
                                                  NSStringFromSelector(method),
                                                  NSStringFromClass(theClass)];
    return [self exceptionWithSuffix:@"Method not found" reason:reason];
}

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

#pragma mark - private

+ (instancetype)exceptionWithSuffix:(NSString *)suffix reason:(NSString *)reason
{
    NSString *name = [NSString stringWithFormat:@"OCFuntime exception: '%@'", suffix];
    return [NSException exceptionWithName:name reason:reason userInfo:nil];
}

@end
