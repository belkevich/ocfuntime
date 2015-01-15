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
- (void)removeProtocol:(Protocol *)theProtocol method:(SEL)method;
- (void)removeProtocol:(Protocol *)theProtocol;

@end
