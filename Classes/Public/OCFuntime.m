//
//  OCFuntime.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFuntime.h"
#import "OCFClassMethods.h"
#import "OCFPropertyInjector.h"

@interface OCFuntime ()
{
    NSMutableDictionary *_changedMethods;
    NSMutableDictionary *_injectedProperties;
}

@end

@implementation OCFuntime

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        _changedMethods = [[NSMutableDictionary alloc] init];
        _injectedProperties = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [self revertAll];
    [self removeAllProperties];
}

#pragma mark - public

- (void)changeClass:(Class)theClass instanceMethod:(SEL)method implementation:(id)block
{
    OCFClassMethods *model = [self modelForClass:theClass create:YES];
    [model changeInstanceMethod:method implementationWithBlock:block];
}

- (void)changeClass:(Class)theClass classMethod:(SEL)method implementation:(id)block
{
    OCFClassMethods *model = [self modelForClass:theClass create:YES];
    [model changeClassMethod:method implementationWithBlock:block];
}

- (void)revertClass:(Class)theClass instanceMethod:(SEL)method
{
    OCFClassMethods *model = [self modelForClass:theClass create:NO];
    [model revertInstanceMethod:method];
}

- (void)revertClass:(Class)theClass classMethod:(SEL)method
{
    OCFClassMethods *model = [self modelForClass:theClass create:NO];
    [model revertClassMethod:method];
}

- (void)revertClass:(Class)theClass
{
    OCFClassMethods *model = [self modelForClass:theClass create:NO];
    [model revertAllToDefaultImplementation];
}

- (void)revertAll
{
    [[_changedMethods allValues] makeObjectsPerformSelector:@selector(revertAllToDefaultImplementation)];
}

- (void)injectClass:(Class)theClass property:(NSString *)propertyName
{
    OCFPropertyInjector *injector = [self propertyInjectorForClass:theClass];
    if (!injector)
    {
        injector = [[OCFPropertyInjector alloc] initWithClass:theClass];
        [_injectedProperties setObject:injector forKey:NSStringFromClass(theClass)];
    }
    [injector injectProperty:propertyName];
}

- (void)removeClass:(Class)theClass property:(NSString *)propertyName
{
    OCFPropertyInjector *injector = [self propertyInjectorForClass:theClass];
    [injector removeProperty:propertyName];
}

- (void)removeClassProperties:(Class)theClass
{
    OCFPropertyInjector *injector = [self propertyInjectorForClass:theClass];
    [injector removeAllProperties];
    [_injectedProperties removeObjectForKey:NSStringFromClass(theClass)];
}

- (void)removeAllProperties
{
    [_injectedProperties.allValues makeObjectsPerformSelector:@selector(removeAllProperties)];
    [_injectedProperties removeAllObjects];
}

#pragma mark - private

- (OCFClassMethods *)modelForClass:(Class)theClass create:(BOOL)create
{
    NSString *className = NSStringFromClass(theClass);
    OCFClassMethods *model = [_changedMethods objectForKey:className];
    if (!model && create)
    {
        model = [[OCFClassMethods alloc] initWithClass:theClass];
        [_changedMethods setObject:model forKey:className];
    }
    return model;
}

- (OCFPropertyInjector *)propertyInjectorForClass:(Class)theClass
{
    NSString *className = NSStringFromClass(theClass);
    return  [_injectedProperties objectForKey:className];
}

@end