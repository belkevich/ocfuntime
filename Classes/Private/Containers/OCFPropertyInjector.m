//
//  OCFPropertyInjector.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 12/10/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFPropertyInjector.h"
#import "OCFPropertyParser.h"
#import "OCFPropertyFetcher.h"
#import "OCFPropertyBlocksBuilder.h"
#import "OCFMethodInjector.h"
#import "NSException+OCFuntime.h"

@interface OCFPropertyInjector ()
{
    Class _theClass;
    OCFPropertyFetcher *_fetcher;
    OCFPropertyParser *_parser;
    NSMutableDictionary *_methodsSignatures;
    NSMutableDictionary *_methodsAttributes;
}
@end

@implementation OCFPropertyInjector

#pragma mark - life cycle

- (id)initWithClass:(Class)theClass
{
    if (self = [super init])
    {
        _theClass = theClass;
        _fetcher = [[OCFPropertyFetcher alloc] init];
        [_fetcher fetchAllPropertiesOfClass:theClass];
        _parser = [[OCFPropertyParser alloc] init];
        _methodsSignatures = [[NSMutableDictionary alloc] init];
        _methodsAttributes = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - public

- (void)injectProperty:(NSString *)propertyName
{
    objc_property_t property = [_fetcher findPropertyWithName:propertyName];
    if (property)
    {
        [_parser parseProperty:property name:propertyName];
        OCFPropertyAttributes *attributes = _parser.attributes;
        NSString *getterName = _parser.getterName;
        NSString *setterName = _parser.setterName;
        if (![_theClass instancesRespondToSelector:NSSelectorFromString(getterName)] &&
            ![_theClass instancesRespondToSelector:NSSelectorFromString(setterName)])
        {
            if (_methodsSignatures.count == 0 && _methodsAttributes.count == 0)
            {
                [self swizzleInvocationMethods];
            }
            _methodsSignatures[getterName] = _parser.getterSignature;
            _methodsSignatures[setterName] = _parser.setterSignature;
            _methodsAttributes[getterName] = attributes;
            _methodsAttributes[setterName] = attributes;
        }
        else
        {
            @throw [NSException exceptionImplementedProperty:propertyName inClass:_theClass];
        }
    }
    else
    {
        @throw [NSException exceptionUndefinedProperty:propertyName inClass:_theClass];
    }
}

- (void)removeProperty:(NSString *)propertyName
{
    [_methodsSignatures removeObjectForKey:propertyName];
    [_methodsAttributes removeObjectForKey:propertyName];
    if (_methodsSignatures.count > 0 && _methodsAttributes.count > 0)
    {
        [self revertInvocationMethods];
    }
}

- (void)removeAllProperties
{
    [_methodsSignatures removeAllObjects];
    [_methodsAttributes removeAllObjects];
    [self revertInvocationMethods];
}

#pragma mark - private

- (void)revertInvocationMethods
{
    [OCFMethodInjector swizzleClass:_theClass instanceMethod:@selector(methodSignatureForSelector:)
                         withMethod:@selector(OCFMethodSignatureForSelector:)];
    [OCFMethodInjector swizzleClass:_theClass instanceMethod:@selector(forwardInvocation:)
                         withMethod:@selector(OCFForwardInvocation:)];
}

- (void)swizzleInvocationMethods
{
    [self swizzleMethodSignatureMethod];
    [self swizzleForwardInvocationMethod];
}

- (void)swizzleMethodSignatureMethod
{
    SEL method = @selector(OCFMethodSignatureForSelector:);
    id block = [OCFPropertyBlocksBuilder methodSignatureBlockWithDictionary:_methodsSignatures];
    [OCFMethodInjector injectClass:_theClass instanceMethod:method types:"@@::" block:block];
    [OCFMethodInjector swizzleClass:_theClass instanceMethod:@selector(methodSignatureForSelector:)
                         withMethod:method];
}

- (void)swizzleForwardInvocationMethod
{
    SEL method = @selector(OCFForwardInvocation:);
    id block = [OCFPropertyBlocksBuilder forwardInvocationBlockWithDictionary:_methodsAttributes];
    [OCFMethodInjector injectClass:_theClass instanceMethod:method types:"v@:@" block:block];
    [OCFMethodInjector swizzleClass:_theClass instanceMethod:@selector(forwardInvocation:)
                         withMethod:method];
}

@end
