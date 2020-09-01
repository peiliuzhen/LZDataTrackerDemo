//
//  ThirdViewController.m
// LZDataTrackerDemo
//
//  Created by plz on 2020/8/10.
//  Copyright © 2020 plz. All rights reserved.
//

#import "ThirdViewController.h"
#import "CollectionViewCell.h"

@interface ThirdViewController () <UICollectionViewDelegate,UICollectionViewDataSource>
@property (strong, nonatomic) UICollectionView *collectionView;
@property (nonatomic, copy) NSString *text;
@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.text = @"collectionView";
    [self.view addSubview:self.collectionView];
    [self.collectionView registerNib:[UINib nibWithNibName:CollectionViewCellID bundle:nil] forCellWithReuseIdentifier:CollectionViewCellID];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width, 111);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CollectionViewCellID forIndexPath:indexPath];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

-(UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
        _collectionView.backgroundColor = UIColor.whiteColor;
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
    }
    return _collectionView;
}

@end
