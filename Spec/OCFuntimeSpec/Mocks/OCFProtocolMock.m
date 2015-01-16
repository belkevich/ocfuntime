//
//  OCFProtocolMock.m
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/15/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import "OCFProtocolMock.h"

@implementation OCFProtocolMock

- (BOOL)implementedMethod
{
    return NO;
}

- (BOOL)implementedMethodToOverride
{
    return NO;
}

+ (BOOL)implementedMethod
{
    return NO;
}

+ (BOOL)implementedMethodToOverride
{
    return NO;
}

- (void)requiredMethod
{

}


@end
