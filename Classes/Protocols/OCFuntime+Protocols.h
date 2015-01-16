//
//  OCFuntime+Protocols.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/15/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import "OCFuntime.h"

@interface OCFuntime (Protocols)

- (void)injectProtocol:(Protocol *)theProtocol classMethod:(SEL)method implementaion:(id)implementation;
- (void)injectProtocol:(Protocol *)theProtocol instanceMethod:(SEL)method implementaion:(id)implementation;
- (void)forceInjectProtocol:(Protocol *)theProtocol classMethod:(SEL)method implementaion:(id)implementation;
- (void)forceInjectProtocol:(Protocol *)theProtocol instanceMethod:(SEL)method implementaion:(id)implementation;

@end
