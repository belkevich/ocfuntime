//
//  OCFClassProperties.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 12/10/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCFClassProperties : NSObject
{
    Class theClass;
}

- (id)initWithPropertiesClass:(Class)theClass;
- (void)synthesizeProperty:(NSString *)propertyName;

@end
