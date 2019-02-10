//
//  DOTAManager.m
//  AutoChessHelper
//
//  Created by Cirno on 2019/1/27.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import "DOTAManager.h"

@implementation DOTAManager

+ (instancetype)sharedInstance {
    static DOTAManager* sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        sharedInstance = [DOTAManager new];
    });
    return sharedInstance;
}

- (void)putAttribute:(NSString*)key value:(id)value{
    if (value == nil) {
        value = [NSNull null];
    }
    [self.attrDict setObject:value forKey:key];
}

- (id)getAttribute:(NSString*)key {
    return [self.attrDict valueForKey:key];
}

- (NSArray*)chessName{
    if (!_chessName){
        NSMutableArray* tmp = [self getChessName];
        _chessName = [[NSArray alloc]init];
        _chessName = [tmp copy];
    }
    return _chessName;
}

- (NSArray<Chess*>*) allChessNotByMana{
    if (!_allChessNotByMana){
        NSMutableArray* tmpArr = [[NSMutableArray alloc]init];
        for (int i = 0; i< 5; i++){
            for (NSString* chessName in self.chessName[i]){
                NSMutableDictionary* tmpDictionary = _units[chessName];
                NSString* tmp = tmpDictionary[@"Model"];
                NSUInteger pos1 = [tmp rangeOfString:@"/" options:NSBackwardsSearch].location+1;
                NSUInteger pos2 = [tmp length]-5 ;
                NSString* imageName = [NSString stringWithFormat:@"npc_dota_hero_%@_png",
                                       [tmp substringWithRange:NSMakeRange(pos1, pos2-pos1)]];
                NSMutableArray* ability = [[NSMutableArray alloc]init];
                for (NSString* keys in [tmpDictionary allKeys]){

                    if ([keys hasPrefix:@"Ability"] ){
                        NSString* str = tmpDictionary[keys];
                        // if ([str length] != 0){
                        if ([str hasPrefix:@"is_"]){
                            [ability addObject:str];
                        }
                        //}
                    }
                }
                Chess* chess = [[Chess alloc]initWithName:chessName
                                                  ability:[ability copy]
                                                imageName:imageName];
                chess.chessDictionary = [tmpDictionary copy];
                chess.mana = i+1;
                chess.ability = [[[ability sortedArrayUsingComparator:^NSComparisonResult(NSString*  obj1, NSString*   obj2) {

                    return [obj1 compare:obj2 options:NSLiteralSearch];
                }]reverseObjectEnumerator] allObjects];
                [tmpArr addObject:chess];
            }
        }
        _allChessNotByMana = [tmpArr copy];

    }
    return _allChessNotByMana;
}

-(NSArray*)attribute{
    if (!_attribute){
        _attribute = [[NSArray alloc]initWithObjects:@"MagicalResistance",@"ArmorPhysical",@"AttackRange",@"AttackRate",@"ProjectileSpeed",@"Level",nil];
    }
    return _attribute;
}

