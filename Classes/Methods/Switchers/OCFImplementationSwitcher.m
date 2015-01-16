//
//  OCFImplementationSwitcher.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFImplementationSwitcher.h"
#import "NSException+OCFuntimeMethods.h"

@interface OCFImplementationSwitcher ()
{
    Method _method;
    IMP _defaultImplementation;
}
@end

@implementation OCFImplementationSwitcher

#pragma mark - life cycle

- (instancetype)initWithClass:(Class)theClass instanceMethod:(SEL)selector
{
    return [self initWithClass:theClass method:selector instance:YES];
}

- (instancetype)initWithClass:(Class)theClass classMethod:(SEL)selector
{
    return [self initWithClass:theClass method:selector instance:NO];
}

- (instancetype)initWithClass:(Class)theClass method:(SEL)selector instance:(BOOL)instance
{
    self = [super init];
    if (self)
    {
        _method = instance ? class_getInstanceMethod(theClass, selector) :
                  class_getClassMethod(theClass, selector);
        if (!_method)
        {
            @throw [NSException exceptionNonexistentMethod:selector inClass:theClass];
        }
    }
    return self;
}

#pragma mark - public

- (void)changeImplementationWithBlock:(id)block
{
    if (!_defaultImplementation)
    {
        _defaultImplementation = method_getImplementation(_method);
    }
    if (!block)
    {
        block = ^{};
    }
    IMP blockImplementation = imp_implementationWithBlock(block);
    method_setImplementation(_method, blockImplementation);
}

- (void)revertImplementation
{
    if (_defaultImplementation)
    {
        IMP blockImplementation = method_getImplementation(_method);
        imp_removeBlock(blockImplementation);
        method_setImplementation(_method, _defaultImplementation);
        _defaultImplementation = NULL;
    }
}

@end