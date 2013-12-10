//
//  OCFClassMethods.h
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCFClassMethods : NSObject
{
@private
    Class theClass;
    NSMutableDictionary *instanceMethods;
    NSMutableDictionary *classMethods;
}

// initialization
- (id)initWithClass:(Class)theClass;
// actions
- (void)changeInstanceMethod:(SEL)selector implementationWithBlock:(id)block;
- (void)changeClassMethod:(SEL)selector implementationWithBlock:(id)block;
- (void)revertInstanceMethod:(SEL)selector;
- (void)revertClassMethod:(SEL)selector;
- (void)revertAllToDefaultImplementation;

@end