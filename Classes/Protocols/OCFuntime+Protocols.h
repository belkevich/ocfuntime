//
//  OCFuntime+Protocols.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/15/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import "OCFuntime.h"

@interface OCFuntime (Protocols)

- (void)injectProtocol:(Protocol *)theProtocol method:(SEL)method implementaion:(id)implementation;
- (void)removeInjectedProtocol:(Protocol *)theProtocol method:(SEL)method;
- (void)removeInjectedProtocol:(Protocol *)theProtocol;

@end
