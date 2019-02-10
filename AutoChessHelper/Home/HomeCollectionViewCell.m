//
//  HomeCollectionViewCell.m
//  AutoChessHelper
//
//  Created by Cirno on 2019/1/20.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import "HomeCollectionViewCell.h"

@implementation HomeCollectionViewCell
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame] ;
    if (self)
    {
        _topImage  = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _topImage.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:_topImage];

        _botlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 30, 80, 50)];
        _botlabel.textAlignment = NSTextAlignmentCenter;
        _botlabel.textColor = [UIColor blueColor];
        _botlabel.font = AppFontContentStyle();
        _botlabel.backgroundColor = [UIColor purpleColor];
        [self.contentView addSubview:_botlabel];
    }

    return self;
}

@end
