//
//  RootViewController.m
// LZDataTrackerDemo
//
//  Created by plz on 2020/8/7.
//  Copyright © 2020 plz. All rights reserved.
//

#import "RootViewController.h"
#import "SecondViewController.h"
#import <objc/runtime.h>

@interface RootViewController ()
@property (nonatomic, copy) NSString *tips;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *text;
/** annotation */
@property (nonatomic,strong) UIButton *testBtn;
@property (nonatomic, copy) NSString *spm;
@property (nonatomic, copy) NSString *pageName;

@end

@implementation RootViewController

- (void)viewDidLoad {
    self.spm=@"1-2-3-4-5";
     self.pageName = @"RootViewController";
     self.content = @"dictionary";
     self.tips = @"test";
    [super viewDidLoad];
    
    self.view.backgroundColor=UIColor.whiteColor;
    self.testBtn.frame=CGRectMake(100, 100, 100, 30);
    [self.view addSubview:self.testBtn];
    
    //手势2
    UILabel * tapLabel = [[UILabel alloc]init];
    tapLabel.frame = CGRectMake(100, 200, 200, 50);
    tapLabel.text = @"点击触发手势埋点";
    tapLabel.textAlignment = NSTextAlignmentCenter;
    tapLabel.textColor = [UIColor whiteColor];
    tapLabel.backgroundColor = [UIColor grayColor];
    tapLabel.userInteractionEnabled = YES;
    [self.view addSubview:tapLabel];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gestureclicked:)];
    [tapLabel addGestureRecognizer:tap];

}

- (void)gestureclicked:(UIGestureRecognizer *)gesture {
//    [self presentViewController:[[SecondViewController alloc]init] animated:YES completion:nil];
    [self.navigationController pushViewController:[[SecondViewController alloc]init] animated:YES];
}

-(void)testButtonClick:(UIButton *)sender{
//    [self presentViewController:[[SecondViewController alloc]init] animated:YES completion:nil];
    [self.navigationController pushViewController:[[SecondViewController alloc]init] animated:YES];
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


