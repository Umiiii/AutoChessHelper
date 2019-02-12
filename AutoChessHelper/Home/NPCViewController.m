//
//  NPCViewController.m
//  
//
//  Created by Cirno on 2019/2/11.
//

#import "NPCViewController.h"

@interface NPCViewController ()

@end

@implementation NPCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (!_npc){
        NSMutableDictionary* dic = [[DOTAManager sharedInstance]gamedata][@"battle_boss"];
        NSMutableArray*t = [[dic allKeys] mutableCopy];
        self.round = [[NSMutableArray alloc]init];
        for (int i=0;i<[t count];i++){
            NSString* z = (NSString*)t[i];
            int r = [z intValue];
             [self.round addObject:[NSNumber numberWithInteger:r]];
        }
        [self.round sortUsingComparator:^NSComparisonResult(id   obj1, id   obj2) {
            return [obj1 compare:obj2];
        }];
        self.npc = [[NSMutableArray alloc]init];
        for (int i=0;i<[self.round count];i++){
            int r = [self.round[i] intValue];
            NSString* s = [NSString stringWithFormat:@"%d",r];
            [self.npc addObject:dic[s]];
        }
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.npc count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //NSString* str  = [NSString stringWithFormat:@"%d",section];
    return [self.npc[section] count];
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSString* header = [NSString stringWithFormat:@"Round %@",self.round[section]];
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    NSString* localizedString = [NSString stringWithFormat:@"%@",self.npc[indexPath.section][indexPath.row][@"enemy"]];
    NSDictionary* dic = [[DOTAManager sharedInstance]units][localizedString];
    cell.textLabel.text = NSLocalizedString(localizedString, "");
    cell.detailTextLabel.text = [NSString stringWithFormat:@"Level: %@",dic[@"Level"] ];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
