//
//  CQKVOCustomized.h
//  CQPayedDemo
//
//  Created by 李超群 on 2019/8/7.
//  Copyright © 2019 wwdx. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CQKVOCustomized : NSObject

@property(nonatomic,copy)NSString *name;
- (void)cq_addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(nullable void *)context;
@end

NS_ASSUME_NONNULL_END
