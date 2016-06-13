//
//  OCFAdvancedPropertyMock
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 13.06.16.
//  Copyright © 2016 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

NSString * const kTestSelectorName = @"testSelector";

@interface OCFAdvancedPropertyMock : NSObject

@property (nonatomic, strong) NSObject *someProperty;

@property (nonatomic, readonly) BOOL isMethodSignatureCalled;
@property (nonatomic, readonly) BOOL isForwardInvocationCalled;

@end