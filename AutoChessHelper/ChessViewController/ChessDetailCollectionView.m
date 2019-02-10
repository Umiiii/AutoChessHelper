//
//  ChessDetailCollectionView.m
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/4.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import "ChessDetailCollectionView.h"

@implementation ChessDetailCollectionView

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


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)]; //

    UILabel* label = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, 80, 20)];
    label.text = [NSString stringWithFormat:@"%@",NSLocalizedString(self.itemLabel[indexPath.row],"")];

    UILabel* detailLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 80, 20)];
    [cell.contentView addSubview:detailLabel];
    detailLabel.text = self.itemDetailLabel[indexPath.row];
    detailLabel.font = [UIFont systemFontOfSize:12];
    label.textAlignment = NSTextAlignmentCenter;
    detailLabel.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:16];
    cell.layer.borderColor=RGB(233,233,233).CGColor;
    cell.layer.borderWidth=0.8f;
    cell.backgroundColor = RGB(244,244,244);
    // label.backgroundColor = [UIColor yellowColor];
    [cell.contentView addSubview:label];
    // cell.backgroundColor = [UIColor greenColor];
    return cell;
}



@end
