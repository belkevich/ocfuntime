//
//  NSException+OCFuntimeMethods.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/9/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSException (OCFuntimeMethods)

+ (instancetype)exceptionNonexistentMethod:(SEL)method inClass:(Class)theClass;

@end
