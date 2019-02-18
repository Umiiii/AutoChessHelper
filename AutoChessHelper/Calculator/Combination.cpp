//
//  Combination.c
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/13.
//  Copyright © 2019 Cirno. All rights reserved.
//

#include "Combination.h"
#include <stdlib.h>
#include <stdio.h>
#include <memory.h>
#include <vector>

using namespace std;

#define FLAG_1      1
#define FLAG_0      0
#define POS_NULL    -1

void GetSelectedItems(char *flags, int flagCnt, vector<vector<int> > &vvCombin)
{
    if (NULL == flags) return;

    vector<int> vecItems;

    for (int i = 0; i < flagCnt; ++i)
    {
        if (flags[i] != FLAG_0) vecItems.push_back(i);
    }

    vvCombin.push_back(vecItems);
}

int Find10Pos(char *flags, int flagCnt)
{
    for (int i = 1; i < flagCnt; ++i)
    {
        if (flags[i - 1] == FLAG_1 && flags[i] == FLAG_0)
        {
            return i - 1;
        }
    }

    return -1;
}

void Swap10Pos(char *flags, int pos)
{
    //10->01
    flags[pos + 0] = FLAG_0;
    flags[pos + 1] = FLAG_1;
}

void ShiftToLeft(char *flags, int endPos)
{
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

bool Select(int n, int m, vector<vector<int> > &vvOut)
{
    if (m > n) return false;

    vvOut.clear();
    char *flags = new char[n];
    if (NULL == flags) return false;

    memset(flags, false, n);
    for (int i = 0; i < m; ++i)
    {
        flags[i] = true;
    }
    GetSelectedItems(flags, n, vvOut);

    int pos = Find10Pos(flags, n);
    while (pos != POS_NULL)
    {
        Swap10Pos(flags, pos);
        ShiftToLeft(flags, pos);

        GetSelectedItems(flags, n, vvOut);

        pos = Find10Pos(flags, n);
    }

    delete[]flags;
    return true;
}
