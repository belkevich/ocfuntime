//
//  OCFImplementationSwitcher.h
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface OCFImplementationSwitcher : NSObject

- (id)initWithClass:(Class)theClass instanceMethod:(SEL)selector;
- (id)initWithClass:(Class)theClass classMethod:(SEL)selector;
- (void)changeImplementationWithBlock:(id)block;
- (void)revertImplementation;

@end