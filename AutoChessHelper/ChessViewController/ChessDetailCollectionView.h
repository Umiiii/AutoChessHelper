//
//  ChessDetailCollectionView.h
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/4.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ChessDetailCollectionView :UICollectionView <UICollectionViewDataSource>
@property (nonatomic,strong) NSArray* itemDetailLabel;
@property (nonatomic,strong) NSArray* itemLabel;

@end

NS_ASSUME_NONNULL_END
