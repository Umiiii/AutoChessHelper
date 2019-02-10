//
//  BuffFilterController.m
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/4.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import "BuffFilterController.h"

@interface BuffFilterController ()

@end

@implementation BuffFilterController
//
//  FilterController.m
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/3.
//  Copyright © 2019 Cirno. All rights reserved.
//
- (NSArray *)clearAllNullObject:(NSArray*)arr{
    NSMutableArray *array = [arr mutableCopy];
    for (int i = 0;i < array.count;i++) {
        id obj = array[i];
        if ([obj isKindOfClass:[NSNull class]])
            [array removeObject:obj];
    }
    return array;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    UIBarButtonItem* back = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(back)];
    //UIBarButtonItem * detail = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Show Detail", "") style:UIBarButtonItemStylePlain target:self action:@selector(setDetailStatus)];
    self.title = NSLocalizedString(@"Buff", "");
    self.navigationItem.leftBarButtonItem = back;
    //self.navigationItem.rightBarButtonItem = detail;
    self.detail = YES;
    [self.tableView setEditing:YES animated:YES];
    self.filterOptions = [self clearAllNullObject:self.filterOptions];
//    self.filterOptions = [[NSArray alloc]initWithObjects:
//                          [[self.filterOptions objectEnumerator]allObjects],
//                          @"is_mage",@"is_mage1",@"is_troll1",
//                          @"is_beast",@"is_beast1",@"is_beast11",
//                          @"is_undead",@"is_undead1",@"is_undead11",
//                          @"is_naga",@"is_naga1", NULL];

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
    self.detail = !self.detail;
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
    DOTAManager * manager = [DOTAManager sharedInstance];
//    "DOTA_Tooltip_ability_is_warlock_buff_plus"="(6)术士buff";
//    "DOTA_Tooltip_modifier_is_warlock_buff_plus"="灵魂榨取";
//    "DOTA_Tooltip_modifier_is_warlock_buff_plus_Description"="30%%吸血。";
    DLog(@"%@",self.filterOptions[indexPath.row]);
    NSString* raw = [manager comboAbilityType][self.filterOptions[indexPath.row]][@"ability"];
    NSString* textLabelString = [NSString stringWithFormat:@"DOTA_Tooltip_modifier_%@",raw];
    cell.textLabel.text = NSLocalizedString(textLabelString, "");
    cell.accessoryType= UITableViewCellAccessoryDetailButton;
    if (self.detail){
        cell.detailTextLabel.numberOfLines = 0;

        NSString* des = [NSString stringWithFormat:@"DOTA_Tooltip_modifier_%@_Description",raw];
        des = NSLocalizedString(des, "");
        NSString * detailTextString = [NSString stringWithFormat:@"DOTA_Tooltip_ability_%@",raw];
        detailTextString = NSLocalizedString(detailTextString, "");
        detailTextString = [detailTextString stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@",detailTextString,des];

        
    } else {
        cell.detailTextLabel.text = @"";
    }
    return cell;
}


@end
