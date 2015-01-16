//
//  OCFProtocolInjector.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/16/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCFProtocolInjector : NSObject

- (instancetype)initWithProtocol:(Protocol *)theProtocol classes:(NSArray *)classes;
- (void)forceInject:(BOOL)force instance:(BOOL)instance method:(SEL)method implementation:(id)implementation;

@end
