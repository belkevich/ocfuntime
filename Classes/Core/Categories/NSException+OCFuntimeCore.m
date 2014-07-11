//
//  NSException+OCFuntimeCore.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 7/8/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "NSException+OCFuntimeCore.h"

@implementation NSException (OCFuntimeCore)

+ (instancetype)exceptionWithSuffix:(NSString *)suffix reason:(NSString *)reason
{
    NSString *name = [NSString stringWithFormat:@"OCFuntime exception: '%@'", suffix];
    return [NSException exceptionWithName:name reason:reason userInfo:nil];
}

@end
