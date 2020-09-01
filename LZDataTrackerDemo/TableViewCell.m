//
//  TableViewCell.m
// LZDataTrackerDemo
//
//  Created by plz on 2020/8/10.
//  Copyright © 2020 plz. All rights reserved.
//

#import "TableViewCell.h"

@implementation TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.testBtn.frame=CGRectMake(10, 10, 200, 30);
    [self addSubview:self.testBtn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)testButtonClick:(UIButton *)sender{

    NSLog(@"测试按钮");
}

-(UIButton *)testBtn{
    if (!_testBtn) {
        _testBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [_testBtn setTitle:@"测试" forState:UIControlStateNormal];
        _testBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_testBtn setTitleColor:UIColor.blackColor forState:UIControlStateNormal];
        [_testBtn setBackgroundColor:UIColor.redColor];
        [_testBtn addTarget:self action:@selector(testButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    }
    return _testBtn;
}

@end
