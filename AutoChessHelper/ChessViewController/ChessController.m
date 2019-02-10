//
//  ChessController.m
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/3.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import "ChessController.h"

@implementation ChessController

-(void) viewDidLoad {
    self.tableView.dataSource = self;
    self.tableView.delegate = self;


    if (@available(iOS 11.0, *)) {
        self.navigationController.navigationBar.prefersLargeTitles = YES;
    } else {
        // Fallback on earlier versions
    }
    self.allChess = [[DOTAManager sharedInstance]allChessNotByMana];
    self.filterOptions = [[NSArray alloc]init];
    [self updateFilterChess];

}
-(void)viewWillAppear:(BOOL)animated{
    UIBarButtonItem * filterButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(filterClick)];
    UIBarButtonItem * filterMode = [[UIBarButtonItem alloc]initWithTitle:@"OR" style:UIBarButtonItemStylePlain target:self action:@selector(switchMode)];
    NSArray* items ;
    if ([self.filterOptions count] != 0 && [self.filterOptions count] != 1){
        items = [[NSArray alloc]initWithObjects:filterMode,filterButton, nil];
    }
    else{
         items = [[NSArray alloc]initWithObjects:filterButton, nil];
    }
    self.navigationItem.rightBarButtonItems = items;

}
-(void)switchMode{
    if (self.filterMode == FilterModeOr){
        self.filterMode = FilterModeAnd;
        UIBarButtonItem * filterMode = [[UIBarButtonItem alloc]initWithTitle:@"AND" style:UIBarButtonItemStylePlain target:self action:@selector(switchMode)];
        UIBarButtonItem * filterButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(filterClick)];
        NSArray* items = [[NSArray alloc]initWithObjects:filterMode,filterButton, nil];
        self.navigationItem.rightBarButtonItems = items;
    }
    else{
        self.filterMode = FilterModeOr;
        UIBarButtonItem * filterMode = [[UIBarButtonItem alloc]initWithTitle:@"OR" style:UIBarButtonItemStylePlain target:self action:@selector(switchMode)];
        UIBarButtonItem * filterButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"filter"] style:UIBarButtonItemStylePlain target:self action:@selector(filterClick)];
        NSArray* items = [[NSArray alloc]initWithObjects:filterMode,filterButton, nil];
        self.navigationItem.rightBarButtonItems = items;
    }
    [self updateFilterChess];
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void) updateFilterChess{
    NSMutableArray <Chess*>* array = [[NSMutableArray alloc]init];

    NSString* title ;
    if ([self.filterOptions count] == 0) {
        self.filterChess = self.allChess;
        self.title = NSLocalizedString(@"Chess", "");
        return;
    }
    NSString* titleString =  [NSString stringWithFormat:@"DOTA_Tooltip_ability_%@",self.filterOptions[0]];
    title = [NSString stringWithFormat:@"%@",NSLocalizedString(titleString, "")];

    for (NSString* ability in self.filterOptions){

        titleString =  [NSString stringWithFormat:@"DOTA_Tooltip_ability_%@",ability];
        if (ability == self.filterOptions[0])
            continue;
        if (_filterMode == FilterModeOr)
            title = [NSString stringWithFormat:@"%@%@%@",title,NSLocalizedString(@"or", ""),NSLocalizedString(titleString, "   ")];
        else
            title = [NSString stringWithFormat:@"%@%@%@",title,NSLocalizedString(@"and", ""),NSLocalizedString(titleString, "")];

    }
    self.title = title;


    for (Chess* chess in self.allChess){
        if (_filterMode == FilterModeOr){
            for (NSString* ability in self.filterOptions){
                if (([chess.ability containsObject:ability]) && !([array containsObject:chess])){
                    [array addObject:chess];
                }
            }
        } else {
           
            BOOL flag = true;
            for (NSString* ability in self.filterOptions){
                if (![chess.ability containsObject:ability]){
                    flag = false;
                    break;
                }
            }
            if (flag && !([array containsObject:chess]))
                [array addObject:chess];
        }
    }
    for (int i=0;i<[array count];i++){
        // 按照筛选器顺序排序技能
        for (int j=0;j<[self.filterOptions count];j++){
            if([array[i].ability count] < (j+1))
                continue;
            if ([array[i].ability containsObject:self.filterOptions[j]]){

                if (![array[i].ability[j] isEqualToString:self.filterOptions[j]]){

                    int pos = 0;
                    for (int k=0;k<[array[i].ability count];k++)
                        if ([array[i].ability[k] isEqualToString: self.filterOptions[j]]){
                            pos = k;
                            break;
                        }
                    NSMutableArray* copyAbility = [array[i].ability mutableCopy];
                    NSString* tmp = copyAbility[j];

                    copyAbility[j] = copyAbility[pos];
                    copyAbility[pos] = tmp;
                    array[i].ability = [copyAbility copy];
                }
            }
        }
       // array[i].ability = [[array[i].ability reverseObjectEnumerator]allObjects];
    }


//    self.filterChess = [array sortedArrayUsingComparator:^NSComparisonResult(id  obj1, id  obj2) {
//
//        Chess* c1 = obj1;
//        Chess* c2 = obj2;
//        NSString* obj1str = c1.ability[0];
//        NSString* obj2str = c2.ability[0];
//        if ([obj1str compare:obj2str] == NSOrderedSame)
//            return [c1.ability[1] compare:c2.ability[1]];
//        return [obj1str compare:obj2str];
//    }];
    int k = 0;
    if (self.filterMode == FilterModeOr)
        for (int i = 0;i<[array count]-1;i++){
            if (![array[i].ability[k] isEqualToString:self.filterOptions[k]]){
               // DLog(@"%@ %ld",array[i].name,i);
                int pos = 0;
                for (int l=i+1;l<[array count];l++){
                    //DLog(@"%@ %@",array[l].ability[k],self.filterOptions[k]);
                    if ([array[l].ability[k] isEqualToString:self.filterOptions[k]])
                    {
                        pos = l;
                        Chess*tmp = array[i];
                        array[i] = array[pos];
                        array[pos] = tmp;
                        break;
                    }
                }
             //   DLog(@"%ld",(long)pos);

            }
        }
    self.filterChess = [array copy];
//    for (int i=0;i<[array count]-1;i++){
//        for (int j=1;j<[array count];j++){
//            int iweightScore = 0;
//            int jweightScore = 0;
//            for (NSString* options in self.filterOptions){
//                for (NSString* ability in array[i].ability)
//                    if (ability == options){
//                        iweightScore ++;
//                    }
//                for (NSString* ability in array[j].ability)
//                    if (ability == options){
//                        jweightScore ++;
//                    }
//
//            }
//            if (iweightScore < jweightScore){
//                Chess* tmp = array[i];
//                array[i] = array[j];
//                array[j] = tmp;
//            }
//        }
//    }
//    self.filterChess = [array copy];
//    self.filterChess = [array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
//        Chess* chess1 = obj1;
//        Chess* chess2 = obj2;
//
//        if ([chess1.ability[0] compare:chess2.ability[0] options:NSLiteralSearch] == NSOrderedSame)
//            if ([chess1.ability count] >=2 && [chess2.ability count]>=2)
//                return [chess1.ability[1] compare:chess2.ability[1] options:NSLiteralSearch];
//        return [chess1.ability[0] compare:chess2.ability[0] options:NSLiteralSearch];
//    }];

}
-(void)setFilterOptionsByDelegate:(NSArray*)filterOptions{
   // DLog(@"set");
    self.filterOptions = filterOptions;
    [self updateFilterChess];
    NSIndexSet* indexSet = [[NSIndexSet alloc]initWithIndex:0];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
}
-(void)filterClick{
    FilterController * filterController = [[FilterController alloc]init];
    filterController.delegate = self;

    UINavigationController *navigationController =
    [[UINavigationController alloc] initWithRootViewController:filterController];

    [self.navigationController presentViewController:navigationController animated:YES completion:nil];
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.filterChess count];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ChessDetailController* ctr = [[ChessDetailController alloc]init];
   
    ctr.chess = self.filterChess[indexPath.row];
    [self.navigationController pushViewController:ctr animated:YES];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    NSArray* color = [[NSArray alloc]initWithObjects:HRGB(0xBBBBBB),HRGB(0xBBBBFF),HRGB(0x6666FF),HRGB(0xFF00FF),
    HRGB(0xFF8800),nil];
   // if ([self.filterOptions count] == 0){
    cell.imageView.image = [UIImage imageNamed:self.filterChess[indexPath.row].imageName];
    NSMutableAttributedString * str = [
                                       [NSMutableAttributedString alloc]initWithString:[NSLocalizedString(self.filterChess[indexPath.row].name, "") stringByReplacingOccurrencesOfString:@"★" withString:@""]];
    [str addAttribute:NSForegroundColorAttributeName value:color[self.filterChess[indexPath.row].mana-1] range:NSMakeRange(0, [str length])];
    cell.textLabel.attributedText = str;
#define ABILITYWIDTH 44
    UIView* abilityView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, (ABILITYWIDTH+10)*[self.filterChess[indexPath.row].ability count], ABILITYWIDTH)];
    int count = 0;
    for (NSString* ability in [self.filterChess[indexPath.row].ability reverseObjectEnumerator]){

        UIImageView* abilityImage = [[UIImageView alloc]initWithFrame:CGRectMake(count*(ABILITYWIDTH+10), 0, ABILITYWIDTH, ABILITYWIDTH)];
        DOTAManager* manager = [DOTAManager sharedInstance];
        abilityImage.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_png",[manager abilityImageName][ability][@"AbilityTextureName"]]];
        [abilityView addSubview:abilityImage];
        count ++;
    }

    cell.detailTextLabel.text = [NSString stringWithFormat:@"Cost: %ld",(long)self.filterChess[indexPath.row].mana];
    cell.accessoryView = abilityView;
   // }
    return cell;
}




@end
