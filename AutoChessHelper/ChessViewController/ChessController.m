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
    NSArray* ssrName = [[DOTAManager sharedInstance]gamedata][@"chess_list_ssr"];
    self.ssr = [[NSMutableArray alloc]init];
    for (NSString* ssr in ssrName){
        
    }

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

}
-(void)setFilterOptionsByDelegate:(NSArray*)filterOptions{
   // DLog(@"set");
    self.filterOptions = filterOptions;
    [self updateFilterChess];
    NSIndexSet* indexSet = [[NSIndexSet alloc]initWithIndex:0];
    if ([self.tableView numberOfSections] == 1)
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
    if (section ==1)
        return @"SSR";
    return nil;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if ([self.filterOptions count] == 0)
//        return 2;
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 1)
        return [self.ssr count];
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
    if (indexPath.section == 1){
        NSMutableAttributedString * str = [
                                           [NSMutableAttributedString alloc]initWithString:[NSLocalizedString(self.ssr[indexPath.row], "") stringByReplacingOccurrencesOfString:@"" withString:@""]];
        cell.textLabel.attributedText = str;
        NSMutableDictionary*tmpDictionary = [[DOTAManager sharedInstance]units][self.ssr[indexPath.row]];

        NSString* tmp = tmpDictionary[@"Model"];
        NSUInteger pos1 = [tmp rangeOfString:@"/" options:NSBackwardsSearch].location+1;
        NSUInteger pos2 = [tmp length]-5 ;
        NSString* imageName = [NSString stringWithFormat:@"npc_dota_hero_%@_png",
                                                          [tmp substringWithRange:NSMakeRange(pos1, pos2-pos1)]];
        cell.imageView.image = [UIImage imageNamed:imageName];
        return cell;

    }
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
