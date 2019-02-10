//
//  HomeViewController.m
//  AutoChessHelper
//
//  Created by Cirno on 2019/1/20.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // TableView
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
     self.navigationController.hidesBottomBarWhenPushed =YES;
    [self.view addSubview:self.tableView];
}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0)
        return 30 +20;
    else
        return 60;
}
- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell* cell;
    if (indexPath.section == 0){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
        UICollectionViewFlowLayout* layout = [[UICollectionViewFlowLayout alloc]init];
        //layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake(SCREEN_WIDTH/4, 30 +20);
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);


        HomeCollectionView* collectionView = [[HomeCollectionView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30 +20) collectionViewLayout:layout];
        collectionView.backgroundColor = [UIColor clearColor];
        collectionView.scrollEnabled = NO;
        collectionView.delegate = self;
        [cell.contentView addSubview:collectionView];
    } else {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
        cell.textLabel.text = NSLocalizedString(@"更新日志", "");
        cell.detailTextLabel.text = @"20180120";
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor blackColor];
    }
    return cell;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0)
        return @"资料";
    else
        return @"日志";
}
- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 1;
    else
        return 4;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
   // NSLog(@"第%ld分区--第%ld个Item", indexPath.section, indexPath.row);
    if (indexPath.row == 0){
        ChessController* chessController = [[ChessController alloc]init];

        [self.navigationController pushViewController:(UIViewController *)chessController animated:YES];
    }
    if (indexPath.row == 1){
        RankTableViewController * rankCtr = [[RankTableViewController alloc]init];
        [self.navigationController pushViewController:rankCtr animated:YES];
    }
    if (indexPath.row == 2){

    }
    if (indexPath.row == 3){
        ItemController* ctr = [[ItemController alloc]init];
        [self.navigationController pushViewController:ctr animated:YES];
    }
}




@end
