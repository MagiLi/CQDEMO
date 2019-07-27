//
//  CQRPerson.m
//  CQPayedDemo
//
//  Created by 李超群 on 2019/7/27.
//  Copyright © 2019 wwdx. All rights reserved.
//

#import "CQRPerson.h"
#import "CQRSon.h"
#import "CQRGirl.h"
#import <objc/runtime.h>

@implementation CQRPerson
//- (void)sendMessage:(NSString *)message {
//    NSLog(@"CQRPerson sendMessage:%@", message);
//}
//- (instancetype)init {
//    self = [super init];
//    if (self) {
////        objc_msgS
//    }
//    return self;
//}

void sendMessage(id self, SEL _cmd, NSString *msg){
    NSLog(@"-----> %@", msg);
}
/*
 *  动态方法解析
 *  返回值为 NO，进入下一步处理
 *  返回值为 YES，表示 resolveInstanceMethod 声称它已经提供了 selector 的实现，因此再次查找 method list，如果找到对应的 IMP，则返回该实现，否则提示警告信息，进入下一步处理；
 */
+ (BOOL)resolveInstanceMethod:(SEL)sel {
//    NSString *strMethod = NSStringFromSelector(sel);
//    if ([strMethod isEqualToString:@"sendMessage:"]) {
//        class_addMethod(self, sel, (IMP)sendMessage, "v@:@");
//        return YES;
//    }
    return [super resolveInstanceMethod:sel];
}

/* 消息转发和重定向的区别
 * 1.重定向只能重定向到一个对象，但是消息转发，可以同时对多个对象转发，只需要[anInvocation invokeWithTarget:]多个target即可。
 * 2.重定向的target必须要有一个，如果是nil，则target就是当前实例。消息转发可以不转发，即不调用[anInvocation invokeWithTarget:]，不会crash，但是消息转发的methodSignatureForSelector:方法签名不能返回nil，否则会crash。
 */

/*
 *  重定向
 *  返回nil，即表示不转发给其他对象
 */
- (id)forwardingTargetForSelector:(SEL)aSelector {
    NSString *strMethod = NSStringFromSelector(aSelector);
    if ([strMethod isEqualToString:@"sendMessage:"]) {
        return [[CQRSon alloc] init];
    }
    return [super forwardingTargetForSelector:aSelector];
}

/*  消息转发
 *  1.方法签名
 *  此时系统会根据SEL询问方法签名，即调用methodSignatureForSelector:方法获取方法签名
 *  如果这个方法返回nil，那么就会看到我们最常见的一种
 *  crash -[Class xxx]: unrecognized selector sent to instance ...。
 */
- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSString *strMethod = NSStringFromSelector(aSelector);
    if ([strMethod isEqualToString:@"sendMessage:"]) {
        return [NSMethodSignature signatureWithObjCTypes:"v@:@"];
    }
    return [super methodSignatureForSelector:aSelector];

}
// 2.消息转发
- (void)forwardInvocation:(NSInvocation *)anInvocation {
    SEL sel = [anInvocation selector];
    CQRSon *son = [[CQRSon alloc] init];
    CQRGirl *girl = [[CQRGirl alloc] init];
    if ([son respondsToSelector:sel]) {
        [anInvocation invokeWithTarget:son];
        [anInvocation invokeWithTarget:girl];
    } else {
        [super forwardInvocation:anInvocation];
    }
    
//    [super forwardInvocation:anInvocation];
}

//  没有实现调用的方法
- (void)doesNotRecognizeSelector:(SEL)aSelector {
    CQLog(@"doesNotRecognizeSelector:%@", NSStringFromSelector(aSelector));
}

@end

