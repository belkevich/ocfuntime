//
//  OCFClassesFetcher.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/15/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OCFClassesFetcher : NSObject

- (NSArray *)classesConformsToProtocol:(Protocol *)theProtocol;

@end
