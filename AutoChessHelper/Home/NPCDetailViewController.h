//
//  NPCDetailViewController.h
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/11.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOTAManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface NPCDetailViewController : UITableViewController
@property (nonatomic,strong) NSMutableDictionary* dic;
@property (nonatomic,strong) NSString* name;
//@property (nonatomic,strong) NSString* imageName;
@property int round;
@end

NS_ASSUME_NONNULL_END