-(NSMutableDictionary*)comboAbilityType{
    if (!_comboAbilityType){
        _comboAbilityType = [[NSMutableDictionary alloc]init];
        _comboAbilityType[@"is_warrior"]=@{@"ability":@"is_warrior_buff",@"condition":@3,@"type":@1};
        _comboAbilityType[@"is_warrior1"]=@{@"ability":@"is_warrior_buff_plus",@"condition":@6,@"type":@1};
        _comboAbilityType[@"is_mage"]=@{@"ability":@"is_mage_buff",@"condition":@3,@"type":@3};
        _comboAbilityType[@"is_mage1"]=@{@"ability":@"is_mage_buff_plus",@"condition":@6,@"type":@3};
        _comboAbilityType[@"is_warlock"]=@{@"ability":@"is_warlock_buff",@"condition":@3,@"type":@2};
        _comboAbilityType[@"is_warlock1"]=@{@"ability":@"is_warlock_buff_plus",@"condition":@6,@"type":@2};
        _comboAbilityType[@"is_mech"]=@{@"ability":@"is_mech_buff",@"condition":@2,@"type":@1};
        _comboAbilityType[@"is_mech1"]=@{@"ability":@"is_mech_buff_plus",@"condition":@4,@"type":@1};
        _comboAbilityType[@"is_assassin"]=@{@"ability":@"is_assassin_buff",@"condition":@3,@"type":@1};
        _comboAbilityType[@"is_assassin1"]=@{@"ability":@"is_assassin_buff_plus",@"condition":@6,@"type":@1};
        _comboAbilityType[@"is_hunter"]=@{@"ability":@"is_hunter_buff",@"condition":@3,@"type":@1};
        _comboAbilityType[@"is_hunter1"]=@{@"ability":@"is_hunter_buff_plus",@"condition":@6,@"type":@1};
        _comboAbilityType[@"is_knight"]=@{@"ability":@"is_knight_buff",@"condition":@2,@"type":@1};
        _comboAbilityType[@"is_knight1"]=@{@"ability":@"is_knight_buff_plus",@"condition":@4,@"type":@1};
        _comboAbilityType[@"is_knight11"]=@{@"ability":@"is_knight_buff_plus_plus",@"condition":@6,@"type":@1};
        _comboAbilityType[@"is_shaman"]=@{@"ability":@"is_shaman",@"condition":@2,@"type":@5};
        _comboAbilityType[@"is_demonhunter"]=@{@"ability":@"is_demonhunter",@"condition":@0,@"type":@1};
        _comboAbilityType[@"is_troll"]=@{@"ability":@"is_troll_buff",@"condition":@2,@"type":@1};
        _comboAbilityType[@"is_troll1"]=@{@"ability":@"is_troll_buff_plus",@"condition":@4,@"type":@2};
        _comboAbilityType[@"is_beast"]=@{@"ability":@"is_beast_buff",@"condition":@2,@"type":@2};
        _comboAbilityType[@"is_beast1"]=@{@"ability":@"is_beast_buff_plus",@"condition":@4,@"type":@2};
        _comboAbilityType[@"is_beast11"]=@{@"ability":@"is_beast_buff_plus_plus",@"condition":@6,@"type":@2};
        _comboAbilityType[@"is_elf"]=@{@"ability":@"is_elf_buff",@"condition":@2,@"type":@1};
        _comboAbilityType[@"is_elf1"]=@{@"ability":@"is_elf_buff_plus",@"condition":@4,@"type":@1};
        _comboAbilityType[@"is_elf11"]=@{@"ability":@"is_elf_buff_plus_plus",@"condition":@6,@"type":@1};
        _comboAbilityType[@"is_human"]=@{@"ability":@"is_human_buff",@"condition":@2,@"type":@1};
        _comboAbilityType[@"is_human1"]=@{@"ability":@"is_human_buff_plus",@"condition":@4,@"type":@1};
        _comboAbilityType[@"is_human11"]=@{@"ability":@"is_human_buff_plus_plus",@"condition":@6,@"type":@1};
        _comboAbilityType[@"is_undead"]=@{@"ability":@"is_undead_buff",@"condition":@2,@"type":@3};
        _comboAbilityType[@"is_undead1"]=@{@"ability":@"is_undead_buff_plus",@"condition":@4,@"type":@3};
        _comboAbilityType[@"is_undead11"]=@{@"ability":@"is_undead_buff_plus_plus",@"condition":@6,@"type":@3};
        _comboAbilityType[@"is_orc"]=@{@"ability":@"is_orc_buff",@"condition":@2,@"type":@1};
        _comboAbilityType[@"is_orc1"]=@{@"ability":@"is_orc_buff_plus",@"condition":@4,@"type":@1};
        _comboAbilityType[@"is_orc11"]=@{@"ability":@"is_orc_buff_plus_plus",@"condition":@6,@"type":@1};
        _comboAbilityType[@"is_naga"]=@{@"ability":@"is_naga_buff",@"condition":@2,@"type":@2};
        _comboAbilityType[@"is_naga1"]=@{@"ability":@"is_naga_buff_plus",@"condition":@4,@"type":@2};
        _comboAbilityType[@"is_goblin"]=@{@"ability":@"is_goblin_buff",@"condition":@3,@"type":@4};
        _comboAbilityType[@"is_goblin1"]=@{@"ability":@"is_goblin_buff",@"condition":@6,@"type":@1};
        _comboAbilityType[@"is_element"]=@{@"ability":@"is_element_buff",@"condition":@2,@"type":@1};
        _comboAbilityType[@"is_element1"]=@{@"ability":@"is_element_buff_plus",@"condition":@4,@"type":@1};
        _comboAbilityType[@"is_element11"]=@{@"ability":@"is_element_buff_plus_plus",@"condition":@6,@"type":@1};
        _comboAbilityType[@"is_demon"]=@{@"ability":@"is_demon_buff",@"condition":@0,@"type":@1};
        _comboAbilityType[@"is_dwarf"]=@{@"ability":@"is_dwarf_buff",@"condition":@1,@"type":@1};
        _comboAbilityType[@"is_ogre"]=@{@"ability":@"is_ogre_buff",@"condition":@1,@"type":@1};
        _comboAbilityType[@"is_dragon"]=@{@"ability":@"is_dragon",@"condition":@3,@"type":@1};
        _comboAbilityType[@"is_druid"]=@{@"ability":@"is_druid",@"condition":@2,@"type":@1};
    }
    return _comboAbilityType;
}


