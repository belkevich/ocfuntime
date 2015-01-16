//
//  OCFMethodsSwitcher.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFMethodsSwitcher.h"
#import "OCFImplementationSwitcher.h"

@interface OCFMethodsSwitcher ()
{
    Class _theClass;
    NSMutableDictionary *_instanceMethods;
    NSMutableDictionary *_classMethods;
}
@end

@implementation OCFMethodsSwitcher

#pragma mark - life cycle

- (instancetype)initWithClass:(Class)aClass
{
    self = [super init];
    if (self)
    {
        _theClass = aClass;
        _instanceMethods = [[NSMutableDictionary alloc] init];
        _classMethods = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - actions

- (void)changeInstanceMethod:(SEL)selector implementationWithBlock:(id)block
{
    [self changeMethod:selector withBlock:block instance:YES];
}

- (void)changeClassMethod:(SEL)selector implementationWithBlock:(id)block
{
    [self changeMethod:selector withBlock:block instance:NO];
}

- (void)revertInstanceMethod:(SEL)selector
{
    [self revertMethod:selector instance:YES];
}

- (void)revertClassMethod:(SEL)selector
{
    [self revertMethod:selector instance:NO];
}

- (void)revertAllToDefaultImplementation
{
    [[_instanceMethods allValues] makeObjectsPerformSelector:@selector(revertImplementation)];
    [[_classMethods allValues] makeObjectsPerformSelector:@selector(revertImplementation)];
    [_instanceMethods removeAllObjects];
    [_classMethods removeAllObjects];
}

#pragma mark - private

- (void)changeMethod:(SEL)selector withBlock:(id)block instance:(BOOL)instance
{
    OCFImplementationSwitcher *method = [self methodForSelector:selector instance:instance];
    [method changeImplementationWithBlock:block];
}

- (OCFImplementationSwitcher *)methodForSelector:(SEL)selector instance:(BOOL)instance
{
    NSString *selectorName = NSStringFromSelector(selector);
    NSMutableDictionary *methodsDictionary = instance ? _instanceMethods : _classMethods;
    OCFImplementationSwitcher *method = [methodsDictionary objectForKey:selectorName];
    if (!method)
    {
        method = instance ?
                 [[OCFImplementationSwitcher alloc] initWithClass:_theClass instanceMethod:selector]:
                 [[OCFImplementationSwitcher alloc] initWithClass:_theClass classMethod:selector];
        [methodsDictionary setObject:method forKey:selectorName];
    }
    return method;
}

- (void)revertMethod:(SEL)selector instance:(BOOL)instance
{
    NSMutableDictionary *methodsDictionary = instance ? _instanceMethods : _classMethods;
    NSString *key = NSStringFromSelector(selector);
    OCFImplementationSwitcher *method = [methodsDictionary objectForKey:key];
    if (method)
    {
        [method revertImplementation];
        [methodsDictionary removeObjectForKey:key];
    }
}

@end