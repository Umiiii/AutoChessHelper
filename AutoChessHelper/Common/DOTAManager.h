//
//  DOTAManager.h
//  AutoChessHelper
//
//  Created by Cirno on 2019/1/27.
//  Copyright © 2019 Cirno. All rights reserved.
//
//  这个类管理全局数据
//  与应用持久化配置
//

#import <Foundation/Foundation.h>
#import "Chess.h"
NS_ASSUME_NONNULL_BEGIN

@interface DOTAManager : NSObject
+(instancetype)sharedInstance;
- (void)putAttribute:(NSString*)key value:(id)value;
- (id)getAttribute:(NSString*)key;
-(NSArray*)checkBuff:(NSArray*)ch;
@property (nonatomic, strong) NSMutableDictionary *attrDict;
@property (nonatomic, strong) NSArray* chessName;
@property (nonatomic, strong) NSArray *attribute;
@property (nonatomic, strong) NSMutableDictionary *modelName;
@property (nonatomic, strong) NSMutableDictionary *abilityImageName;
@property (nonatomic, strong) NSMutableDictionary *abilityDictionary;
@property (nonatomic, strong) NSMutableDictionary *comboAbilityType;
@property (nonatomic, strong) NSMutableArray *expDictionary;
@property (nonatomic, strong) NSMutableDictionary *gamedata;
@property (nonatomic, strong) NSMutableDictionary* items;
@property (nonatomic, strong) NSMutableDictionary* units;
@property (nonatomic, strong) NSMutableDictionary* recipe;
@property (nonatomic, strong) NSMutableDictionary* allDropItemProbility;
@property (nonatomic, strong) NSArray<NSArray<Chess*>*>* allChess;
@property (nonatomic, strong) NSArray<Chess*>* allChessNotByMana;
@end

NS_ASSUME_NONNULL_END
