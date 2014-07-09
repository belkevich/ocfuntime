//
//  NSObject+OCFuntimeSwizzling.h
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
@end

@interface NSObject (OCFuntimeSwizzling) <OCFuntimeSwizzling>

@end
