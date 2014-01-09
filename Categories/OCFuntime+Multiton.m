//
//  OCFuntime+Multiton.m
//  OCFuntime
//
//  Created by Alexey Belkevich on 12/2/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "OCFuntime+Multiton.h"
#import "ABMultiton.h"

@implementation OCFuntime (Multiton)

+ (instancetype)sharedInstance
{
    return [ABMultiton sharedInstanceOfClass:self.class];
}


@end
