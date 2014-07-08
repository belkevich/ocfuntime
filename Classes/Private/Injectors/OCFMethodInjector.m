//
//  OCFMethodInjector.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/2/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <objc/runtime.h>
#import "OCFMethodInjector.h"

@implementation OCFMethodInjector

+ (BOOL)injectClass:(Class)theClass classMethod:(SEL)method types:(const char *)types
              block:(id)block
{
    Class class = object_getClass(theClass);
    return [self injectClass:class instanceMethod:method types:types block:block];
}


+ (BOOL)injectClass:(Class)theClass instanceMethod:(SEL)method types:(const char *)types
              block:(id)block
{
    IMP implementation = imp_implementationWithBlock(block);
    BOOL result = class_addMethod(theClass, method, implementation, types);
//    NSLog(@"injection of %@ is %@", NSStringFromSelector(method), result ? @"success" : @"fail");
    if (!result)
    {
        class_replaceMethod(theClass, method, implementation, types);
    }
    return result;
}

@end
