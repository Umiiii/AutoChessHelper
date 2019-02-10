//
//  HomeViewController.h
//  AutoChessHelper
//
//  Created by Cirno on 2019/1/20.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeCollectionView.h"
#import "ChessController.h"
#import "RankTableViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface HomeViewController : UIViewController <UITableViewDelegate,UITableViewDataSource,
                                                  UICollectionViewDelegate>
@property (nonatomic,strong) UICollectionView* collectionView;
@property (nonatomic,strong) UITableView* tableView;


@end

NS_ASSUME_NONNULL_END
