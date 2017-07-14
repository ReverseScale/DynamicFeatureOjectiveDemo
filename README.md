# DynamicFeatureOjectiveDemo

一个简单的小Demo，领略下Objective-C的运行时(runtime)，同时解释是什么让Objective-C如此动态，然后感受下这些动态化的技术细节。希望这回让你对Objective-C和Cocoa是如何运行的有更好的了解。

| 名称 |1.列表页 |2.展示页 |
| ------------- | ------------- | ------------- |
| 截图 | ![](http://og1yl0w9z.bkt.clouddn.com/17-7-6/25202104.jpg) | ![](http://og1yl0w9z.bkt.clouddn.com/17-7-6/97981882.jpg) |
| 描述 | 通过 storyboard 搭建基本框架 | 使用DynamicFeature实现 |

## Advantage 框架的优势
* 1.基于系统原生环境实现
* 2.生动活泼的学习体验
* 3.同时使用类方法、动态便利isa遍历等知识点

## Requirements 要求
* iOS 7+
* Xcode 8+

## The Runtime 简介

Objective-C是一门简单的语言，95%是C。只是在语言层面上加了些关键字和语法。真正让Objective-C如此强大的是它的运行时。它很小但却很强大。它的核心是消息分发。

### Messages

如果你是从动态语言如Ruby或Python转过来的，可能知道什么是消息，可以直接跳过进入下一节。那些从其他语言转过来的，继续看。

执行一个方法，有些语言，编译器会执行一些额外的优化和错误检查，因为调用关系很直接也很明显。但对于消息分发来说，就不那么明显了。在发消息前不必知道某个对象是否能够处理消息。你把消息发给它，它可能会处理，也可能转给其他的Object来处理。一个消息不必对应一个方法，一个对象可能实现一个方法来处理多条消息。

在Objective-C中，消息是通过objc_msgSend()这个runtime方法及相近的方法来实现的。这个方法需要一个target，selector，还有一些参数。理论上来说，编译器只是把消息分发变成objc_msgSend来执行。比如下面这两行代码是等价的。

```
[array insertObject:foo atIndex:5];
objc_msgSend(array, @selector(insertObject:atIndex:), foo, 5);
```
### Objects, Classes, MetaClasses

大多数面向对象的语言里有 classes 和 objects 的概念。Objects通过Classes生成。但是在Objective-C中，classes本身也是objects(译者注：这点跟python很像)，也可以处理消息，这也是为什么会有类方法和实例方法。具体来说，Objective-C中的Object是一个结构体(struct)，第一个成员是isa，指向自己的class。这是在objc/objc.h中定义的。

```
typedef struct objc_object {
    Class isa;
} *id;
```

object的class保存了方法列表，还有指向父类的指针。但classes也是objects，也会有isa变量，那么它又指向哪儿呢？这里就引出了第三个类型: metaclasses。一个 metaclass被指向class，class被指向object。它保存了所有实现的方法列表，以及父类的metaclass。

### Methods, Selectors and IMPs

我们知道了运行时会发消息给对象。我们也知道一个对象的class保存了方法列表。那么这些消息是如何映射到方法的，这些方法又是如何被执行的呢？

第一个问题的答案很简单。class的方法列表其实是一个字典，key为selectors，IMPs为value。一个IMP是指向方法在内存中的实现。很重要的一点是，selector和IMP之间的关系是在运行时才决定的，而不是编译时。这样我们就能玩出些花样。

IMP通常是指向方法的指针，第一个参数是self，类型为id，第二个参数是_cmd，类型为SEL，余下的是方法的参数。这也是self和_cmd被定义的地方。下面演示了Method和IMP。

```
- (id)doSomethingWithInt:(int)aInt{}
id doSomethingWithInt(id self, SEL _cmd, int aInt){}
```

### 动态方法处理

目前为止，我们讨论了方法交换，以及已有方法的处理。那么当你发送了一个object无法处理的消息时会发生什么呢？很明显，”it breaks”。大多数情况下确实如此，但Cocoa和runtime也提供了一些应对方法。

首先是动态方法处理。通常来说，处理一个方法，运行时寻找匹配的selector然后执行之。有时，你只想在运行时才创建某个方法，比如有些信息只有在运行时才能得到。要实现这个效果，你需要重写+resolveInstanceMethod:和/或 +resolveClassMethod:。如果确实增加了一个方法，记得返回YES。

```
+ (BOOL)resolveInstanceMethod:(SEL)aSelector {
    if (aSelector == @selector(myDynamicMethod)) {
        class_addMethod(self, aSelector, (IMP)myDynamicIMP, "v@:");
        return YES;
    }
    return [super resolveInstanceMethod:aSelector];
}
```
那Cocoa在什么场景下会使用这些方法呢？Core Data用得很多。NSManagedObjects有许多在运行时添加的属性用来处理get/set属性和关系。那如果Model在运行时被改变了呢？

## Demo 演示步骤
### 第一步 在 Example 示例动物中选择一个，点击“activation”
下面的提示语会变成对应动物的叫声。
同时，开启回话栏。

### 第二步 在对话栏的输入框下输入whats+示例动物名（小写），点击“Send”
系统会回复当前动物的回话并展示动物图片。

使用简单、效率高效、进程安全~~~如果你有更好的建议,希望不吝赐教!
### 你的star是我持续更新的动力!

## License 许可证
DynamicFeatureOjectiveDemo 使用 MIT 许可证，详情见 LICENSE 文件。


## Contact 联系方式:
* WeChat : WhatsXie
* Email : ReverseScale@iCloud.com
* Blog : https://reversescale.github.io
