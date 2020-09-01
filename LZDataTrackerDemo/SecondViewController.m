//
//  SecondViewController.m
// LZDataTrackerDemo
//
//  Created by plz on 2020/8/7.
//  Copyright © 2020 plz. All rights reserved.
//

#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "TableViewCell.h"

@interface SecondViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;
@property (nonatomic, copy) NSString *text;
@property (nonatomic, copy) NSString *spm;
@property (nonatomic, copy) NSString *pageName;

@end

@implementation SecondViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    

}

- (void)viewDidLoad {
    self.spm =@"a-b-c";
    self.pageName=NSStringFromClass(self.class);
    [super viewDidLoad];
    self.text = @"tableview";
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:TableViewCellID bundle:nil] forCellReuseIdentifier:TableViewCellID];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:TableViewCellID];
    cell.textLabel.text=[NSString stringWithFormat:@"点击测试第%lu行",indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.navigationController pushViewController:[ThirdViewController new] animated:YES];
}


-(UITableView *)tableView{
    if (!_tableView) {
        _tableView =[[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.backgroundColor = UIColor.whiteColor;
    }
    return _tableView;
}
@end
