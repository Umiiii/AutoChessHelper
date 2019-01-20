//
//  HomeCollectionView.m
//  AutoChessHelper
//
//  Created by Cirno on 2019/1/20.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import "HomeCollectionView.h"

@implementation HomeCollectionView

-(instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{

    if (self = [super initWithFrame:frame collectionViewLayout:layout]){
        self.bounces = NO;
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.dataSource = self;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    }
    return self;
}
#pragma mark - UICollectionViewDelegate --- UICollectionViewDataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.itemLabel.count;
}

-(NSArray*) itemLabel{
    if (!_itemLabel){
        _itemLabel = [[NSArray alloc]initWithObjects:@"棋子",@"段位",@"怪物",@"物品", nil];
    }
    return _itemLabel;
}



- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)]; //
  
    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH/4, SCREEN_WIDTH/4)];
    if (_itemImage){
        image.image = [UIImage imageNamed:self.itemImage[indexPath.row] inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil];
    } else {
        image.backgroundColor = [UIColor redColor];
    }

    [cell.contentView addSubview:image];

    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREEN_WIDTH/4, SCREEN_WIDTH/4, 20)];
    label.text = [NSString stringWithFormat:@"%@",self.itemLabel[indexPath.row]];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = AppFontContentStyle();
    label.backgroundColor = [UIColor yellowColor];
    [cell.contentView addSubview:label];
    cell.backgroundColor = [UIColor greenColor];
    return cell;
}




@end
