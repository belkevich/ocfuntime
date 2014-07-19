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

+ (void)changeInstanceMethod:(SEL)method implementation:(id)block
{
    [OCFuntime.shared changeClass:self.class instanceMethod:method implementation:block];
}

+ (void)changeClassMethod:(SEL)method implementation:(id)block
{
    [OCFuntime.shared changeClass:self classMethod:method implementation:block];
}

+ (void)revertInstanceMethod:(SEL)method
{
    [OCFuntime.shared revertClass:self.class instanceMethod:method];
}

+ (void)revertClassMethod:(SEL)method
{
    [OCFuntime.shared revertClass:self classMethod:method];
}

+ (void)revertMethods
{
    [OCFuntime.shared revertClassMethods:self];
}

@end
