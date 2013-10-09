//
//  OCFModel.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import "OCFModel.h"
#import "OCFMethod.h"

@implementation OCFModel

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

+ (instancetype)modelWithClass:(Class)aClass
{
    return [[self alloc] initWithClass:aClass];
}

#pragma mark - actions

- (void)changeInstanceMethod:(SEL)selector withBlock:(id)block
{
    [self changeMethod:selector withBlock:block instance:YES];
}

- (void)changeClassMethod:(SEL)selector withBlock:(id)block
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

- (void)revertModel
{
    [[instanceMethods allValues] makeObjectsPerformSelector:@selector(revertImplementation)];
    [[classMethods allValues] makeObjectsPerformSelector:@selector(revertImplementation)];
    [instanceMethods removeAllObjects];
    [classMethods removeAllObjects];
}

#pragma mark - private

- (void)changeMethod:(SEL)selector withBlock:(id)block instance:(BOOL)instance
{
    OCFMethod *method = [self methodForSelector:selector instance:instance];
    [method changeImplementationWithBlock:block];
}

- (OCFMethod *)methodForSelector:(SEL)selector instance:(BOOL)instance
{
    NSString *selectorName = NSStringFromSelector(selector);
    NSMutableDictionary *methodsDictionary = instance ? instanceMethods : classMethods;
    OCFMethod *method = [methodsDictionary objectForKey:selectorName];
    if (!method)
    {
        method = instance ? [OCFMethod methodWithClass:theClass instanceMethod:selector] :
                 [OCFMethod methodWithClass:theClass classMethod:selector];
        [methodsDictionary setObject:method forKey:selectorName];
    }
    return method;
}

- (void)revertMethod:(SEL)selector instance:(BOOL)instance
{
    NSMutableDictionary *methodsDictionary = instance ? instanceMethods : classMethods;
    NSString *key = NSStringFromSelector(selector);
    OCFMethod *method = [methodsDictionary objectForKey:key];
    if (method)
    {
        [method revertImplementation];
        [methodsDictionary removeObjectForKey:key];
    }
}

@end