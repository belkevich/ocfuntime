//
//  OCFMethodsSwitcher.h
//  OCFuntime
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCFMethodsSwitcher : NSObject

- (instancetype)initWithClass:(Class)theClass;
- (void)changeInstanceMethod:(SEL)selector implementationWithBlock:(id)block;
- (void)changeClassMethod:(SEL)selector implementationWithBlock:(id)block;
- (void)revertInstanceMethod:(SEL)selector;
- (void)revertClassMethod:(SEL)selector;
- (void)revertAllToDefaultImplementation;

@end