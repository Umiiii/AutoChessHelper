//
//  NPCDetailViewController.m
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/11.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import "NPCDetailViewController.h"
#import "ItemController.h"
@interface NPCDetailViewController ()

@end

@implementation NPCDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = NSLocalizedString(self.name,"");

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0)
        return 2;
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    if (indexPath.section == 0){
        if (indexPath.row == 0){
            cell.textLabel.text = NSLocalizedString(self.name, "");
            NSString* imageName = [[NSString alloc]init]   ;
            switch (self.round) {
                case 1:
                case 2:
                case 3:
                    imageName = @"npc_dota_hero_creep_radiant_png";
                    break;
                case 10:
                    imageName = @"npc_dota_neutral_granite_golem_png";
                    break;
                case 15:
                    imageName = @"npc_dota_neutral_giant_wolf_png";
                    break;
                case 20:
                    imageName = @"npc_dota_lone_druid_bear_png";
                    break;
                case 25:
                    imageName = @"npc_dota_neutral_enraged_wildkin_png";
                    break;
                case 30:
                    imageName = @"npc_dota_neutral_big_thunder_lizard_png";
                    break;
                case 35:
                    imageName = @"npc_dota_neutral_black_dragon_png";
                    break;
                case 40:
                    imageName = @"npc_dota_neutral_dark_troll_png";
                    break;
                case 45:
                    imageName = @"npc_dota_hero_default_png";
                    break;
                case 50:
                    imageName = @"npc_dota_hero_roshan_png";
                    break;
                default:
                    break;
            }
            cell.imageView.image = [UIImage imageNamed:imageName];
        }
        if (indexPath.row == 1){
            for (int i=0;i<4;i++){
                UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/4, 5, SCREEN_WIDTH/4, 20)];
                title.font = [UIFont boldSystemFontOfSize:15.0f];
                title.text = [NSString stringWithFormat:@"Class %d",i+1];
                title.textAlignment=NSTextAlignmentCenter;
                UILabel* prob = [[UILabel alloc]initWithFrame:CGRectMake(i*SCREEN_WIDTH/4, 20, SCREEN_WIDTH/4, 20)];
                prob.textAlignment = NSTextAlignmentCenter;
                
                prob.text = [NSString stringWithFormat:@"%.2f",0];
            }
        }
    }

    
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 1){
                ItemController* ctr = [[ItemController alloc]init];
                [self.navigationController pushViewController:ctr animated:YES];
            }
            break;

        default:
            break;
    }
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
