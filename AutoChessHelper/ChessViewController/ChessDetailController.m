//
//  ChessDetailController.m
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/3.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import "ChessDetailController.h"

@interface ChessDetailController ()

@end

@implementation ChessDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    NSString* title = NSLocalizedString(self.chess.name, "");
    title = [title stringByReplacingOccurrencesOfString:@"★" withString:@""];
    self.title = title;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.level = 1;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0)
        return 3;
    else
        if (section ==1){
            NSString* abilityLocalizedString = [[DOTAManager sharedInstance]gamedata][@"chess_ability_list"][self.chess.name];
            return 1+[[[DOTAManager sharedInstance]abilityImageName][abilityLocalizedString][@"AbilitySpecial"] count];
        }

        return 6;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        if (indexPath.row == 1){
            DOTAManager* manager = [DOTAManager sharedInstance];

            BuffFilterController* filterController = [[BuffFilterController alloc]init];
            NSMutableArray * buff = [[NSMutableArray alloc]init];
            for (NSString* ability in self.chess.ability){
                for (NSString* key in [[manager comboAbilityType]allKeys]){
                    if ([key containsString:ability])
                        [buff addObject:key];
                }
            }
            filterController.filterOptions = [buff copy];
            filterController.delegate = self;

            UINavigationController *navigationController =
            [[UINavigationController alloc] initWithRootViewController:filterController];

            [self.navigationController presentViewController:navigationController animated:YES completion:nil];

        }
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)setFilterOptionsByDelegate:(NSArray *)filterOptions{
    self.buff = filterOptions;
}

