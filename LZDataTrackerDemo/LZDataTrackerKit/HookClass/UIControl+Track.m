//
//  UIControl+Track.m
// LZDataTrackerDemo
//
//  Created by plz on 2020/7/28.
//  Copyright © 2020 plz. All rights reserved.
//

#import "UIControl+Track.h"
#import "LZDataTrackKit.h"


@implementation UIControl (Track)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzingSelector = @selector(hg_sendAction:to:forEvent:);
        [LZMethodSwizzingTool swizzingForClass:[self class] originalSel:originalSelector swizzingSel:swizzingSelector];
    });
}

- (void)hg_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event {
    [self hg_sendAction:action to:target forEvent:event];
    
    //埋点实现区域====
    //页面/方法名/tag用来区分不同的点击事件
    NSString *identifier = [NSString stringWithFormat:@"%@/%@/%@", [target class], NSStringFromSelector(action),@(self.tag)];
    if ([target isKindOfClass:[UIView class]]) {
        UIView *view = (id)[target superview];
        while (view.nextResponder) {
            identifier =[NSString stringWithFormat:@"%@/%@",NSStringFromClass(view.class),identifier];
            if ([view.class isSubclassOfClass:[UIViewController class]]) {
                break;
            }
            view = (id)view.nextResponder;
        }
    }
    
    NSDictionary *eventDict = [[[LZDataTrackTool shareInstance].trackData objectForKey:@"Action"] objectForKey:identifier];
    if (eventDict) {
        NSDictionary *useDefind = [eventDict objectForKey:@"userDefined"];
        //预留参数配置，以后拓展
        NSDictionary *param = [eventDict objectForKey:@"eventParam"];
        __block NSMutableDictionary *eventParam = [NSMutableDictionary dictionaryWithCapacity:0];
        [param enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            //在此处进行属性获取
            id value = [LZCaptureTool captureVarforInstance:target varName:key];
            if (key && value) {
                [eventParam setObject:value forKey:key];
            }
        }];
                
        NSLog(@"useDefind：%@----eventParam：%@",useDefind,eventParam);
    }
}

// UIView 分类
- (NSString *)obtainSameSuperViewSameClassViewTreeIndexPat
{
    NSString *classStr = NSStringFromClass([self class]);
    //cell的子view
    //UITableView 特殊的superview (UITableViewContentView)
    //UICollectionViewCell
    BOOL shouldUseSuperView =
    ([classStr isEqualToString:@"UITableViewCellContentView"]) ||
    ([[self.superview class] isKindOfClass:[UITableViewCell class]])||
    ([[self.superview class] isKindOfClass:[UICollectionViewCell class]]);
    if (shouldUseSuperView) {
        return [self obtainIndexPathByView:self.superview];
    }else {
        return [self obtainIndexPathByView:self];
    }
}

- (NSString *)obtainIndexPathByView:(UIView *)view
{
    NSInteger viewTreeNodeDepth = NSIntegerMin;
    NSInteger sameViewTreeNodeDepth = NSIntegerMin;
    
    NSString *classStr = NSStringFromClass([view class]);
   
    NSMutableArray *sameClassArr = [[NSMutableArray alloc]init];
    //所处父view的全部subviews根节点深度
    for (NSInteger index =0; index < view.superview.subviews.count; index ++) {
        //同类型
        if  ([classStr isEqualToString:NSStringFromClass([view.superview.subviews[index] class])]){
            [sameClassArr addObject:view.superview.subviews[index]];
        }
        if (view == view.superview.subviews[index]) {
            viewTreeNodeDepth = index;
            break;
        }
    }
    //所处父view的同类型subviews根节点深度
    for (NSInteger index =0; index < sameClassArr.count; index ++) {
        if (view == sameClassArr[index]) {
            sameViewTreeNodeDepth = index;
            break;
        }
    }
    return [NSString stringWithFormat:@"%ld",sameViewTreeNodeDepth];
    
}


@end
