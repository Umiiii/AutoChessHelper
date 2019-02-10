//
//  ItemDetailController.h
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/10.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOTAManager.h"
NS_ASSUME_NONNULL_BEGIN

@interface ItemDetailController : UITableViewController
@property (nonatomic,strong) NSString* itemName;
@property (nonatomic,strong) UIImage* image;
@property (nonatomic,strong) NSMutableArray* destItem;
@property (nonatomic,strong) NSArray* srcItem;
@end

NS_ASSUME_NONNULL_END
