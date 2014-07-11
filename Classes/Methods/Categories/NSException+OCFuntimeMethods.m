//
//  NSException+OCFuntimeMethods.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/9/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "NSException+OCFuntimeMethods.h"
#import "NSException+OCFuntimeCore.h"

@implementation NSException (OCFuntimeMethods)

+ (instancetype)exceptionNonexistentMethod:(SEL)method inClass:(Class)theClass
{
    NSString *reason = [NSString stringWithFormat:@"Method '%@' not found in class '%@'",
                        NSStringFromSelector(method),
                        NSStringFromClass(theClass)];
    return [self exceptionWithSuffix:@"Method not found" reason:reason];
}

@end
