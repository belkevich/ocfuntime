OCFuntime
============

#### About
[![Build Status](https://travis-ci.org/belkevich/ocfuntime.png?branch=develop)](https://travis-ci.org/belkevich/ocfuntime)

OCFuntime is a toolkit for [Objective-C runtime](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/ObjCRuntimeRef/Reference/reference.html).

**Features**
* Change instance or class method implementation and revert it back
* Inject property of any type to any class

#### Change method implementation
Method implementation changing is very similar to method overriding, but without subclassing.

**Note.** Method implementation changing isn't method swizzling!

Add `pod 'OCFuntime/Methods'` to Podfile
```objective-c
OCFuntime *funtime = [[OCFuntime alloc] init];
// Change instance method implementation
[funtime changeClass:MyClass.class instanceMethod:@selector(someInstanceMethod) 
      implementation:^
{
   NSLog(@"Changed instance method!");
   // return something if need
}];
// Change class method implementation
[funtime changeClass:MyClass.class classMethod:@selector(someClassMethod) 
      implementation:^
{
    NSLog(@"Changed class method!");
    // return something if need
}];
//Revert method to default implementation
[funtime revertClass:MyClass.class instanceMethod:@selector(someInstanceMethod)];
[funtime revertClass:MyClass.class classMethod:@selector(somClassMethod)];
// Revert all methods of class to default implementation
[funtime revertClassMethods:MyClass.class];
// Revert all changed methods to default implementation
[funtime revertAllMethods];
```
**Note.** After `OCFuntime` instance will be deallocated all changed methods will be reverted to default implementations

#### Changes
[@okolodev](https://twitter.com/okolodev)

---

**Version 0.1.1**
* Added reverting to default method implementations on OCFuntime instance deallocation

---

**Version 0.1.0**
* Added exception if changed method doesn't exist in the class
* Fixed reverting to default method implementation, not previous implementation
* Fixed changing class and instance method with the same name
* Fixed setting empty implementations
* Converted to ARC
