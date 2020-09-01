//
//  UIViewController+Track.m
// LZDataTrackerDemo
//
//  Created by plz on 2020/7/28.
//  Copyright © 2020 plz. All rights reserved.
//

#import "UIViewController+Track.h"
#import "LZDataTrackKit.h"
#import "LZFindVCManager.h"

@implementation UIViewController (Track)

+ (void)initialize {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalWillAppearSelector = @selector(viewWillAppear:);
        SEL swizzingWillAppearSelector = @selector(hg_viewWillAppear:);
        [LZMethodSwizzingTool swizzingForClass:[self class] originalSel:originalWillAppearSelector swizzingSel:swizzingWillAppearSelector];
        
        SEL originalWillDisappearSel = @selector(viewWillDisappear:);
        SEL swizzingWillDisappearSel = @selector(hg_viewWillDisappear:);
        [LZMethodSwizzingTool swizzingForClass:[self class] originalSel:originalWillDisappearSel swizzingSel:swizzingWillDisappearSel];
        
        SEL originalDidLoadSel = @selector(viewDidLoad);
        SEL swizzingDidLoadSel = @selector(hg_viewDidLoad);
        [LZMethodSwizzingTool swizzingForClass:[self class] originalSel:originalDidLoadSel swizzingSel:swizzingDidLoadSel];
    });
}

- (void)hg_viewWillAppear:(BOOL)animated {
    [self hg_viewWillAppear:animated];
    
    //埋点实现区域
    [self dataTrack:@"viewWillAppear"];
}

- (void)hg_viewWillDisappear:(BOOL)animated {
    [self hg_viewWillDisappear:animated];
    
    //埋点实现区域
    [self dataTrack:@"viewWillDisappear"];
}

- (void)hg_viewDidLoad {
    [self hg_viewDidLoad];
    
    //埋点实现区域
    [self dataTrack:@"viewDidLoad"];
}

- (void)dataTrack:(NSString *)methodName {
    NSString *identifier = [NSString stringWithFormat:@"%@/%@",[[LZFindVCManager currentViewController] class],methodName];
    NSDictionary *eventDict = [[[LZDataTrackTool shareInstance].trackData objectForKey:@"ViewController"] objectForKey:identifier];
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
        if (eventParam.count) {
            NSLog(@"identifier:%@-------useDefind：%@----eventParam：%@",identifier,useDefind,eventParam);
        }
    }
}
@end
