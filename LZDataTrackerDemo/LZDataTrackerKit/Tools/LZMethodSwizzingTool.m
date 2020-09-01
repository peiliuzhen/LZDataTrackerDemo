//
// LZMethodSwizzingTool.m
// LZDataTrackerDemo
//
//  Created by plz on 2020/7/28.
//  Copyright © 2020 plz. All rights reserved.
//

#import "LZMethodSwizzingTool.h"
#import <objc/runtime.h>

@implementation LZMethodSwizzingTool

+ (void)swizzingForClass:(Class)cls originalSel:(SEL)originalSelector swizzingSel:(SEL)swizzingSelector {
    Class class = cls;
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzingMethod = class_getInstanceMethod(class, swizzingSelector);
    BOOL addMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzingMethod), method_getTypeEncoding(swizzingMethod));
    if (addMethod) {
        class_replaceMethod(class, swizzingSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzingMethod);
    }
}

@end
