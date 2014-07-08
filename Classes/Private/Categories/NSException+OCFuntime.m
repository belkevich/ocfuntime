//
//  NSException+OCFuntime.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/8/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "NSException+OCFuntime.h"

@implementation NSException (OCFuntime)

#pragma mark - public

+ (instancetype)exceptionNoMethod:(SEL)method inClass:(Class)theClass
{
    NSString *reason = [NSString stringWithFormat:@"Method '%@' not found in class '%@'",
                                                  NSStringFromSelector(method),
                                                  NSStringFromClass(theClass)];
    return [self exceptionWithSuffix:@"Method not found" reason:reason];
}

+ (instancetype)exceptionNoProperty:(NSString *)propertyName inClass:(Class)theClass
{
    NSString *reason = [NSString stringWithFormat:@"Property with name '%@' doesn't defined in "
                                                  "class '%@'", propertyName,
                                                  NSStringFromClass(theClass)];
    return [self exceptionWithSuffix:@"Property doesn't defined" reason:reason];
}

#pragma mark - private

+ (instancetype)exceptionWithSuffix:(NSString *)suffix reason:(NSString *)reason
{
    NSString *name = [NSString stringWithFormat:@"OCFuntime exception: '%@'", suffix];
    return [NSException exceptionWithName:name reason:reason userInfo:nil];
}

@end
