//
//  UITextField+CQLengthLimit.m
//  CQPayedDemo
//
//  Created by 李超群 on 2019/8/10.
//  Copyright © 2019 wwdx. All rights reserved.
//

#import "UITextField+CQLengthLimit.h"
#import <objc/runtime.h>
#import <objc/message.h>

static const void *limitLengthKey = &limitLengthKey;
static const void *textLengthMoreThanBlockKey = &textLengthMoreThanBlockKey;

@implementation UITextField (CQLengthLimit)
#pragma mark - Setter/Getter
- (NSNumber *)limitLength {
    return objc_getAssociatedObject(self, limitLengthKey);
}

- (void)setLimitLength:(NSNumber *)limitLength {
    objc_setAssociatedObject(self, limitLengthKey, limitLength, OBJC_ASSOCIATION_COPY_NONATOMIC);
    
    [self addTarget:self action:@selector(textFieldTextDidChange) forControlEvents:UIControlEventEditingChanged];
}

- (TextLengthMoreThanBlock)lenghtBlock {
    return objc_getAssociatedObject(self, textLengthMoreThanBlockKey);
}

- (void)setLenghtBlock:(TextLengthMoreThanBlock)lenghtBlock {
    objc_setAssociatedObject(self, textLengthMoreThanBlockKey, lenghtBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void)textFieldTextDidChange {
    if (self.text.length >= self.limitLength.intValue) {
        self.text = [self.text substringToIndex:self.limitLength.intValue];
        
        if (self.lenghtBlock) {
            self.lenghtBlock();
        }
    }
}

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        
        SEL origSelector = NSSelectorFromString(@"dealloc");
        SEL newSelector = @selector(cq_dealloc);
        Method origMethod = class_getInstanceMethod(class, origSelector);
        Method newMethod = class_getInstanceMethod(class, newSelector);
        method_exchangeImplementations(origMethod, newMethod);
        
        BOOL success = class_addMethod(class, origSelector, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
        if (success) {
            class_replaceMethod(class, newSelector, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
        } else {
            method_exchangeImplementations(origMethod, newMethod);
        }
    });

}

- (void)cq_dealloc {
    // do your logic here
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:self];
    
    //this calls original dealloc method
    [self cq_dealloc];
}

@end
