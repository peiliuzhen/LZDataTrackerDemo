//
// LZDataTrackTool.h
// LZDataTrackerDemo
//
//  Created by plz on 2020/7/28.
//  Copyright © 2020 plz. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface LZDataTrackTool : NSObject

@property (nonatomic, copy) NSDictionary *trackData;

+ (instancetype)shareInstance;


@end

NS_ASSUME_NONNULL_END
