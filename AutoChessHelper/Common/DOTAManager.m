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

- (void)imageName:(NSString*)chessName{

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
        NSArray* ssrName = [[DOTAManager sharedInstance]gamedata][@"chess_list_ssr"];
        for (NSString* ssr in ssrName){
            NSMutableDictionary* tmpDictionary = [[DOTAManager sharedInstance]units][ssr];
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
            Chess* chess = [[Chess alloc]initWithName:ssr ability:ability imageName:imageName];
            chess.mana = [[[DOTAManager sharedInstance]gamedata][@"chess_2_mana"][ssr]intValue];
            chess.chessDictionary = [[DOTAManager sharedInstance]units][ssr];
            [tmpArr addObject:chess];
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
//    DLog(@"%@",[self gamedata]);
    return [self gamedata][@"combo_ability_type"];
   // return _comboAbilityType;
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
            ![unitName containsString:@"ssr"])
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

-(NSMutableDictionary*)gamedata{

    if (!_gamedata){
  
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"gamedata" ofType:@"plist"];
        _gamedata = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
    return _gamedata;
}

-(NSDictionary*) abilityImageName{
    if (!_abilityImageName){

        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"npc_abilities_custom.txt" ofType:@"plist"];
        _abilityImageName = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath][@"DOTAAbilities"];
        //DLog(@"%@",_abilityImageName);
    }
    return _abilityImageName;
}
-(NSDictionary*) items{
    if (!_items){

        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"npc_items_custom.txt" ofType:@"plist"];
        _items = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath][@"DOTAAbilities"];
   
    }
    return _items;
}
- (NSMutableDictionary*)abilityDictionary{
    if (!_abilityDictionary){
        _abilityDictionary = [self gamedata][@"chess_ability_list"];
    }
    return _abilityDictionary;
}

- (NSMutableArray*)expDictionary {
    if (!_expDictionary)
    {
        _expDictionary = [self gamedata][@"SetCustomXPRequiredToReachNextLevel"];
    }
    return _expDictionary;
}

-(NSArray*)checkBuff:(NSArray*)ch{
    NSMutableArray* buff = [[NSMutableArray alloc]init];
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
    return [buff copy];
}

- (NSMutableDictionary*)units{
    if (!_units){
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"npc_units_custom.txt" ofType:@"plist"];
        _units = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath][@"DOTAUnits"];
    }
    return _units;
}

- (NSMutableDictionary*)allDropItemProbility{
    if (!_allDropItemProbility){
        NSMutableDictionary* gamedata = [[DOTAManager sharedInstance]gamedata];
        NSMutableDictionary* tmp = gamedata[@"gailv"]; // 4
        _allDropItemProbility = tmp;
        
    }
    return _allDropItemProbility;
}

- (NSMutableDictionary*)recipe{
    if (!_recipe){
        NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"recipe.txt" ofType:@"plist"];
        _recipe = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    }
    return _recipe;
}

@end
