//
//  UIGestureRecognizer+Track.m
// LZDataTrackerDemo
//
//  Created by plz on 2020/7/28.
//  Copyright © 2020 plz. All rights reserved.
//

#import "UIGestureRecognizer+Track.h"
#import "LZDataTrackKit.h"
#import <objc/runtime.h>

@implementation UIGestureRecognizer (Track)

- (void)setMethodName:(NSString *)methodName {
    objc_setAssociatedObject(self, @selector(methodName), methodName, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)methodName {
   return objc_getAssociatedObject(self, @selector(methodName));
}

+(void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSel = @selector(initWithTarget:action:);
        SEL swizzingSel = @selector(hg_initWithTarget:action:);
        [LZMethodSwizzingTool swizzingForClass:[self class] originalSel:originalSel swizzingSel:swizzingSel];
    });
}

- (instancetype)hg_initWithTarget:(nullable id)target action:(nullable SEL)action {
    UIGestureRecognizer *recognizer = [self hg_initWithTarget:target action:action];

    if (!target && !action) {
        return recognizer;
    }
    
    if ([target isKindOfClass:[UIScrollView class]]) {
        return recognizer;
    }
    
    Class cls = [target class];
    SEL sel = action;
    
    NSString *selName = [NSString stringWithFormat:@"%s/%@",class_getName(cls),NSStringFromSelector(sel)];
    SEL swizzingSel = NSSelectorFromString(selName);
    BOOL addMethod = class_addMethod(cls, swizzingSel, method_getImplementation(class_getInstanceMethod([self class], @selector(hg_responseUsergesture:))), nil);
    self.methodName = NSStringFromSelector(sel);

    if (addMethod) {
        Method originalMethod = class_getInstanceMethod(cls, sel);
        Method swizzingMethod = class_getInstanceMethod(cls, swizzingSel);
        method_exchangeImplementations(originalMethod, swizzingMethod);
    }

    return recognizer;
}

- (void)hg_responseUsergesture:(UIGestureRecognizer *)gesture {
    NSString *identifier = [NSString stringWithFormat:@"%s/%@", class_getName([self class]),gesture.methodName];
    SEL sel = NSSelectorFromString(identifier);
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL,id) = (void *)imp;
        func(self, sel,gesture);
    }

    //埋点实现区域====
    NSDictionary *eventDict = [[[LZDataTrackTool shareInstance].trackData objectForKey:@"Gesture"] objectForKey:identifier];
    if (eventDict) {
        NSDictionary *useDefind = [eventDict objectForKey:@"userDefined"];
        //预留参数配置，以后拓展
        NSDictionary *param = [eventDict objectForKey:@"eventParam"];
        __block NSMutableDictionary *eventParam = [NSMutableDictionary dictionaryWithCapacity:0];
        [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            //在此处进行属性获取
            id value = [LZCaptureTool captureVarforInstance:self varName:key];
            if (key && value) {
                [eventParam setObject:value forKey:key];
            }
        }];
        
        NSLog(@"identifier:%@-------useDefind：%@----eventParam：%@",identifier,useDefind,eventParam);
    }
}

@end
