//
// LZCaptureTool.h
// LZDataTrackerDemo
//
//  Created by plz on 2020/8/11.
//  Copyright © 2020 plz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZCaptureTool : NSObject



/**
 根据属性名获取某个对象的对应属性的值
 
 @param instance 持有属性的对象
 @param varName 属性的名字
 @return 属性对应的value
 */
+(id)captureVarforInstance:(id)instance varName:(NSString *)varName;

/**
 利用配置表中的para参数，从指定实例取值

 @param instance 参数的持有者
 @param para 配置表中的pagePara值
 @return 取到的值
 */
+(id)captureVarforInstance:(id)instance withPara:(NSDictionary *)para;

/**
 判断一个类中是否有这个方法
 
 @param sel 方法
 @param cls 类
 */
+ (BOOL)isContainSel:(SEL)sel class:(Class)cls;

/**
 判断一个类是否包含某个属性
 
 @param varName 需要判断的属性
 @param cls 类
 */
+ (BOOL)isContainProperty:(id)varName class:(id)cls;

@end

NS_ASSUME_NONNULL_END
