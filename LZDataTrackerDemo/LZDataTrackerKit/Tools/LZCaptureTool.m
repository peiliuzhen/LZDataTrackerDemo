//
// LZCaptureTool.m
// LZDataTrackerDemo
//
//  Created by plz on 2020/8/11.
//  Copyright © 2020 plz. All rights reserved.
//

#import "LZCaptureTool.h"
#import <objc/runtime.h>

@implementation LZCaptureTool

+ (id)captureVarforInstance:(id)instance varName:(NSString *)varName {
    id value;
    if ([self isContainProperty:varName class:instance]) {
       value = [instance valueForKey:varName];
    }
    
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([instance class], &count);
    
    if (!value) {
        NSMutableArray *varNameArray = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i < count; i++) {
            objc_property_t property = properties[i];
            NSString *propertyAttributes = [NSString stringWithUTF8String:property_getAttributes(property)];
            NSArray *splitPropertyAttributes = [propertyAttributes componentsSeparatedByString:@"\""];
            if (splitPropertyAttributes.count < 2) {
                continue;
            }
            NSString *className = [splitPropertyAttributes objectAtIndex:1];
            Class cls = NSClassFromString(className);
            NSBundle *bundle2 = [NSBundle bundleForClass:cls];
            if (bundle2 == [NSBundle mainBundle]) {
                //NSLog(@"自定义的类----- %@", className);
                const char *name = property_getName(property);
                NSString *varname = [[NSString alloc] initWithCString:name encoding:NSUTF8StringEncoding];
                [varNameArray addObject:varname];
            } else {
                //NSLog(@"系统的类");
            }
        }
        
        for (NSString *name in varNameArray) {
            id newValue = [instance valueForKey:name];
            if (newValue) {
                value = [newValue valueForKey:varName];
                if (value) {
                    return value;
                } else {
                    value = [[self class] captureVarforInstance:newValue varName:varName];
                }
            }
        }
    }
    return value;
}

+(id)captureVarforInstance:(id)instance withPara:(NSDictionary *)para
{
    NSString * properyName = para[@"propertyName"];
    NSString * propertyPath = para[@"propertyPath"];
    if (propertyPath.length > 0) {
        NSArray * keysArray = [propertyPath componentsSeparatedByString:@"/"];
     
        return [[self class] captureVarforInstance:instance withKeys:keysArray];
    }
    return [[self class] captureVarforInstance:instance varName:properyName];
}


+(id)captureVarforInstance:(id)instance withKeys:(NSArray *)keyArray
{
    id result = [instance valueForKey:keyArray[0]];
    
    if (keyArray.count > 1 && result) {
        int i = 1;
        while (i < keyArray.count && result) {
            result = [result valueForKey:keyArray[i]];
            i++;
        }
    }
    return result;
}

+ (BOOL)isContainSel:(SEL)sel class:(Class)cls {
    unsigned int count;
    Method *methodList = class_copyMethodList(cls, &count);
    for (int i = 0; i < count; i ++) {
        Method method = methodList[i];
        NSString *temMethodName = [NSString stringWithUTF8String:sel_getName(method_getName(method))];
        if ([temMethodName isEqualToString:NSStringFromSelector(sel)]) {
            return YES;
        }
    }
    return NO;
}



+ (BOOL)isContainProperty:(id)varName class:(id)cls {
    unsigned int count;
    objc_property_t *properties = class_copyPropertyList([cls class], &count);
    for (int i = 0; i < count; i ++) {
        objc_property_t property = properties[i];
        NSString *propertyName = [[NSString alloc] initWithCString:property_getName(property) encoding:NSUTF8StringEncoding];
        if ([varName isEqualToString:propertyName]) {
            return YES;
        }
    }
    return NO;
}

@end
