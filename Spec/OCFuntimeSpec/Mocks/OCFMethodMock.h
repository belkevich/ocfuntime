//
//  OCFMethodMock.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCFMethodMock : NSObject

- (NSUInteger)funInstanceMethod;
+ (NSUInteger)funClassMethod;
- (NSObject *)funInstanceMethodWithArg:(NSObject *)arg;
+ (NSUInteger)funClassMethodWithArg:(NSUInteger)arg;

@end