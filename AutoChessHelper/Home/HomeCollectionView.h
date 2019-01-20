//
//  HomeCollectionView.h
//  AutoChessHelper
//
//  Created by Cirno on 2019/1/20.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeCollectionView : UICollectionView <UICollectionViewDataSource>
@property (nonatomic,strong) NSArray* itemImage;
@property (nonatomic,strong) NSArray* itemLabel;

@end

NS_ASSUME_NONNULL_END
