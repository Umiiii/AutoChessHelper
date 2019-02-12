//
//  NPCViewController.h
//  
//
//  Created by Cirno on 2019/2/11.
//

#import <UIKit/UIKit.h>
#import "DOTAManager.h"
#import "NPCDetailViewController.h"
NS_ASSUME_NONNULL_BEGIN

@interface NPCViewController : UITableViewController
@property (nonatomic,strong) NSMutableArray* npc;
@property (nonatomic,strong) NSMutableArray* round;
@property (nonatomic,strong) NSMutableArray* attr;
@end

NS_ASSUME_NONNULL_END
