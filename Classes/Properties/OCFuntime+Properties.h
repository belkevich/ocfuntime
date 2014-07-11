//
//  OCFuntime+Properties.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/10/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import "OCFuntime.h"

@interface OCFuntime (Properties)

- (void)injectClass:(Class)theClass property:(NSString *)propertyName;
- (void)removeClass:(Class)theClass property:(NSString *)propertyName;
- (void)removeClassProperties:(Class)theClass;
- (void)removeAllProperties;

@end
