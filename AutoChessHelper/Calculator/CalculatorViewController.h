//
//  CalculatorViewController.h
//  AutoChessHelper
//
//  Created by Cirno on 2019/1/20.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Chess.h"
#import "CombinationLogic.h"
NS_ASSUME_NONNULL_BEGIN

@interface CalculatorViewController : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView* tableView;
@property (nonatomic,copy) NSArray<UIButton*>* selectedArray;
@property (nonatomic,strong) UILabel* gameInfoView;
@property (nonatomic,strong) UIStepper* stepper;
@property (nonatomic,strong) UIStepper* roundStepper;
@property (nonatomic,strong) UISegmentedControl* chessControl;
@property (nonatomic,strong) NSArray* filter ;
@property (nonatomic,strong) NSArray<NSArray<Chess*>*>* hero;
@property (nonatomic,copy) NSArray<Chess*>* selectedChess;
@property (nonatomic,strong) NSMutableArray<NSMutableArray<Chess*>*>* result;
@property (nonatomic,strong) NSMutableArray<NSMutableArray<Chess*>*>* finalResult;
@property (nonatomic,strong) NSMutableArray<NSArray*>* finalComboResult;
@property NSInteger nowResult;
@property NSInteger level;
@property NSInteger filter_selected;
@property NSInteger row;
@end

NS_ASSUME_NONNULL_END
