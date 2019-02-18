//
//  CombinationLogic.m
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/13.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import "CombinationLogic.h"
#define FLAG_1      [NSNumber numberWithInt:1]
#define FLAG_0      [NSNumber numberWithInt:0]
#define POS_NULL    -1
@implementation CombinationLogic

- (void) GetSelectedItems:(NSMutableArray<NSNumber*>*) flags
                             flagCnt:(int) flagCnt
                 allChess:(NSMutableArray<Chess*>*) chess
                            vvCombin:(NSMutableArray<NSMutableArray<Chess*>*>*)vvCombin{
    if (NULL == flags)  nil;
    NSMutableArray* vecItems = [[NSMutableArray alloc]init];
    for (int i=0;i<flagCnt;i++)
        if (flags[i] != FLAG_0)
            [vecItems addObject:chess[i]];
    [vvCombin addObject:vecItems];
}

- (int)Find10Pos:(NSMutableArray<NSNumber*>*) flags
                flagCnt:(int)flagCnt{
    for (int i=1;i<flagCnt;i++){
        if (flags[i-1] == FLAG_1 && flags[i] == FLAG_0)
            return i-1;
    }
    return -1;

}

-(void) Swap10Pos: (NSMutableArray<NSNumber*>*) flags
              pos:(int)pos{
        flags[pos + 0] = FLAG_0;
        flags[pos + 1] = FLAG_1;

}

-(void) ShiftToLeft: (NSMutableArray<NSNumber*>*) flags
endPos:(int)endPos{
    int cnt = 0;
    for (int i = 0; i < endPos; ++i)
    {
        if (flags[i] == FLAG_1)
        {
            ++cnt;
            flags[i] = FLAG_0;
        }
    }

    for (int i = 0; i < cnt; ++i)
    {
        flags[i] = FLAG_1;
    }
}
-(BOOL) Select:(int) n
             m:(int) m
      allChess:(NSMutableArray<Chess*>*)allChess
        vvOut:(NSMutableArray<NSMutableArray<Chess*>*>*) vvOut
{
    
    if (m > n) m = n;
    NSMutableArray<NSNumber*>* flags = [[NSMutableArray alloc]init];
    if (NULL == flags) return false;
    for (int i=0;i<n;i++){
        [flags addObject:FLAG_0];
    }
    for (int i = 0; i < m; ++i)
    {
        flags[i] = FLAG_1;
    }
    [self GetSelectedItems:flags  flagCnt:n allChess:allChess vvCombin:vvOut];


    int pos = [self Find10Pos:flags flagCnt:n];
    while (pos != POS_NULL)
    {
        [self Swap10Pos:flags pos:pos];
       // Swap10Pos(flags, pos);
        [self ShiftToLeft:flags endPos:pos];
       // ShiftToLeft(flags, pos);
        [self GetSelectedItems:flags flagCnt:n allChess:allChess vvCombin:vvOut];;
       // GetSelectedItems(flags, n, vvOut);

        pos = [self Find10Pos:flags flagCnt:n];
    }

    return true;
}



+(void) Select:(int) n
             m:(int) m
      allChess:(NSMutableArray<Chess*>*)chess
         vvOut:(NSMutableArray<NSMutableArray<Chess*>*>*) vvOut{
    CombinationLogic* logic = [[CombinationLogic alloc]init];
    [logic Select:n m:m allChess:chess vvOut:vvOut];
}


@end