-(void)initChess:(Chess*)chess{

    chess.magicalResistance = (int)chess.chessDictionary[@"MagicalResistance"];
    chess.armor = (int)chess.chessDictionary[@"ArmorPhysical"];
    chess.attackMax = (int)chess.chessDictionary[@"AttackDamageMax"];
    chess.attackMin = (int)chess.chessDictionary[@"AttackDamageMin"];
    chess.attackRange = (int)chess.chessDictionary[@"AttackRange"];
    chess.attackRate = (int)chess.chessDictionary[@"AttackRate"];
    chess.projectileSpeed = (int)chess.chessDictionary[@"ProjectileSpeed"];
    chess.hp = (int)chess.chessDictionary[@"StatusHealth"];
    chess.mp = (int)chess.chessDictionary[@"StatusMana"];
    chess.level = (int)chess.chessDictionary[@"Level"];
}

- (NSArray<NSArray<Chess*>*>*) allChess{
    if (!_allChess){
        NSMutableArray* tmp = [[NSMutableArray alloc]init];
        for (int i = 0; i< 5; i++){
            NSMutableArray* tmp2 = [[NSMutableArray alloc]init];
            for (NSString* chessName in self.chessName[i]){
                NSMutableDictionary* tmpDictionary = _units[chessName];
                NSString* tmp = tmpDictionary[@"Model"];
                NSUInteger pos1 = [tmp rangeOfString:@"/" options:NSBackwardsSearch].location+1;
                NSUInteger pos2 = [tmp length]-5 ;
                NSString* imageName = [NSString stringWithFormat:@"npc_dota_hero_%@_png",
                                           [tmp substringWithRange:NSMakeRange(pos1, pos2-pos1)]];
                NSMutableArray* ability = [[NSMutableArray alloc]init];
                for (NSString* keys in [tmpDictionary allKeys]){

                    if ([keys hasPrefix:@"Ability"] ){
                        NSString* str = tmpDictionary[keys];
                       // if ([str length] != 0){
                        if ([str hasPrefix:@"is_"]){
                            [ability addObject:str];
                        }
                        //}
                    }
                }
                Chess* chess = [[Chess alloc]initWithName:chessName
                                                  ability:[ability copy]
                                                imageName:imageName];
                chess.chessDictionary = [tmpDictionary copy];
                chess.mana = i+1;
                [self initChess:chess];
//                chess.ability = [[[ability sortedArrayUsingComparator:^NSComparisonResult(NSString*  obj1, NSString*   obj2) {
//
//                    return [obj1 compare:obj2 options:NSLiteralSearch];
//                }]reverseObjectEnumerator] allObjects];

                 [tmp2 addObject:chess];
            }
            [tmp addObject:[tmp2 copy]];
        }
        _allChess = [tmp copy];

    }
    return _allChess;
}

