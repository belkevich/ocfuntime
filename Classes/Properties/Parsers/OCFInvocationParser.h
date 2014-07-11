//
//  OCFInvocationParser.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/3/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@class OCFPropertyAttributes;

@interface OCFInvocationParser : NSObject

+ (void)parsePropertyInvocation:(NSInvocation *)invocation onInstance:(id)instance
                 withAttributes:(OCFPropertyAttributes *)attributes;

@end
