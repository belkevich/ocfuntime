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
        [self injectMethodSignatureMethodToClass:theClass];
        [self injectForwardInvocationMethodToClass:theClass];
    }
    return self;
}

#pragma mark - public

- (void)injectProperty:(NSString *)propertyName
{
    objc_property_t property = [_fetcher findPropertyWithName:propertyName];
    if (property)
    {
        [_parser parseProperty:property];
        OCFPropertyAttributes *attributes = _parser.attributes;
        NSString *getterName = _parser.getterName;
        NSString *setterName = _parser.setterName;
        if (![_theClass instancesRespondToSelector:NSSelectorFromString(getterName)] &&
            ![_theClass instancesRespondToSelector:NSSelectorFromString(setterName)])
        {
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

#pragma mark - private

- (void)injectMethodSignatureMethodToClass:(Class)theClass
{
    SEL method = @selector(methodSignatureForSelector:);
    id block = [OCFPropertyBlocksBuilder methodSignatureBlockWithDictionary:_methodsSignatures];
    [OCFMethodInjector injectClass:theClass instanceMethod:method types:"@@::" block:block];
}

- (void)injectForwardInvocationMethodToClass:(Class)theClass
{
    SEL method = @selector(forwardInvocation:);
    id block = [OCFPropertyBlocksBuilder forwardInvocationBlockWithDictionary:_methodsAttributes];
    [OCFMethodInjector injectClass:theClass instanceMethod:method types:"v@:@" block:block];
}

@end
