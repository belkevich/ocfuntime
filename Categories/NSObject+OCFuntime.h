//
//  NSObject+OCFuntime.h
//  OCFuntime
//
//  Created by Alexey Belkevich on 12/2/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (OCFuntime)

- (void)changeMethod:(SEL)method implementation:(id)block;
+ (void)changeMethod:(SEL)method implementation:(id)block;
- (void)revertMethod:(SEL)method;
+ (void)revertMethod:(SEL)method;
- (void)revertMethods;
+ (void)revertMethods;

@end
