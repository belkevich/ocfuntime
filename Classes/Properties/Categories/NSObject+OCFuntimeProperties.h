//
//  NSObject+OCFuntimeProperties.h
//  OCFuntime
//
//  Created by Alexey Belkevich on 7/8/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OCFuntimeSwizzling <NSObject>
@optional
- (NSMethodSignature *)OCFMethodSignatureForSelector:(SEL)aSelector;
- (void)OCFForwardInvocation:(NSInvocation *)invocation;
- (id)OCFValueForKeyPath:(NSString *)keyPath;
- (void)OCFSetValue:(id)value forKeyPath:(NSString *)keyPath;
@end

@interface NSObject (OCFuntimeProperties) <OCFuntimeSwizzling>

@end
