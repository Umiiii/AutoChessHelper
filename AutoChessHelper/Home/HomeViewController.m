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
- (void)setScreenShotIcon{
    NSString* appnameStr = [[[NSBundle mainBundle] localizedInfoDictionary]
                            objectForKey:@"CFBundleDisplayName"];
    UIWindow *win = [UIApplication sharedApplication].keyWindow;

    NSString *icon = @"AppIcon";
    UIImage* image = [UIImage imageNamed:icon];

    UILabel* appname =[[UILabel alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-20, 20)];
    //appname.backgroundColor = [UIColor redColor];
    appname.font = [UIFont systemFontOfSize:11.0f];
    appname.textAlignment = NSTextAlignmentCenter;
    DLog(@"%@",image);
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
    CGSize titleSize = [appnameStr sizeWithFont:appname.font constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
#pragma clang diagnostic pop
    //DLog(@"%@",titleSize);
    UIImageView* i = [[UIImageView alloc]initWithFrame:CGRectMake((SCREEN_WIDTH-titleSize.width)/2-10, 3, 15, 15)];
    i.layer.masksToBounds = YES;
    i.image = image;
    i.layer.cornerRadius = 2.0f;
    i.layer.borderColor = [UIColor blackColor].CGColor;
   





    appname.textAlignment = NSTextAlignmentCenter;
    appname.text = appnameStr;

    [win addSubview:appname];
    [win addSubview:i];}
- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        if(UIApplication.sharedApplication.keyWindow.safeAreaInsets.bottom > 0.0){
            [self setScreenShotIcon];
        }
    } else {
        // Fallback on earlier versions
    }

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
        NPCViewController* ctr = [[NPCViewController alloc]init];
        [self.navigationController pushViewController:ctr animated:YES];
    }
    if (indexPath.row == 3){
        ItemController* ctr = [[ItemController alloc]init];
        [self.navigationController pushViewController:ctr animated:YES];
    }
}




@end
