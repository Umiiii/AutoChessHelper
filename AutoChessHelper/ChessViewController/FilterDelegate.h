//
//  FilterDelegate.h
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/3.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef NS_ENUM(NSInteger, FilterMode) {
    FilterModeOr,
    FilterModeAnd};
@protocol FilterDelegate <NSObject>

- (void) setFilterOptionsByDelegate: (NSArray*) filterOptions;
@end

NS_ASSUME_NONNULL_END
