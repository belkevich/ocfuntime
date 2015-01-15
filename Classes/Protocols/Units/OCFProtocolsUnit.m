//
//  OCFProtocolsUnit.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/15/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import <objc/runtime.h>
#import "OCFProtocolsUnit.h"
#import "OCFProtocolMethodsHelper.h"
#import "OCFAutoInjectProtocol.h"
#import "NSException+OCFuntimeProtocols.h"

@implementation OCFProtocolsUnit

#pragma mark - public

- (void)injectProtocol:(Protocol *)theProtocol method:(SEL)method implementaion:(id)implementation
{
    [self checkProtocol:theProtocol method:method implementation:implementation];
}

- (void)removeProtocol:(Protocol *)theProtocol method:(SEL)method
{
    [self checkProtocol:theProtocol method:method];
}

- (void)removeProtocol:(Protocol *)theProtocol
{
    [self checkProtocol:theProtocol];
}

#pragma mark - private


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
