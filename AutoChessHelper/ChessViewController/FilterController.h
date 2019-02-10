//
//  FilterController.h
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/3.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FilterDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface FilterController : UITableViewController
@property (nonatomic, strong) NSArray * filterOptions;
@property (nonatomic,weak) id<FilterDelegate> delegate;
@property BOOL detail;
@end

NS_ASSUME_NONNULL_END
