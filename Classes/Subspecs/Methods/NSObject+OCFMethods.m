//
//  NSObject+OCFMethods.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 12/2/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "NSObject+OCFMethods.h"
#import "OCFuntime+Methods.h"
#import "OCFuntime+Shared.h"

@implementation NSObject (OCFMethods)

- (void)changeMethod:(SEL)method implementation:(id)block
{
    [OCFuntime.shared changeClass:self.class instanceMethod:method implementation:block];
}

+ (void)changeMethod:(SEL)method implementation:(id)block
{
    [OCFuntime.shared changeClass:self classMethod:method implementation:block];
}

- (void)revertMethod:(SEL)method
{
    [OCFuntime.shared revertClass:self.class instanceMethod:method];
}

+ (void)revertMethod:(SEL)method
{
    [OCFuntime.shared revertClass:self classMethod:method];
}

- (void)revertMethods
{
    [OCFuntime.shared revertClass:self.class];
}

+ (void)revertMethods
{
    [OCFuntime.shared revertClass:self];
}

@end
