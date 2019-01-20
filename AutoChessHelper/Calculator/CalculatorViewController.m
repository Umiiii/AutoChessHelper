//
//  CalculatorViewController.m
//  AutoChessHelper
//
//  Created by Cirno on 2019/1/20.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import "CalculatorViewController.h"

@interface CalculatorViewController ()

@end

@implementation CalculatorViewController
- (NSArray*)addObject:(UIImageView*)imageView forArray:(NSArray*)array{
    NSMutableArray* mutableArray = [array mutableCopy];
    [mutableArray addObject:imageView];
    return [mutableArray copy];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSInteger offset;
    offset = (SCREEN_WIDTH - 32*10) / 9;
    self.onhandArray = [[NSMutableArray alloc]init];
    self.onboardArray = [[NSMutableArray alloc]init];
    for (int i = 1; i <= 10; i++){


        UIImageView* imageView =[[UIImageView alloc]initWithFrame:CGRectMake((32+offset)*(i-1), 0, 32, 32)];
        imageView.backgroundColor = i % 2 == 0? [UIColor redColor]:[UIColor greenColor];
        self.onboardArray = [self addObject:imageView forArray:self.onboardArray];
    }

    offset = (SCREEN_WIDTH - 32*8) / 7;
    for (int i = 1; i <= 8; i++){

        UIImageView* imageView =[[UIImageView alloc]initWithFrame:CGRectMake((32+offset)*(i-1), 0, 32, 32)];
        imageView.backgroundColor = i % 2 == 1? [UIColor redColor]:[UIColor greenColor];
       self.onhandArray = [self addObject:imageView forArray:self.onhandArray];

    }
    [self.view addSubview:self.tableView];
}


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell* cell;
    if (indexPath.section == 0){
        cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        cell.backgroundColor = [UIColor clearColor];
        for (UIImageView* view in self.onboardArray){
            [cell addSubview:view];
        }
    } else if (indexPath.section == 1){
        cell = [[UITableViewCell alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 32)];
        cell.backgroundColor = [UIColor clearColor];
        for (UIImageView* view in self.onhandArray){

            [cell addSubview:view];
        }
    };
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1)
        return 32;
    return 44;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0){
        return NSLocalizedString(@"Onboard", "棋盘上的棋子");
    } else {
        return NSLocalizedString(@"Onhand", "等待区");
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1){
        return 1;
    }
    return 0;
}

@end
