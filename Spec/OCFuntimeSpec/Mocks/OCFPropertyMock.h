//
//  OCFPropertyMock.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 12/5/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OCFPropertyMockBlock)();

@interface OCFPropertyMock : NSObject

@property (nonatomic, strong) id objectStrongProperty;
@property (nonatomic, weak) id objectWeakProperty;
@property (nonatomic, copy) id objectCopyProperty;
@property (nonatomic, copy) OCFPropertyMockBlock blockProperty;
@property (nonatomic, assign) BOOL booleanProperty;
@property (nonatomic, assign) NSInteger integerProperty;
@property (nonatomic, assign) CGFloat floatProperty;
@property (nonatomic, assign) NSInteger *pIntegerProperty;
@property (nonatomic, assign) CGFloat *pFloatProperty;

@end
