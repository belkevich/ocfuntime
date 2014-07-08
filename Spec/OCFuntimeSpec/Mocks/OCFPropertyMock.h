//
//  OCFPropertyMock.h
//  OCFuntimeSpec
//
//  Created by Alexey Belkevich on 12/5/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^OCFPropertyMockBlock)();

typedef struct
{
    NSInteger x;
    NSInteger y;
} OCFStructMock;

@interface OCFPropertyMock : NSObject

@property (nonatomic, strong) id objectStrongProperty;
@property (nonatomic, weak) id objectWeakProperty;
@property (nonatomic, copy) id objectCopyProperty;
@property (nonatomic, copy) OCFPropertyMockBlock blockProperty;
@property (nonatomic, assign) BOOL booleanProperty;
@property (nonatomic, assign) NSInteger integerProperty;
@property (nonatomic, assign) CGFloat floatProperty;
@property (nonatomic, assign) double doubleProperty;
@property (nonatomic, assign) OCFStructMock structProperty;
@property (nonatomic, assign) NSInteger *pIntegerProperty;
@property (nonatomic, assign) CGFloat *pFloatProperty;

@property (nonatomic, strong) id implementedProperty;
@property (nonatomic, strong) id synthesizedProperty;

@end
