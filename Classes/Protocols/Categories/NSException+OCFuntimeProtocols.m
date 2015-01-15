//
//  NSException+OCFuntimeProtocols.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/15/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import "NSException+OCFuntimeProtocols.h"
#import "NSException+OCFuntimeCore.h"
#import "OCFAutoInjectProtocol.h"


@implementation NSException (OCFuntimeProtocols)

+ (NSException *)exceptionNoProtocol
{
    return [self exceptionWithSuffix:@"Invalid protocol" reason:@"Protocol should not be nil"];
}


+ (NSException *)exceptionNoMethod
{
    return [self exceptionWithSuffix:@"Invalid method" reason:@"Method should not be nil"];
}


+ (NSException *)exceptionNoImplementation
{
    return [self exceptionWithSuffix:@"Invalid implementation" reason:@"Implementation should not be nil"];
}


+ (NSException *)exceptionInvalidProtocol:(Protocol *)theProtocol
{
    NSString *reason = [NSString stringWithFormat:@"Protocol '%@' should conform '%@'",
      NSStringFromProtocol(theProtocol), NSStringFromProtocol(@protocol(OCFAutoInjectProtocol))];
    return [self exceptionWithSuffix:@"Invalid protocol" reason:reason];
}


+ (NSException *)exceptionInvalidProtocol:(Protocol *)theProtocol method:(SEL)method
{
    NSString *reason = [NSString stringWithFormat:@"Method '%@' is not defined in '%@'",
      NSStringFromSelector(method), NSStringFromProtocol(theProtocol)];
    return [self exceptionWithSuffix:@"Invalid method" reason:reason];
}

@end
