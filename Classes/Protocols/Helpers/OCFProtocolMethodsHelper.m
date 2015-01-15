//
//  OCFProtocolMethodsHelper.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/15/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import <objc/runtime.h>
#import "OCFProtocolMethodsHelper.h"

@implementation OCFProtocolMethodsHelper

+ (BOOL)protocol:(Protocol *)theProtocol containsMethod:(SEL)method
{
    struct objc_method_description classMethod = protocol_getMethodDescription(theProtocol, method, NO, NO);
    struct objc_method_description instanceMethod = protocol_getMethodDescription(theProtocol, method, NO, YES);
    return (classMethod.name != NULL && classMethod.types != NULL) ||
     (instanceMethod.name != NULL && instanceMethod.types != NULL);
}

@end
