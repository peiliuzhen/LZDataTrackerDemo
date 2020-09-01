//
//  TableViewCell.h
// LZDataTrackerDemo
//
//  Created by plz on 2020/8/10.
//  Copyright © 2020 plz. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

static NSString *const TableViewCellID = @"TableViewCell";

@interface TableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger index;
@property (nonatomic,strong) UIButton *testBtn;

@end

NS_ASSUME_NONNULL_END
