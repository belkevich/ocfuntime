//
//  OCFProtocolsUnit.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/15/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCFProtocolsUnit : NSObject

- (void)injectProtocol:(Protocol *)theProtocol method:(SEL)method implementaion:(id)implementation;
- (void)removeInjectedProtocol:(Protocol *)theProtocol method:(SEL)method;
- (void)removeInjectedProtocolMethods:(Protocol *)theProtocol;

@end
