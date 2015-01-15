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
- (void)simpleMethodOne;
- (BOOL)simpleMethodTwoWithArgument:(BOOL)argument;
- (BOOL)implementedMethod;
@required
- (void)requiredMethod;
@end

@protocol OCFBadProtocol
@optional
- (void)badMethod;
@end

@interface OCFProtocolMock : NSObject <OCFSimpleProtocol, OCFBadProtocol>

@end
