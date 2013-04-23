//
//  OCFMethod.h
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface OCFMethod : NSObject
{
@private
    Method method;
    IMP implementation;
}

// initialization
- (id)initWithClass:(Class)theClass instanceMethod:(SEL)selector;
- (id)initWithClass:(Class)theClass classMethod:(SEL)selector;
+ (id)methodWithClass:(Class)theClass instanceMethod:(SEL)selector;
+ (id)methodWithClass:(Class)theClass classMethod:(SEL)selector;
// actions
- (void)changeImplementationWithBlock:(id)block;
- (void)revertImplementation;

@end