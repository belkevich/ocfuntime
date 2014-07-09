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

+ (void)injectClass:(Class)theClass classMethod:(SEL)method types:(const char *)types
              block:(id)block
{
    Class class = object_getClass(theClass);
    [self injectClass:class instanceMethod:method types:types block:block];
}


+ (void)injectClass:(Class)theClass instanceMethod:(SEL)method types:(const char *)types
              block:(id)block
{
    IMP implementation = imp_implementationWithBlock(block);
    BOOL result = class_addMethod(theClass, method, implementation, types);
    if (!result)
    {
        class_replaceMethod(theClass, method, implementation, types);
    }
}

+ (void)swizzleClass:(Class)theClass classMethod:(SEL)originalMethod withMethod:(SEL)swizzledMethod
{
    Method original = class_getClassMethod(theClass, originalMethod);
    Method swizzled = class_getClassMethod(theClass, swizzledMethod);
    method_exchangeImplementations(original, swizzled);
}

+ (void)swizzleClass:(Class)theClass instanceMethod:(SEL)originalMethod
          withMethod:(SEL)swizzledMethod
{
    Method original = class_getInstanceMethod(theClass, originalMethod);
    Method swizzled = class_getInstanceMethod(theClass, swizzledMethod);
    method_exchangeImplementations(original, swizzled);
}

@end