-(void) stepperClick:(UIStepper*)stepper{
    self.level = (int)stepper.value;
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    NSArray* arr = [[NSArray alloc]initWithObjects:indexPath, nil];
    DOTAManager* manager = [DOTAManager sharedInstance];
    NSString* str = [NSString stringWithFormat:@"%@",self.chess.name];
    for (int i=1;i<self.level;i++)str = [NSString stringWithFormat:@"%@1",str];

    self.chess.chessDictionary = [manager units][str];
    NSIndexSet* indexSet = [NSIndexSet indexSetWithIndex:2];
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
    [self.tableView reloadRowsAtIndexPaths:arr withRowAnimation:UITableViewRowAnimationNone];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];

    if (!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
    if (indexPath.section == 0){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        if (indexPath.row == 0){
            DOTAManager* manager = [DOTAManager sharedInstance];
            cell.imageView.image = [UIImage imageNamed:self.chess.imageName];
            NSString* str = [NSString stringWithFormat:@"%@",self.chess.name];
            for (int i=1;i<self.level;i++)str = [NSString stringWithFormat:@"%@1",str];

            cell.textLabel.text = NSLocalizedString(str, "");
            
            NSString* detail = [NSString stringWithFormat:@"%@:-%ld, %@:+%@",NSLocalizedString(@"Cost", ""),self.chess.mana,
                                NSLocalizedString(@"DOTA_Tooltip_ability_remove_chess", ""),[manager units][str][@"Level"]];
            NSInteger cost = 0;
            cost = self.level*self.chess.mana*3;
            if (self.level!=1)
                detail = [NSString stringWithFormat:@"%@:-%ld, %@:+%@",NSLocalizedString(@"Cost", ""),cost,
                                    NSLocalizedString(@"DOTA_Tooltip_ability_remove_chess", ""),[manager units][str][@"Level"]];
            cell.detailTextLabel.text =detail;
            if (![self.chess.name containsString:@"ssr"]){
            UIStepper * stepper = [[UIStepper alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
            cell.accessoryView = stepper;
            stepper.value = self.level;
            stepper.minimumValue = 1;
            stepper.maximumValue = 3;
            [stepper addTarget:self action:@selector(stepperClick:) forControlEvents:UIControlEventTouchUpInside];
            }

        } else if (indexPath.row == 1) {
            NSString* str = [NSString stringWithFormat:@"%@",@"Buff"];

            cell.textLabel.text = NSLocalizedString(str, "");

        } else if (indexPath.row == 2){
            NSString * str = [NSString stringWithFormat:@"%@",NSLocalizedString(@"Item", "")];
            cell.textLabel.text = str;
        }
    } else  if (indexPath.section ==1 ){
        if (indexPath.row == 0){
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
        cell.detailTextLabel.numberOfLines = 0;
        NSString* abilityLocalizedString = [[DOTAManager sharedInstance]gamedata][@"chess_ability_list"][self.chess.name];
        NSString* abilityImageName = [[DOTAManager sharedInstance]abilityImageName][abilityLocalizedString][@"AbilityTextureName"];
        if (abilityImageName ==NULL)
            abilityImageName = [NSString stringWithFormat:@"%@_png",abilityLocalizedString];
        else
            abilityImageName = [NSString stringWithFormat:@"%@_png",abilityImageName];
      
        NSString* abLo = [NSString stringWithFormat:@"DOTA_Tooltip_ability_%@",abilityLocalizedString];
        NSString* abDeLo = [NSString stringWithFormat:@"DOTA_Tooltip_ability_%@_Description",abilityLocalizedString];
        cell.imageView.image = [UIImage imageNamed:abilityImageName];
        cell.textLabel.text = NSLocalizedString(abLo, "");
        cell.detailTextLabel.text = NSLocalizedString(abDeLo, "");
//        "DOTA_Tooltip_ability_lyc_wolf"="变身";
//        "DOTA_Tooltip_ability_lyc_wolf_Description"="狼人展现出他的凶狼形态，获得生命值的加成，并且在身边的空格子召唤最多两只小狼为你作战。";
//        "DOTA_Tooltip_ability_lyc_wolf_hp_per"="生命值加成百分比";
//        "DOTA_Tooltip_ability_lyc_wolf_Lore"="贝恩霍勒接受了永恒的狼人诅咒，拥抱了他的野性，也永远成为了他狼性的奴仆。";

        } else {
            NSString* abilityLocalizedString = [[DOTAManager sharedInstance]gamedata][@"chess_ability_list"][self.chess.name];
            NSMutableDictionary* dic = [[DOTAManager sharedInstance]abilityImageName][abilityLocalizedString][@"AbilitySpecial"];
       //     cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            NSString* title;
            NSString* data;
            NSString* index = [NSString stringWithFormat:@"0%ld",indexPath.row];
            for (NSString*key in dic[index]){
                if (![key isEqualToString:@"var_type"] && ![key isEqualToString:@"LinkedSpecialBonus"]){
                    title = key;
                    data = dic[index][title];
                    break;
                }
            }
            cell.textLabel.text = NSLocalizedString(title, "");
            cell.detailTextLabel.text = data;

        }
    } else if (indexPath.section == 2){


        if (indexPath.row == 0){

            cell.textLabel.text = @"HP/MP";
            NSString* hp = [NSString stringWithFormat:@"%@",self.chess.chessDictionary[@"StatusHealth"]];
            NSString* mp = [NSString stringWithFormat:@"%@",self.chess.chessDictionary[@"StatusMana"]];
//            NSString* hpRegen = [NSString stringWithFormat:@"%ld",self.hpRegen];
//            NSString* mpRegen = [NSString stringWithFormat:@"%ld",self.mpRegen];
            NSMutableAttributedString* str = [[NSMutableAttributedString alloc]
                                              initWithString:[NSString stringWithFormat:@"%@/%@",
                                                                                 hp,mp]];
            [str addAttribute:NSForegroundColorAttributeName value:HPColor range:NSMakeRange(0, [hp length])];
            [str addAttribute:NSForegroundColorAttributeName value:MPColor range:NSMakeRange([hp length]+1, [mp length])];

            cell.detailTextLabel.attributedText = str;

        } else if(indexPath.row == 1) {
            cell.textLabel.text = NSLocalizedString(@"Damage_Name", "");
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%d",([self.chess.chessDictionary[@"AttackDamageMax"] intValue] +
                                                                           [self.chess.chessDictionary[@"AttackDamageMin"] intValue])/2];


        } else {

            DOTAManager* manager = [DOTAManager sharedInstance];
            NSString* str = [manager attribute][indexPath.row-2];
            //NSMutableDictionary* final = [[NSMutableDictionary alloc]init];
            int finalValue = [self.chess.chessDictionary[str] intValue] ;
            BOOL buff = NO;
            if (finalValue != [self.chess.chessDictionary[str] intValue])
                buff = YES;
            // Calc buff
            // ...
            // Calc buff


           //[[NSArray alloc]initWithObjects:@"MagicalResistance",@"ArmorPhysical",@"AttackRange",@"AttackRate",@"ProjectileSpeed",@"Level",nil];
            NSString* detailText = self.chess.chessDictionary[str];
            if ([str isEqualToString:@"ArmorPhysical"]){

                float reduceDamage = (0.052*finalValue/(0.9+0.048*finalValue));
                detailText = [NSString stringWithFormat:@"%d (-%.2f%%)",finalValue,reduceDamage*100];
            }
            if ([str isEqualToString:@"MagicalResistance"]){

              //  float reduceDamage = (0.052*finalValue/(0.9+0.048*finalValue));
                detailText = [NSString stringWithFormat:@"%d (-%d%%)",finalValue,finalValue];
            }
            NSString* localizedStr = [NSString stringWithFormat:@"%@_Name",str];
            if (buff)
            cell.textLabel.text = [NSString stringWithFormat:@"%@(buff)",NSLocalizedString(localizedStr, "")];
            else
                cell.textLabel.text = NSLocalizedString(localizedStr, "");

            cell.detailTextLabel.text = detailText ;
        }
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
