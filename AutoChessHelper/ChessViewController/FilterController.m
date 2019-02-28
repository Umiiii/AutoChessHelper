//
//  FilterController.m
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/3.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import "FilterController.h"
#import "DOTAManager.h"
@interface FilterController ()

@end

@implementation FilterController

- (UIViewController *)getPresentedViewController
{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    if (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    UIBarButtonItem* back = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(back)];
    UIBarButtonItem * detail = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Show Detail", "") style:UIBarButtonItemStylePlain target:self action:@selector(setDetailStatus)];
    self.title = NSLocalizedString(@"Filter", "");
    self.navigationItem.leftBarButtonItem = back;
   self.navigationItem.rightBarButtonItem = detail;
  //  NSArray* items = [[NSArray alloc]initWithObjects:back, nil];
   // [self.navigationController.navigationController.navigationBar setItems:items animated:YES];
    [self.tableView setEditing:YES animated:YES];
    NSMutableSet* filterOptions = [[NSMutableSet alloc]init];
    NSMutableDictionary* ability = [[DOTAManager sharedInstance]abilityImageName];
    for (NSString* str in ability){
        if ([str hasPrefix:@"is_"] ){
            if ([str isEqualToString:@"is_halobios"] || [str isEqualToString:@"is_plant"] || [str isEqualToString:@"is_ward"]
                ||[str isEqualToString:@"is_imp"])
                continue;
            NSString* new = str;
            new = [new stringByReplacingOccurrencesOfString:@"_buff" withString:@""];
            new = [new stringByReplacingOccurrencesOfString:@"_plus" withString:@""];
            //DLog(@"%@",new);
            [filterOptions addObject:new];
        }
    }
    self.filterOptions = [filterOptions allObjects];
//    self.filterOptions = [[NSArray alloc]initWithObjects:@"is_human",@"is_knight",@"is_assassin",@"is_mage",
//                          @"is_warlock",@"is_mech",@"is_hunter",@"is_druid",@"is_shaman",@"is_troll",
//                          @"is_beast",@"is_elf",@"is_demon",@"is_demonhunter",@"is_undead",@"is_orc",
//                          @"is_naga",@"is_goblin",@"is_element",@"is_dwarf",@"is_ogre",@"is_dragon", NULL];

}

#pragma mark - Table view data source
-(void)back{
    NSMutableArray * selectedOptions = [[NSMutableArray alloc]init];
    NSArray* indexPathsForSelectedRows = self.tableView.indexPathsForSelectedRows;
    for (NSIndexPath* indexPath in indexPathsForSelectedRows){
        [selectedOptions addObject:self.filterOptions[indexPath.row]];
    }
    [self.delegate setFilterOptionsByDelegate:[selectedOptions copy]];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

   // DLog(@"Set new filter");
}

-(void)setDetailStatus{
    self.detail = ! self.detail;
    if (self.detail)
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Hide detail", "");
    else
        self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Show detail", "");
    NSIndexSet * indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

 
    return 1;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.filterOptions count];
}
- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];


}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }

    NSString* textLabelString = [NSString stringWithFormat:@"DOTA_Tooltip_ability_%@",self.filterOptions[indexPath.row]];
    NSString* raw = self.filterOptions[indexPath.row];
    cell.textLabel.text = NSLocalizedString(textLabelString, "");
    if (self.detail){
        cell.detailTextLabel.numberOfLines = 0;
        DOTAManager * manager = [DOTAManager sharedInstance];
        NSString * detailTextString = [NSString stringWithFormat:@"DOTA_Tooltip_ability_%@_Lore",self.filterOptions[indexPath.row]];
        detailTextString = NSLocalizedString(detailTextString, "");
        detailTextString = [detailTextString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
        cell.detailTextLabel.attributedText = [self attributedStringWithHTMLString:NSLocalizedString(detailTextString, "")];
//
//        NSString* propertiesStr = [NSString stringWithFormat:@"%@_buff",raw];
//
//
//        NSMutableDictionary * dic = [manager abilityImageName][propertiesStr];
//        NSString* modifierStr = [NSString stringWithFormat:@"modifier_%@",propertiesStr];
//        @try {
//            dic = dic[@"Modifiers"][modifierStr][@"Properties"];
//
//           // propertiesValue = dic[propertiesStr];
//        } @catch (NSException *exception) {
//            DLog(@"%@",exception);
//        }
 //       cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",dic];
    } else {
        cell.detailTextLabel.text = @"";
    }
    return cell;
}



@end
