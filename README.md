OCFuntime
============
---
# About
OCFuntime is a simple wrapper on [Objective-C runtime](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/ObjCRuntimeRef/Reference/reference.html). So if you don't know the easiest way to shot your both legs then this solution for you! Time to have a fun! 

# Using
**Create funtime instance**
```objective-c
OCFuntime *funtime = [[OCFuntime alloc] init];
```

**Change instance method implementation**
```objective-c
[funtime changeClass:[MyClass class] instanceMethod:@selector(instanceMethod) implementation:^
{
   NSLog(@"Changed FUN instance method!");
}];
```

**Change class method implementation**
```objective-c
[funtime changeClass:[MyClass class] classMethod:@selector(classMethod) implementation:^
{
    NSLog(@"Changed FUN class method!");
}];
```

**Revert method to default implementation**
```objective-c
[funtime revertClass:[MyClass class] method:@selector(method)];
```

**Revert all methods of class to default implementation**
```objective-c
[funtime revertClass:[MyClass class]];
```

**Revert all changed methods to default implementation**
```objective-c
[funtime revertAll];
```

# Spec
[Specs here](https://github.com/belkevich/ocfuntimespec)
