//
//  ItemController.h
//  
//
//  Created by Cirno on 2019/2/10.
//

#import <UIKit/UIKit.h>
#import "DOTAManager.h"
#import "ItemDetailController.h"
NS_ASSUME_NONNULL_BEGIN

@interface ItemController : UITableViewController
@property (nonatomic,strong) NSMutableArray* item;
@property (nonatomic,strong) NSMutableArray* combinedItem;
@end

NS_ASSUME_NONNULL_END
