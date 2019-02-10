//
//  AutoChessHelperTests.m
//  AutoChessHelperTests
//
//  Created by Cirno on 2019/2/10.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DOTAManager.h"
@interface AutoChessHelperTests : XCTestCase
@property (nonatomic) DOTAManager* manager;
@end

@implementation AutoChessHelperTests

- (void)setUp {
    _manager = [DOTAManager sharedInstance];

    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
}

- (void)testDOTAManagerInitalize {
    XCTAssert(_manager);
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testDOTAManagerGameData{
 //   NSLog(@"%@",[_manager gamedata]);
    XCTAssert([_manager gamedata]);
}

- (void)testDOTAManagerDropItemGailv{
    NSMutableDictionary* gailv = [_manager gamedata][@"drop_item_gailv"];
 //   NSLog(@"%@",[_manager gamedata][@"drop_item_gailv"]);
    XCTAssert(gailv);
}

-(void)testDOTAManagerComboAbilityType{
    NSMutableDictionary* abilityType = [_manager gamedata][@"combo_ability_type"];
    NSLog(@"%@",abilityType);
    XCTAssert(abilityType);
}

-(void)testDOTAManagerAbilityBehaviorList{
    NSMutableDictionary* behaviorList = [_manager gamedata][@"ability_behavior_list"];
    XCTAssert(behaviorList);
    XCTAssert(behaviorList[@"a108"]);
    XCTAssert(behaviorList[@"bump"]);
}

-(void)testDOTAManagerAbility{
    NSMutableDictionary* abilityDictionary = [_manager gamedata][@"chess_ability_list"];
    XCTAssert(abilityDictionary);
   // NSMutableDictionary* abilityBehaviorList = [_manager gamedata][@"ability_behavior_list"];

}
-(void)testItemList{
    NSMutableArray* item = [[DOTAManager sharedInstance]gamedata][@"ITEM_LIST"];
    XCTAssert(item);
    XCTAssert(item[0]);
    XCTAssert(item[1]);
    XCTAssert(item[2]);
}

@end
