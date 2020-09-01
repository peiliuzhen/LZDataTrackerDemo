//
//  UICollectionView+Track.m
// LZDataTrackerDemo
//
//  Created by plz on 2020/7/28.
//  Copyright © 2020 plz. All rights reserved.
//

#import "UICollectionView+Track.h"
#import "LZDataTrackKit.h"
#import <objc/runtime.h>

@implementation UICollectionView (Track)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originSelector  = @selector(setDelegate:);
        SEL swizzingSelector = @selector(hg_setDelegate:);
        [LZMethodSwizzingTool swizzingForClass:[self class] originalSel:originSelector swizzingSel:swizzingSelector];
    });
}

- (void)hg_setDelegate:(id<UICollectionViewDelegate>)delegate {
    [self hg_setDelegate:delegate];
    
    SEL originalSel = @selector(collectionView:didSelectItemAtIndexPath:);
    SEL swizzingSel = NSSelectorFromString([NSString stringWithFormat:@"%@%@", NSStringFromClass([delegate class]),@(self.tag)]);
    
    //didSelectItemAtIndexPath不一定要实现，未实现在跳过
    if (![LZCaptureTool isContainSel:originalSel class:[delegate class]]) {
        return;
    }
    
    BOOL addMethod = class_addMethod([delegate class], swizzingSel, method_getImplementation(class_getInstanceMethod([self class], @selector(hg_collectionView:didSelectItemAtIndexPath:))), nil);
    if (addMethod) {
        Method originalMetod = class_getInstanceMethod([delegate class], originalSel);
        Method swizzingMethod = class_getInstanceMethod([delegate class], swizzingSel);
        method_exchangeImplementations(originalMetod, swizzingMethod);
    }
}

- (void)hg_collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = [NSString stringWithFormat:@"%@/%@", NSStringFromClass([self class]),@(collectionView.tag)];
    SEL sel = NSSelectorFromString(identifier);
    if ([self respondsToSelector:sel]) {
        IMP imp = [self methodForSelector:sel];
        void (*func)(id, SEL,id,id) = (void *)imp;
        func(self, sel,collectionView,indexPath);
    }
    
    //埋点实现区域====
    NSDictionary *eventDict = [[[LZDataTrackTool shareInstance].trackData objectForKey:@"CollectionView"] objectForKey:identifier];
    if (eventDict) {
        NSDictionary *useDefind = [eventDict objectForKey:@"userDefined"];
        //预留参数配置，以后拓展
        NSDictionary *param = [eventDict objectForKey:@"eventParam"];
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        __block NSMutableDictionary *eventParam = [NSMutableDictionary dictionaryWithCapacity:0];
        [eventParam setValue:@(indexPath.section) forKey:@"section"];
        [eventParam setValue:@(indexPath.item) forKey:@"item"];
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
        
        NSString *eventName = [eventDict objectForKey:@"EventName"];
        
        NSLog(@"identifier:%@-------useDefind：%@----eventParam：%@",identifier,useDefind,eventParam);
    }
}

@end
