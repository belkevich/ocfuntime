//
//  OCFMethod.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import <objc/runtime.h>
#import "OCFMethod.h"

@interface OCFMethod ()

- (id)initWithClass:(Class)theClass method:(SEL)selector instance:(BOOL)instance;

@end

@implementation OCFMethod

#pragma mark -
#pragma mark main routine

- (id)initWithClass:(Class)theClass instanceMethod:(SEL)selector
{
    return [self initWithClass:theClass method:selector instance:YES];
}

- (id)initWithClass:(Class)theClass classMethod:(SEL)selector
{
    return [self initWithClass:theClass method:selector instance:NO];
}

- (id)initWithClass:(Class)theClass method:(SEL)selector instance:(BOOL)instance
{
    self = [super init];
    if (self)
    {
        method = instance ? class_getInstanceMethod(theClass, selector) :
                      class_getClassMethod(theClass, selector);
    }
    return self;
}

+ (id)methodWithClass:(Class)theClass instanceMethod:(SEL)selector
{
    return [[self alloc] initWithClass:theClass instanceMethod:selector];
}

+ (id)methodWithClass:(Class)theClass classMethod:(SEL)selector
{
    return [[self alloc] initWithClass:theClass classMethod:selector];
}

#pragma mark -
#pragma mark actions

- (void)changeImplementationWithBlock:(id)block
{
    implementation = method_getImplementation(method);
    IMP blockImplementation = imp_implementationWithBlock(block);
    method_setImplementation(method, blockImplementation);
}

- (void)revertImplementation
{
    method_setImplementation(method, implementation);
}

@end