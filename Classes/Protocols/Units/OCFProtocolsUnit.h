//
//  OCFProtocolsUnit.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/15/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCFProtocolsUnit : NSObject

- (void)forceInject:(BOOL)force protocol:(Protocol *)theProtocol classMethod:(SEL)method implementaion:(id)implementation;
- (void)forceInject:(BOOL)force protocol:(Protocol *)theProtocol instanceMethod:(SEL)method implementaion:(id)implementation;

@end
