//
//  ChessController.h
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/3.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "FilterController.h"
#import "Chess.h"
#import "DOTAManager.h"
#import "ChessDetailController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ChessController : UITableViewController<UITableViewDelegate,UITableViewDataSource,FilterDelegate>

@property (nonatomic, strong) NSArray<Chess*>* allChess;
@property (nonatomic, strong) NSArray* ssr;
@property (nonatomic, strong) NSArray<Chess*>* filterChess;
@property (nonatomic, strong) NSArray* filterOptions;
@property (nonatomic) FilterMode filterMode;


@end


NS_ASSUME_NONNULL_END