- (NSMutableArray*)getChessName{

    NSMutableArray<NSMutableArray*> *chess = [[NSMutableArray alloc]init];
    for (int i = 0; i<5; i++){
        NSMutableArray* arr = [[NSMutableArray alloc]init];
        [chess addObject:arr];
    }
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"npc_units_custom.txt" ofType:@"plist"];
    _units = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath][@"DOTAUnits"];
    for (NSString *unitName in [_units allKeys]){
        if ([unitName hasPrefix:@"chess"] &&
            ![unitName hasSuffix:@"1"]    &&
            ![unitName hasSuffix:@"ssr"])
        {
            NSMutableDictionary* unitDictionary = _units[unitName];
            int level = [unitDictionary[@"Level"]intValue];
            [chess[level-1] addObject:unitName];
        }
    }
    return [chess copy];
}

- (NSMutableDictionary*)modelName{


    if (!_modelName){
        _modelName = [[NSMutableDictionary alloc]init];
        NSArray* chessName = [self chessName];
        for (NSString* chess in chessName){
            NSString* tmp = _units[chess][@"Model"];
            NSUInteger pos1 = [tmp rangeOfString:@"/" options:NSBackwardsSearch].location+1;
            NSUInteger pos2 = [tmp length]-5 ;
            NSString* modelName = [NSString stringWithFormat:@"npc_dota_hero_%@_png",[tmp substringWithRange:NSMakeRange(pos1, pos2-pos1)]];
            [_modelName setValue:modelName forKey:chess];
        }

    }
    return _modelName;
}

-(NSDictionary*) abilityImageName{
    if (!_abilityImageName){

        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"npc_abilities_custom.txt" ofType:@"plist"];
        _abilityImageName = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath][@"DOTAAbilities"];
        //DLog(@"%@",_abilityImageName);
    }
    return _abilityImageName;
}

- (NSMutableDictionary*)abilityDictionary{
    if (!_abilityDictionary){
        
    }
    return _abilityDictionary;
}

-(NSArray*)checkBuff:(NSArray*)ch{
    NSArray* buff;
    NSMutableSet* ability = [[NSMutableSet alloc]init];
    NSMutableSet* chesses = [[NSMutableSet alloc]initWithArray:ch];
    NSMutableDictionary* comboCountTableSelf = [[NSMutableDictionary alloc]init];
    for (Chess* chess in chesses){
        for (NSString*key in [[self comboAbilityType]allKeys]){
            NSMutableArray * arr = [[NSMutableArray alloc]init];
            NSString* searchStr = [key stringByReplacingOccurrencesOfString:@"1" withString:@""];
            if ([chess.ability containsObject:searchStr]){
                if (comboCountTableSelf[key] != nil)
                    arr = [comboCountTableSelf[key] mutableCopy];
                [arr addObject:chess];
                comboCountTableSelf[key] = [arr copy];
            }
        }
    }
    for (NSString* str in comboCountTableSelf){
        if ([comboCountTableSelf[str] count] > (int)[self comboAbilityType][str][@"condition"]){
            [ability addObject:[self comboAbilityType][str][@"ability"]];
        }
    }
    return buff;
}

- (NSMutableDictionary*)units{
    if (!_units){
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"npc_units_custom.txt" ofType:@"plist"];
        _units = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath][@"DOTAUnits"];
    }
    return _units;
}

@end
