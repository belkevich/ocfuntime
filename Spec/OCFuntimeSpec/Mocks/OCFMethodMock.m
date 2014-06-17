//
//  OCFMethodMock.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFMethodMock.h"

@implementation OCFMethodMock

- (NSUInteger)funInstanceMethod
{
    NSLog(@"This is FUN instance method!");
    return 0;
}

+ (NSUInteger)funClassMethod
{
    NSLog(@"This is FUN class method!");
    return 0;
}


@end