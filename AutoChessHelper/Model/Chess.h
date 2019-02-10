//
//  Chess.h
//  AutoChessHelper
//
//  Created by Cirno on 2019/1/21.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Chess : NSObject
@property (nonatomic, strong) NSString* name;
// chess_lina
@property (nonatomic, copy) NSArray<NSString*>* ability;
@property (nonatomic, strong) NSString* imageName; //缩略图名称
@property (nonatomic) NSInteger mana;
@property (nonatomic) NSInteger hp;
@property (nonatomic) NSInteger level;
@property (nonatomic) NSInteger mp;
@property (nonatomic) NSInteger projectileSpeed;
@property (nonatomic) NSInteger attackMin;
@property (nonatomic) NSInteger attackMax;
@property (nonatomic) NSInteger attackRange;
@property (nonatomic) NSInteger attackRate;
@property (nonatomic) NSInteger armor;
@property (nonatomic) NSInteger attackAnimationPoint; //攻击前摇
@property (nonatomic) NSInteger magicalResistance;
@property (nonatomic, strong) NSDictionary* chessDictionary;

// is_human
// is_mage
// lina_laguna_blade


- (instancetype)initWithName : (NSString*)name
                     ability: (NSArray<NSString*>*)ability
                    imageName:(NSString*)imageName;


@end

NS_ASSUME_NONNULL_END
