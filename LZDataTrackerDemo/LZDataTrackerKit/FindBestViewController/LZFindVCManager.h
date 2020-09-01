//
// LZFindVCManager.h
// LZSmallSpace
//
//  Created by plz on 2019/12/19.
//  Copyright © 2019 Apple Inc. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZFindVCManager : NSObject

/**
 获取当前控制器

 @return 当前控制器
 */
+ (UIViewController *)currentViewController;

/**
 寻找上层控制器

 @param vc 控制器
 @return 上层控制器
 */
+ (UIViewController *)findBestViewController:(UIViewController *)vc;

@end

NS_ASSUME_NONNULL_END
