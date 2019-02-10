//
//  ChessDetailController.h
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/3.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chess.h"
#import "DOTAManager.h"
#import "ChessDetailCollectionView.h"
#import "BuffFilterController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChessDetailController : UITableViewController<FilterDelegate>
@property (nonatomic,strong) Chess* chess;
@property (nonatomic) NSInteger hpRegen;
@property (nonatomic,strong) NSArray* buff;
@property (nonatomic) NSInteger mpRegen;
@property (nonatomic) NSUInteger level;
@end

NS_ASSUME_NONNULL_END
