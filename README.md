OCFuntime
============

### About
[![Build Status](https://travis-ci.org/belkevich/ocfuntime.png?branch=develop)](https://travis-ci.org/belkevich/ocfuntime)

OCFuntime is a toolkit for [Objective-C runtime](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/ObjCRuntimeRef/Reference/reference.html).

#### Features
* Change instance or class method implementation and revert it back
* Inject property of any type to any class
* Modular structure: each task extracted as [Cocoapods](http://cocoapods.org/) [subspec](http://guides.cocoapods.org/syntax/podspec.html#subspec)

## Change method implementation
Method implementation changing allows to run block of code on corresponding method call. Don't be confused with [method swizzling](http://nshipster.com/method-swizzling/).

Instance method implementation block should conform signature:
```objective-c
method_return_type ^(id selfInstance, arg1_type arg1, arg2_type arg2, ...)
```
Class method implementation block should conform signature:
```objective-c
method_return_type ^(Class theClass, arg1_type arg1, arg2_type arg2, ...)
```

**Installation**

Add `pod 'OCFuntime/Methods'` to [Podfile](http://guides.cocoapods.org/using/the-podfile.html)

**Example**
```objective-c
@interface MyClass : NSObject
- (void)someInstanceMethod:(NSObject *)someArg;
+ (NSInteger)someClassMethod;
@end
```

```objective-c
#import "OCFuntime+Methods.h"
...
OCFuntime *funtime = [[OCFuntime alloc] init];
// Change instance method implementation
[funtime changeClass:MyClass.class instanceMethod:@selector(someInstanceMethod:)
      implementation:^(MyClass *instance, NSObject *someArg)
{
   NSLog(@"Changed instance method with arg %@!", someArg);
}];
// Change class method implementation
[funtime changeClass:MyClass.class classMethod:@selector(someClassMethod)
      implementation:^(Class theClass)
{
    NSLog(@"Changed class method of %@!", NSStringFromClass(theClass));
    return 5;
}];
//Revert method to default implementation
[funtime revertClass:MyClass.class instanceMethod:@selector(someInstanceMethod)];
[funtime revertClass:MyClass.class classMethod:@selector(someClassMethod)];
// Revert all methods of class to default implementation
[funtime revertClassMethods:MyClass.class];
// Revert all changed methods to default implementation
[funtime revertAllMethods];
```
**Notes**
* Skip arguments in implementation block signature if you don't need them.
* Skipping value return will cause undefined behaviour.
* After `OCFuntime` instance will be deallocated all changed methods will be reverted to default implementations. To avoid it use [Shared Instance](https://github.com/belkevich/ocfuntime#other) of `OCFuntime`.
* Changing unexisted method will rise an exception.
* Changing implementation isn't thread safe.

**NSObject Category**

Run method implementation changing on corresponding class with `NSObject` category.

Add `pod 'OCFuntime/NSObject+OCFMethods'` to [Podfile](http://guides.cocoapods.org/using/the-podfile.html)
```objective-c
#import "NSObject+OCFMethods.h"
...
// Change class method implementation
[MyClass changeClassMethod:@selector(someClassMethod) implementation:^
{
    NSLog(@"Changed 'someClassMethod'");
    return 0;
}];
// Change instance method implementation
[MyClass changeInstanceMethod:@selector(someInstanceMethod)
               implementation:^(MyClass *instance, NSObject *someArg)
{
    NSLog(@"Called changed method of %@ with arg %@", instance, someArg);
}];
// Revert class method implementation
[MyClass revertClassMethod:@selector(someStaticMethod)];
// Revert instance method implementation
[MyClass revertInstanceMethod:@selector(someMethod)];
// Revert all methods
[MyClass revertMethods];
```
`NSObject+OCFMethods` subspec includes `Methods` and `Shared` subspecs as dependencies. Don't include them to Podfile.

## Inject property
Property injection allow to use `@dynamic` properties as it've been `@synthesize`.
And it's the best way to avoid *"no synthesized properties in objective-c categories"* restriction.
Injection is based on [Message Forwarding](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtForwarding.html) and [Associated Objects](http://nshipster.com/associated-objects/).

**Installation**

Add `pod 'OCFuntime/Properties'` to [Podfile](http://guides.cocoapods.org/using/the-podfile.html)

**Example**
```objective-c
@interface SomeClass : NSObject
@property (nonatomic, strong) id objectStrongProperty;
@property (nonatomic, assign) NSInteger integerProperty;
@end
...
@implementation
@dynamic objectStrongProperty, integerProperty;
@end
...
```

```objective-c
#import "OCFuntime+Properties.h"
#import "SomeClass.h"
...
// Inject properties
OCFuntime *funtime = [[OCFuntime alloc] init];
[funtime injectClass:SomeClass.class property:@"objectStrongProperty"];
[funtime injectClass:SomeClass.class property:@"integerProperty"];
// Use properties
SomeClass *someInstance = [[SomeClass alloc] init];
someInstance.objectStrongProperty = [[NSObject alloc] init];
someInstance.integerProperty = 5;
// Remove injected property
[funtime removeClass:SomeClass.class property:@"objectStrongProperty"];
// Remove all class injected properties
[funtime removeClassProperties:SomeClass.class];
// Remove all injected properties
[funtime removeAllProperties];
```

**Notes**
* `atomic` properties injected as `nonatomic`. It's will be fixed in one of the next releases.
* After `OCFuntime` instance will be deallocated all injected properties will be removed. To avoid it use [Shared Instance](https://github.com/belkevich/ocfuntime#other) of `OCFuntime`.
* If property doesn't defined in class interface exception will raise.
* If property synthesized or already injected exception will raise.
* Property injection doesn't break methods `forwardInvocation:` and `methodSignatureForSelector:` because of [Swizzling](http://nshipster.com/method-swizzling/).
* Property injection isn't thread safe.

**NSObject Category**

Run property injection on corresponding class with `NSObject` category.

Add `pod 'OCFuntime/NSObject+OCFProperties'` to [Podfile](http://guides.cocoapods.org/using/the-podfile.html)
```objective-c
#import "NSObject+OCFProperties.h"
...
// Inject properties
[SomeClass injectProperty:@"objectStrongProperty"];
[SomeClass injectProperty:@"integerProperty"];
// Remove property
[SomeClass removeProperty:@"objectStrongProperty"];
// Remove all injected properties of class
[SomeClass removeProperties];
```
`NSObject+OCFProperties` subspec includes `Properties` and `Shared` subspecs as dependencies. Don't include them to Podfile.

## Other

**Shared instance**

Add `pod 'OCFuntime/Shared'` to [Podfile](http://guides.cocoapods.org/using/the-podfile.html)
```objective-c
#import "OCFuntime+Shared.h"
...
[OCFuntime.shared changeClass:MyClass.class
               instanceMethod:@selector(someMethod)]
               implementation:^
{
    NSLog(@"Changed someMethod with shared instance")
}];
```

**Default subspec**

Default subspec `pod 'OCFuntime'` includes all subspecs. Use `@import "OCFuntimeHeader.h"` to enable all features of `OCFuntime`.

## Changes
Follow updates [@okolodev](https://twitter.com/okolodev)

**Change log**

*0.2.0*
* Added property injection
* Refactored to modular structure

*0.1.1*
* Added reverting to default method implementations on OCFuntime instance deallocation

*0.1.0*
* Added exception if changed method doesn't exist in the class
* Fixed reverting to default method implementation, not previous implementation
* Fixed changing class and instance method with the same name
* Fixed setting empty implementations
* Converted to ARC
