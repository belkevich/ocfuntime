//
//  NSException+OCFuntimeProtocols.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/15/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSException (OCFuntimeProtocols)

+ (NSException *)exceptionNoProtocol;
+ (NSException *)exceptionNoMethod;
+ (NSException *)exceptionNoImplementation;
+ (NSException *)exceptionInvalidProtocol:(Protocol *)theProtocol;
+ (NSException *)exceptionInvalidProtocol:(Protocol *)theProtocol method:(SEL)method;

@end
