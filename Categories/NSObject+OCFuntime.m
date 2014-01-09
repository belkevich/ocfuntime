//
//  NSObject+OCFuntime.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 12/2/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "NSObject+OCFuntime.h"
#import "OCFuntime+Multiton.h"

@implementation NSObject (OCFuntime)

- (void)changeMethod:(SEL)method implementation:(id)block
{
    [OCFuntime.sharedInstance changeClass:self.class instanceMethod:method implementation:block];
}

+ (void)changeMethod:(SEL)method implementation:(id)block
{
    [OCFuntime.sharedInstance changeClass:self classMethod:method implementation:block];
}

- (void)revertMethod:(SEL)method
{
    [OCFuntime.sharedInstance revertClass:self.class instanceMethod:method];
}

+ (void)revertMethod:(SEL)method
{
    [OCFuntime.sharedInstance revertClass:self classMethod:method];
}

- (void)revertMethods
{
    [OCFuntime.sharedInstance revertClass:self.class];
}

+ (void)revertMethods
{
    [OCFuntime.sharedInstance revertClass:self];
}

@end
