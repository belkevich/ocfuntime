//
//  OCFPropertiesUnit.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/9/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCFUnitProtocol.h"

@interface OCFPropertiesUnit : NSObject <OCFUnitProtocol>

- (void)injectClass:(Class)theClass property:(NSString *)propertyName;
- (void)removeClass:(Class)theClass property:(NSString *)propertyName;
- (void)removeClassProperties:(Class)theClass;
- (void)removeAllProperties;

@end
