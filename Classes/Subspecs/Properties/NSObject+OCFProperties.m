//
//  NSObject+OCFProperties.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/10/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "NSObject+OCFProperties.h"
#import "OCFuntime+Properties.h"
#import "OCFuntime+Shared.h"

@implementation NSObject (OCFProperties)

- (void)injectProperty:(NSString *)propertyName
{
    [OCFuntime.shared injectClass:self.class property:propertyName];
}

- (void)removeProperty:(NSString *)propertyName
{
    [OCFuntime.shared removeClass:self.class property:propertyName];
}

- (void)removeProperties
{
    [OCFuntime.shared removeClassProperties:self.class];
}

@end
