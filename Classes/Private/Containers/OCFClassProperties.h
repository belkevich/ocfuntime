//
//  OCFClassProperties.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 12/10/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface OCFClassProperties : NSObject

- (id)initWithClass:(Class)theClass;
- (void)synthesizeProperty:(NSString *)propertyName;

@end
