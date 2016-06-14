//
//  OCFPropertyInjector.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 12/10/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFPropertyInjector.h"
#import "OCFPropertyFetcher.h"
#import "OCFPropertyParser.h"
#import "OCFInvocationInjector.h"
#import "NSException+OCFuntimeProperties.h"
#import "NSObject+OCFuntimeProperties.h"

@interface OCFPropertyInjector ()
{
    Class _theClass;
    OCFPropertyFetcher *_fetcher;
    OCFPropertyParser *_parser;
    OCFInvocationInjector *_invocationInjector;
    NSMutableDictionary *_methodsSignatures;
    NSMutableDictionary *_methodsAttributes;
}
@end

@implementation OCFPropertyInjector

#pragma mark - life cycle

- (instancetype)initWithClass:(Class)theClass
{
    if (self = [super init])
    {
        _theClass = theClass;
        _fetcher = [[OCFPropertyFetcher alloc] init];
        [_fetcher fetchAllPropertiesOfClass:theClass];
        _parser = [[OCFPropertyParser alloc] init];
        _methodsSignatures = [[NSMutableDictionary alloc] init];
        _methodsAttributes = [[NSMutableDictionary alloc] init];
        _invocationInjector = [[OCFInvocationInjector alloc] initWithClass:_theClass
                                                      signaturesDictionary:_methodsSignatures
                                                      attributesDictionary:_methodsAttributes];
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
                [self injectInvocationMethods];
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
    if (_methodsSignatures.count == 0 && _methodsAttributes.count == 0)
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
    [_invocationInjector revertMethodSignatureMethod];
    [_invocationInjector revertForwardInvocationMethod];
    [_invocationInjector revertValueForKeyPathMethod];
    [_invocationInjector revertSetValueForKeyPathMethod];
}

- (void)injectInvocationMethods
{
    [_invocationInjector injectMethodSignatureMethod];
    [_invocationInjector injectForwardInvocationMethod];
    [_invocationInjector injectValueForKeyPathMethod];
    [_invocationInjector injectSetValueForKeyPathMethod];
}

@end
