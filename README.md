OCFuntime
============

#### About
[![Build Status](https://travis-ci.org/belkevich/ocfuntime.png?branch=develop)](https://travis-ci.org/belkevich/ocfuntime)

OCFuntime is a simple wrapper on [Objective-C runtime](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/ObjCRuntimeRef/Reference/reference.html). So if you don't know the easiest way to shoot off your both legs then this solution for you! Time to have a fun! 

---

#### Features
* Change instance method implementation
* Change class method implementation
* Return value of any type or don't return anything
* Revert to default method implementation

#### Installation
Include `ocfuntime` pod in Podfile

---

#### Using
```objective-c
OCFuntime *funtime = [[OCFuntime alloc] init];
// Change instance method implementation
[funtime changeClass:[MyClass class] instanceMethod:@selector(someInstanceMethod) 
      implementation:^
{
   NSLog(@"Changed FUN instance method!");
   return 1;
}];
// Change class method implementation
[funtime changeClass:[MyClass class] classMethod:@selector(someClassMethod) 
      implementation:^
{
    NSLog(@"Changed FUN class method!");
    return [[NSObject alloc] init];
}];
//Revert method to default implementation
[funtime revertClass:[MyClass class] instanceMethod:@selector(someInstanceMethod)];
[funtime revertClass:[MyClass class] classMethod:@selector(somClassMethod)];
// Revert all methods of class to default implementation
[funtime revertClass:[MyClass class]];
// Revert all changed methods to default implementation
[funtime revertAll];
```

---

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
