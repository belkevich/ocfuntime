//
//  OCFMethodInjector.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/2/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCFMethodInjector : NSObject

+ (BOOL)injectClass:(Class)theClass classMethod:(SEL)method types:(const char *)types
              block:(id)block;
+ (BOOL)injectClass:(Class)theClass instanceMethod:(SEL)method types:(const char *)types
              block:(id)block;

@end
