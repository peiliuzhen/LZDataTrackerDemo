//
// LZDataTrackTool.m
// LZDataTrackerDemo
//
//  Created by plz on 2020/7/28.
//  Copyright © 2020 plz. All rights reserved.
//

#import "LZDataTrackTool.h"
//#import "NSBundle+PodResource.h"

@implementation LZDataTrackTool

+ (instancetype)shareInstance {
    static LZDataTrackTool *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init {
    if (self = [super init]) {
        
        NSString * path = [[NSBundle mainBundle] pathForResource:@"LZDataTrack" ofType:@"json"];
        NSData * JSONData = [NSData dataWithContentsOfFile:path];
        NSDictionary *testDict = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingAllowFragments error:nil];
        
//        NSDictionary *testDict = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"LZDataTrack" ofType:@"plist"]];
        self.trackData = [testDict copy];
        
    }
    return self;
}

@end
