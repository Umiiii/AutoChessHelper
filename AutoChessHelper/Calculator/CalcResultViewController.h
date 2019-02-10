//
//  CalcResultViewController.h
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/4.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOTAManager.h"
#import "Chess.h"
NS_ASSUME_NONNULL_BEGIN

@interface CalcResultViewController : UITableViewController
@property (nonatomic,strong) NSArray<Chess*>* chess;
@end

NS_ASSUME_NONNULL_END
