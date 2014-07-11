//
//  NSObject+OCFProperties.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/10/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (OCFProperties)

- (void)injectProperty:(NSString *)propertyName;
- (void)removeProperty:(NSString *)propertyName;
- (void)removeProperties;

@end
