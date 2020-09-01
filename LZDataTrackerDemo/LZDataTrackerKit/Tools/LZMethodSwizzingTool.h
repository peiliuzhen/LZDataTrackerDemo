//
// LZMethodSwizzingTool.h
// LZDataTrackerDemo
//
//  Created by plz on 2020/7/28.
//  Copyright © 2020 plz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZMethodSwizzingTool : NSObject
/**
 方法交换
 
 @param cls 需要交换的类
 @param originalSelector 原始方法
 @param swizzingSelector 交换后的方法
 */
+ (void)swizzingForClass:(Class)cls originalSel:(SEL)originalSelector swizzingSel:(SEL)swizzingSelector;


@end

NS_ASSUME_NONNULL_END
