//
//  CQKVOCustomized.m
//  CQPayedDemo
//
//  Created by 李超群 on 2019/8/7.
//  Copyright © 2019 wwdx. All rights reserved.
//

#import "CQKVOCustomized.h"
#import <objc/message.h>
#import <objc/runtime.h>

@implementation CQKVOCustomized

void setterMethod(id self, SEL _cmd, NSString *name) {
    // 1.调用父类方法
    struct objc_super superClass = {
        self,
        class_getSuperclass([self class])
    };
    //OBJC_OLD_DISPATCH_PROTOTYPES
    //看到#if !defined这句话就知道，这属于编译选项！在Target -> BuildSetting ->  Apple Clang  。最后在这里找到了设置选项Apple Clang - Preprocessing -> Enable Strict Checking of objc_msgSend Calls
    //把Enable Strict Checking of objc_msgSend Calls 设置为NO之后，我们就可以这样写了：
    objc_msgSendSuper(&superClass, _cmd, name);
    
    // 取出CQKVOCustomized_Person观察者
    id observer = objc_getAssociatedObject(self, (__bridge const void *)@"objc");
    // 2.通知观察者调用- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context// 通知观察者，执行通知方法
    NSString *methodName = NSStringFromSelector(_cmd);
    NSString *key = getValueKey(methodName);
//    unsigned int count;
//    Method *methods = class_copyMethodList([observer class], &count);
//    for (int i = 0; i < count; i++) {
//        Method method = methods[i];
//        SEL selector = method_getName(method);
//        NSString *name = NSStringFromSelector(selector);
//        NSLog(@"method_getName:%@",name);
//    }

    ((void (*) (id, SEL, NSString *, id, NSDictionary *, void *)) (void *)objc_msgSend)(observer, sel_registerName("observeValueForKeyPath:ofObject:change:context:"), key, self, @{key:name}, NULL);
    
//    object_setClass(self, [self class]);
}
NSString *getValueKey(NSString *setter) {
    NSRange range = NSMakeRange(3, setter.length - 4);
    NSString *key = [setter substringWithRange:range];
    NSString *letter = [key substringToIndex:1].lowercaseString;
    key = [key stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:letter];
    return key;
}
- (void)cq_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context {
    //1.创建一个新的类
    NSString *oldClassName = NSStringFromClass([self class]);
    NSString *newClassName = [NSString stringWithFormat:@"CQKVOCustomized_%@", oldClassName];
    Class newClass = objc_getClass(newClassName.UTF8String);
    if (!newClass) {
        newClass = objc_allocateClassPair([self class], newClassName.UTF8String, 0);// 创建类
    }

    objc_registerClassPair(newClass);// 创建后一定要注册
    
    // 修改isa指针
    object_setClass(self, newClass);
    
    //2.重写set方法
    NSString *name = [NSString stringWithFormat:@"set%@:", keyPath.capitalizedString];
    SEL sel = NSSelectorFromString(name);
    class_addMethod(newClass, sel, (IMP)setterMethod, "v@:@");
    objc_setAssociatedObject(self, (__bridge const void *)@"objc", observer, OBJC_ASSOCIATION_ASSIGN);
}

@end
