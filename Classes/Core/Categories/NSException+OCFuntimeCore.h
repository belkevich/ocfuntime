//
//  NSException+OCFuntimeCore.h
//  OCFuntime
//
//  Created by Alexey Belkevich on 7/8/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSException (OCFuntimeCore)

+ (instancetype)exceptionWithSuffix:(NSString *)suffix reason:(NSString *)reason;

@end
