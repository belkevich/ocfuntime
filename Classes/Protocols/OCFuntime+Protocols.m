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

- (void)injectProtocol:(Protocol *)theProtocol classMethod:(SEL)method implementaion:(id)implementation
{
    OCFProtocolsUnit *unit = (OCFProtocolsUnit *)[self unitOfClass:OCFProtocolsUnit.class];
    [unit forceInject:NO protocol:theProtocol classMethod:method implementaion:implementation];
}

- (void)injectProtocol:(Protocol *)theProtocol instanceMethod:(SEL)method implementaion:(id)implementation
{
    OCFProtocolsUnit *unit = (OCFProtocolsUnit *)[self unitOfClass:OCFProtocolsUnit.class];
    [unit forceInject:NO protocol:theProtocol instanceMethod:method implementaion:implementation];
}

- (void)forceInjectProtocol:(Protocol *)theProtocol classMethod:(SEL)method implementaion:(id)implementation
{
    OCFProtocolsUnit *unit = (OCFProtocolsUnit *)[self unitOfClass:OCFProtocolsUnit.class];
    [unit forceInject:YES protocol:theProtocol classMethod:method implementaion:implementation];
}

- (void)forceInjectProtocol:(Protocol *)theProtocol instanceMethod:(SEL)method implementaion:(id)implementation
{
    OCFProtocolsUnit *unit = (OCFProtocolsUnit *)[self unitOfClass:OCFProtocolsUnit.class];
    [unit forceInject:YES protocol:theProtocol instanceMethod:method implementaion:implementation];
}

@end
