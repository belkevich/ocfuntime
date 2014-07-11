//
//  NSString+ASCIIString.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 1/21/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "NSString+ASCIIString.h"

@implementation NSString (ASCIIString)

- (const char *)ASCIIString
{
    return [self cStringUsingEncoding:NSASCIIStringEncoding];
}

@end
