//
//  OCFUnitProtocol.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 7/10/14.
//  Copyright (c) 2014 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol OCFUnitProtocol <NSObject>

@optional
- (void)prepareUnit;
- (void)shutdownUnit;

@end
