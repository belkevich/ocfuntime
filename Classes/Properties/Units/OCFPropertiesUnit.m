//
//  OCFPropertiesUnit.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/9/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "OCFPropertiesUnit.h"
#import "OCFPropertyInjector.h"

@interface OCFPropertiesUnit ()
{
    NSMutableDictionary *_injectedProperties;
}
@end

@implementation OCFPropertiesUnit

#pragma mark - life cycle

- (id)init
{
    self = [super init];
    if (self)
    {
        _injectedProperties = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - public

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

#pragma mark - unit protocol implementation

- (void)shutdownUnit
{
    [self removeAllProperties];
}

#pragma mark - private

- (OCFPropertyInjector *)propertyInjectorForClass:(Class)theClass
{
    NSString *className = NSStringFromClass(theClass);
    return [_injectedProperties objectForKey:className];
}

@end
