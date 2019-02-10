//
//  Chess.m
//  AutoChessHelper
//
//  Created by Cirno on 2019/1/21.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import "Chess.h"

@implementation Chess

// is_human       => silencer_curse_of_the_silent
// is_knight      => chaos_knight_phantasm
// is_assassin    => silencer_gaives_of_wisdom
// is_mage        => crystal_maiden_brilliance_aura
// is_warlock     => warlock_upheaval
// is_mech        => rattletrap_power_cogs
// is_hunter      => drow_ranger_marksmanship
// is_druid       => lone_druid_spirit_bear_entangle
// is_shaman      => disruptor_thunder_strike
// is_troll       => huskar_berserkers_blood
// is_beast       => beastmaster_greater_boar_poison
// is_elf         => wisp_overcharge
// is_demon       => nevermore_dark_lord_demon
// is_demonhunter => terrorblade_metamorphosis_alt1
// is_undead      => arc_warden_spark_wraith
// is_orc         => beastmaster_primal_roar
// is_naga        => lion_voodoo_fish
// is_goblin      => techies_minefield_sign_swine
// is_element     => brewmaster_primal_split
// is_dwarf       => sniper_take_aim
// is_ogre        => ogre_magi_multicast

- (instancetype)initWithName:(NSString *)name
                  ability:(NSArray<NSString *> *)ability
                   imageName:(NSString*)imageName{
    self = [super init];
    if (self){
        self.name = name;
        self.ability = ability;
        self.imageName = imageName;
    }
    return self;
}




@end
