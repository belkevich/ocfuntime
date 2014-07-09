//
//  OCFPropertyInjector.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 12/10/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCFPropertyInjector : NSObject

- (id)initWithClass:(Class)theClass;
- (void)injectProperty:(NSString *)propertyName;
- (void)removeProperty:(NSString *)propertyName;
- (void)removeAllProperties;

@end
