//
//  OCFMethod.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFMethod.h"

@implementation OCFMethod

#pragma mark - life cycle

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
        if (!method)
        {
            NSString *reason = [NSString stringWithFormat:@"Method '%@' not found in class '%@'",
                                NSStringFromSelector(selector), NSStringFromClass(theClass)];
            NSLog(@"%@", reason);
            @throw [NSException exceptionWithName:@"OCFuntime can't find method exception"
                                           reason:reason userInfo:nil];
        }
    }
    return self;
}

+ (instancetype)methodWithClass:(Class)theClass instanceMethod:(SEL)selector
{
    return [[self alloc] initWithClass:theClass instanceMethod:selector];
}

+ (instancetype)methodWithClass:(Class)theClass classMethod:(SEL)selector
{
    return [[self alloc] initWithClass:theClass classMethod:selector];
}

#pragma mark - public

- (void)changeImplementationWithBlock:(id)block
{
    if (!defaultImplementation)
    {
        defaultImplementation = method_getImplementation(method);
    }
    if (!block)
    {
        block = ^{};
    }
    IMP blockImplementation = imp_implementationWithBlock(block);
    method_setImplementation(method, blockImplementation);
}

- (void)revertImplementation
{
    if (defaultImplementation)
    {
        IMP blockImplementation = method_getImplementation(method);
        imp_removeBlock(blockImplementation);
        method_setImplementation(method, defaultImplementation);
        defaultImplementation = NULL;
    }
}

@end