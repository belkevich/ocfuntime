//
//  OCFuntime+Protocols.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/15/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import "OCFuntime+Protocols.h"
#import "OCFuntime_Private.h"
#import "OCFProtocolsUnit.h"


@implementation OCFuntime (Protocols)

- (void)injectProtocol:(Protocol *)theProtocol method:(SEL)method implementaion:(id)implementation
{
    OCFProtocolsUnit *unit = (OCFProtocolsUnit *)[self unitOfClass:OCFProtocolsUnit.class];
    [unit injectProtocol:theProtocol method:method implementaion:implementation];
}

- (void)removeInjectedProtocol:(Protocol *)theProtocol method:(SEL)method
{
    OCFProtocolsUnit *unit = (OCFProtocolsUnit *)[self unitOfClass:OCFProtocolsUnit.class];
    [unit removeInjectedProtocol:theProtocol method:method];
}

- (void)removeInjectedProtocol:(Protocol *)theProtocol
{
    OCFProtocolsUnit *unit = (OCFProtocolsUnit *)[self unitOfClass:OCFProtocolsUnit.class];
    [unit removeInjectedProtocolMethods:theProtocol];
}


@end
