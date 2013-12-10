//
//  OCFClassMethods.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFClassMethods.h"
#import "OCFMethodImplementation.h"

@implementation OCFClassMethods

#pragma mark - life cycle

- (id)initWithClass:(Class)aClass
{
    self = [super init];
    if (self)
    {
        theClass = aClass;
        instanceMethods = [[NSMutableDictionary alloc] init];
        classMethods = [[NSMutableDictionary alloc] init];
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
    [[instanceMethods allValues] makeObjectsPerformSelector:@selector(revertImplementation)];
    [[classMethods allValues] makeObjectsPerformSelector:@selector(revertImplementation)];
    [instanceMethods removeAllObjects];
    [classMethods removeAllObjects];
}

#pragma mark - private

- (void)changeMethod:(SEL)selector withBlock:(id)block instance:(BOOL)instance
{
    OCFMethodImplementation *method = [self methodForSelector:selector instance:instance];
    [method changeImplementationWithBlock:block];
}

- (OCFMethodImplementation *)methodForSelector:(SEL)selector instance:(BOOL)instance
{
    NSString *selectorName = NSStringFromSelector(selector);
    NSMutableDictionary *methodsDictionary = instance ? instanceMethods : classMethods;
    OCFMethodImplementation *method = [methodsDictionary objectForKey:selectorName];
    if (!method)
    {
        method = instance ?
                 [[OCFMethodImplementation alloc] initWithClass:theClass instanceMethod:selector]:
                 [[OCFMethodImplementation alloc] initWithClass:theClass classMethod:selector];
        [methodsDictionary setObject:method forKey:selectorName];
    }
    return method;
}

- (void)revertMethod:(SEL)selector instance:(BOOL)instance
{
    NSMutableDictionary *methodsDictionary = instance ? instanceMethods : classMethods;
    NSString *key = NSStringFromSelector(selector);
    OCFMethodImplementation *method = [methodsDictionary objectForKey:key];
    if (method)
    {
        [method revertImplementation];
        [methodsDictionary removeObjectForKey:key];
    }
}

@end