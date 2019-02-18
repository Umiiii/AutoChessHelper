//
//  CombinationLogic.h
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/13.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Chess.h"
NS_ASSUME_NONNULL_BEGIN

@interface CombinationLogic : NSObject
+(void) Select:(int) n
             m:(int) m
      allChess:(NSMutableArray<Chess*>*)chess
         vvOut:(NSMutableArray<NSMutableArray<Chess*>*>*) vvOut;
@end

NS_ASSUME_NONNULL_END
