//
//  OCFMethodInjector.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/2/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCFMethodInjector : NSObject

+ (void)injectClass:(Class)theClass classMethod:(SEL)method types:(const char *)types
              block:(id)block;
+ (void)injectClass:(Class)theClass instanceMethod:(SEL)method types:(const char *)types
              block:(id)block;
+ (void)swizzleClass:(Class)theClass classMethod:(SEL)originalMethod withMethod:(SEL)swizzledMethod;
+ (void)swizzleClass:(Class)theClass instanceMethod:(SEL)originalMethod
          withMethod:(SEL)swizzledMethod;

@end
