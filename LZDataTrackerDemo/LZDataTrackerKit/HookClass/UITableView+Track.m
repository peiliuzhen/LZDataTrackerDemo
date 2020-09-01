//
//  UITableView+Track.m
// LZDataTrackerDemo
//
//  Created by plz on 2020/7/28.
//  Copyright © 2020 plz. All rights reserved.
//

#import "UITableView+Track.h"
#import "LZDataTrackKit.h"
#import <objc/runtime.h>

@implementation UITableView (Track)
+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(setDelegate:);
        SEL swizzingSelector = @selector(hg_setDelegate:);
        [LZMethodSwizzingTool swizzingForClass:[self class] originalSel:originalSelector swizzingSel:swizzingSelector];
    });
}

- (void)hg_setDelegate:(id<UITableViewDelegate>)delegate {
    [self hg_setDelegate:delegate];
    
    SEL originalSel = @selector(tableView:didSelectRowAtIndexPath:);
    SEL swizzingSel = NSSelectorFromString([NSString stringWithFormat:@"%@/%@", NSStringFromClass([delegate class]),@(self.tag)]);
    
    //didSelectRowAtIndexPath不一定要实现，未实现在跳过
    if (![LZCaptureTool isContainSel:originalSel class:[delegate class]]) {
        return;
    }
    
    BOOL addMethod = class_addMethod([delegate class], swizzingSel, method_getImplementation(class_getInstanceMethod([self class], @selector(hg_tableView:didSelectRowAtIndexPath:))), nil);
    if (addMethod) {
        Method originalMetod = class_getInstanceMethod([delegate class], originalSel);
        Method swizzingMethod = class_getInstanceMethod([delegate class], swizzingSel);
        method_exchangeImplementations(originalMetod, swizzingMethod);
    }
}

- (void)hg_tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%@/%@", NSStringFromClass([self class]),@(tableView.tag)];
    SEL sel = NSSelectorFromString(identifier);
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL,id,id) = (void *)imp;
        func(self, sel,tableView,indexPath);
    }
    
    //埋点实现区域====
    NSDictionary *eventDict = [[[LZDataTrackTool shareInstance].trackData objectForKey:@"TableView"] objectForKey:identifier];
    if (eventDict) {
        NSDictionary *useDefind = [eventDict objectForKey:@"userDefined"];
        //预留参数配置，以后拓展
        NSDictionary *param = [eventDict objectForKey:@"eventParam"];
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        __block NSMutableDictionary *eventParam = [NSMutableDictionary dictionaryWithCapacity:0];
        [eventParam setValue:@(indexPath.section) forKey:@"section"];
        [eventParam setValue:@(indexPath.row) forKey:@"row"];
        //如果viewcontroller有值则取viewcontroller中的，否则取cell中的
        BOOL isViewController =[eventDict[@"viewcontroller"] boolValue];// [eventDict objectForKey:@"viewcontroller"];
        id instance = isViewController ? self : cell;
        [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            //在此处进行属性获取
            id value = [LZCaptureTool captureVarforInstance:instance varName:key];
            if (key && value) {
                [eventParam setObject:value forKey:key];
            }
        }];

        NSLog(@"identifier:%@-------useDefind：%@----eventParam：%@",identifier,useDefind,eventParam);
    }
}

@end
