//
//  Created by Alexey Belkevich on 4/22/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//


#import "OCFMock.h"

@implementation OCFMock

- (BOOL)funInstanceMethod
{
    NSLog(@"This is FUN instance method!");
    return YES;
}

+ (BOOL)funClassMethod
{
    NSLog(@"This is FUN class method!");
    return YES;
}


@end