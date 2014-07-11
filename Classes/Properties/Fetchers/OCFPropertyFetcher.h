//
//  OCFPropertyFetcher.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/3/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface OCFPropertyFetcher : NSObject

- (void)fetchAllPropertiesOfClass:(Class)theClass;
- (objc_property_t)findPropertyWithName:(NSString *)propertyName;

@end
