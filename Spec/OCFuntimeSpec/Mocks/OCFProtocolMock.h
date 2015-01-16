//
//  OCFProtocolMock.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 1/15/15.
//  Copyright (c) 2015 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "OCFAutoInjectProtocol.h"

@protocol OCFSimpleProtocol <OCFAutoInjectProtocol>
@optional
- (BOOL)instanceMethod;
+ (BOOL)staticMethod;
- (BOOL)implementedMethod;
- (BOOL)implementedMethodToOverride;
+ (BOOL)implementedMethod;
+ (BOOL)implementedMethodToOverride;
@property (nonatomic, assign) BOOL someProperty;
@required
- (void)requiredMethod;
@end

@protocol OCFBadProtocol
@optional
- (void)badMethod;
@end

@interface OCFProtocolMock : NSObject <OCFSimpleProtocol, OCFBadProtocol>

@end
