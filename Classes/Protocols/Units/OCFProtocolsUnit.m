//
//  OCFProtocolsUnit.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/15/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import <objc/runtime.h>
#import "OCFProtocolsUnit.h"
#import "OCFClassesFetcher.h"
#import "OCFProtocolInjector.h"
#import "OCFProtocolMethodsHelper.h"
#import "OCFAutoInjectProtocol.h"
#import "NSException+OCFuntimeProtocols.h"


@interface OCFProtocolsUnit ()
{
    OCFClassesFetcher *_classesFetcher;
    NSMutableDictionary *_protocols;
}
@end

@implementation OCFProtocolsUnit

#pragma mark - life cycle

- (instancetype)init
{
    self = [super init];
    if (self)
    {
        _classesFetcher = [[OCFClassesFetcher alloc] init];
        _protocols = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - public


- (void)forceInject:(BOOL)force protocol:(Protocol *)theProtocol instanceMethod:(SEL)method implementaion:(id)implementation {
    [self checkProtocol:theProtocol method:method implementation:implementation];
    OCFProtocolInjector *injector = [self injectorForProtocol:theProtocol];
    [injector forceInject:force instance:YES method:method implementation:implementation];
}


- (void)forceInject:(BOOL)force protocol:(Protocol *)theProtocol classMethod:(SEL)method implementaion:(id)implementation {
    [self checkProtocol:theProtocol method:method implementation:implementation];
    OCFProtocolInjector *injector = [self injectorForProtocol:theProtocol];
    [injector forceInject:force instance:NO method:method implementation:implementation];
}


#pragma mark - private

- (OCFProtocolInjector *)injectorForProtocol:(Protocol *)theProtocol
{
    NSString *protocolName = NSStringFromProtocol(theProtocol);
    OCFProtocolInjector *injector = _protocols[protocolName];
    if (!injector)
    {
        NSArray *classes = [_classesFetcher classesConformsToProtocol:theProtocol];
        injector = [[OCFProtocolInjector alloc] initWithProtocol:theProtocol classes:classes];
        _protocols[protocolName] = injector;
    }
    return injector;
}

- (void)checkProtocol:(Protocol *)theProtocol method:(SEL)method implementation:(id)implementation {
    [self checkProtocol:theProtocol method:method];
    if (!implementation)
    {
        @throw [NSException exceptionNoImplementation];
    }
}

- (void)checkProtocol:(Protocol *)theProtocol method:(SEL)method
{
    [self checkProtocol:theProtocol];
    if (!method)
    {
        @throw [NSException exceptionNoMethod];
    }
    else if (![OCFProtocolMethodsHelper protocol:theProtocol containsMethod:method])
    {
        @throw [NSException exceptionInvalidProtocol:theProtocol method:method];
    }
}

- (void)checkProtocol:(Protocol *)theProtocol
{
    if (!theProtocol)
    {
        @throw [NSException exceptionNoProtocol];
    }
    else if (!protocol_conformsToProtocol(theProtocol, @protocol(OCFAutoInjectProtocol)))
    {
        @throw [NSException exceptionInvalidProtocol:theProtocol];
    }
}

@end
