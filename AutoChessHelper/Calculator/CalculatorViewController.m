//
//  CalculatorViewController.m
//  AutoChessHelper
//
//  Created by Cirno on 2019/1/20.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import "CalculatorViewController.h"
#import "DOTAManager.h"
#define offsetOnBoard ((SCREEN_WIDTH-30)-32*6)/(5)

@interface CalculatorViewController ()

@end

@implementation CalculatorViewController
- (NSArray*)addObject:(UIButton*)imageView forArray:(NSArray*)array{
    NSMutableArray* mutableArray = [array mutableCopy];
    [mutableArray addObject:imageView];
    return [mutableArray copy];
}
- (void) loadPlist{
    DOTAManager* manager = [DOTAManager sharedInstance];
//    self.chess = [manager chessName];
    self.hero = [manager allChess];
   
}

- (void)clickOnHand:(UIButton*)button{

    // 删除该棋子

    NSMutableArray* arr = [self.selectedChess mutableCopy];
    [arr removeObject:arr[button.tag] inRange:NSMakeRange(button.tag, 1)];
    self.selectedChess = [arr copy];
    if ([self.selectedChess count] == 6 || [self.selectedChess count] == 12)
    [self updateSelectedView:YES];
    else
        [self updateSelectedView:NO];

}

- (void)clickOnChess:(UIButton*)button{

    if ([self.selectedChess count] == 18){
        return ;
    }
    NSMutableArray * arr = [self.selectedChess mutableCopy];
    [arr addObject:self.hero[button.tag/100][button.tag%100]];
    self.selectedChess = [arr copy];
    if ([self.selectedChess count] == 7 || [self.selectedChess count] == 13)
        [self updateSelectedView:NO];
    else
        [self updateSelectedView:NO];
    [self calcCombo];

}


- (void)updateSelectedView:(BOOL)animated{
  //  self.selectedArray = [[NSMutableArray alloc]init];
//
//    for (int i = 0; i < [self.selectedChess count]; i++){
//        UIButton* button;
//
//        button = [[UIButton alloc]initWithFrame:CGRectMake(15+(offset+32)*(i%6), 8 +(16+28)*(i/6), 32, 32)];
//
//        [button setImage:[UIImage imageNamed:self.selectedChess[i].imageName
//                                    inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
//                                    forState:UIControlStateNormal];
//        button.tag = i ;
//        [button addTarget:self action:@selector(clickOnHand:) forControlEvents:UIControlEventTouchUpInside];
//        self.selectedArray = [self addObject:button forArray:self.selectedArray];
//    }
    NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:0];
   // [self calcCombo];
    if (animated)

    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    else
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section !=0) return nil;

    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    UIButton *clear = [[UIButton alloc]initWithFrame:CGRectMake(10, 0, 60, 30)];

    if ([self.selectedChess count] == 0) return view;
    [view addSubview:clear];
    [clear setTitleColor:self.view.tintColor forState:UIControlStateNormal];
    clear.titleLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    [clear setTitle:NSLocalizedString(@"Clear", "") forState:UIControlStateNormal];
    [clear addTarget:self action:@selector(clearAllSelectedChess) forControlEvents:UIControlEventTouchUpInside];
    return view;
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 44;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.result = [[NSMutableArray alloc]init];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.gameInfoView = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];



    /** 初始化可选择棋子 **/
    self.filter = [NSArray arrayWithObjects:@"1 💰",@"2 💰",@"3 💰",@"4 💰",@"5 💰", nil];
    self.filter_selected = 0;
    [self loadPlist];


    self.row = ceil((double)[self.hero[0] count] /5 )+1;
    self.selectedChess = [[NSMutableArray alloc]init];
    self.selectedArray = [[NSMutableArray alloc]init];
    self.level = 4;
    self.nowResult = 1;
    [self updateSelectedView:YES];
    [self.view addSubview:self.tableView];
}
-(UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    //返回剪裁后的图片
    return newImage;
}
#define UIKitLocalizedString(key) [[NSBundle bundleWithIdentifier:@"com.apple.UIKit"] localizedStringForKey:key value:@"" table:nil]
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger oldLevel = self.level;
    NSBundle* uikitBundle = [NSBundle bundleForClass:[UIButton class]];
  //  NSString *cancel = [uikitBundle localizedStringForKey:@"Cancel" value:nil table:nil];
    if (indexPath.section == 2 && indexPath.row == 0){
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"Level" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {

            textField.placeholder = @"New Level";
            textField.keyboardType = UIKeyboardTypeNumberPad;
        }];

        [alertController addAction:[UIAlertAction actionWithTitle:[uikitBundle localizedStringForKey:@"Cancel" value:nil table:nil] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        }]];



        [alertController addAction:[UIAlertAction actionWithTitle:[uikitBundle localizedStringForKey:@"Done" value:nil table:nil] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *textField = alertController.textFields.firstObject;
            NSInteger newLevel = [textField.text integerValue];
            if (newLevel < 1 && newLevel > 10){
                newLevel = oldLevel;
            } else {
                self.level = newLevel;
                [self calcCombo];
            }
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    }


//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.bounds];
//    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
}

-(void)test{
    DLog(@"test");
}

- (void)clearAllSelectedChess{
    self.selectedChess = [[NSArray alloc]init];
    [self updateSelectedView:YES];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {

    UITableViewCell * cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.clipsToBounds = NO;
    if (indexPath.section == 0){
        //DLog(@"%ld",indexPath.row);

       // cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.row == 0){

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor clearColor];
            cell.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 44*3) ;
            //if ([self.selectedArray count] == 0) return cell;
            NSUInteger a = [self.selectedChess count]>6?6:[self.selectedChess count];
            for (int i=0; i<a; i++){
                UIButton* button;

                button = [[UIButton alloc]initWithFrame:CGRectMake(15+(offsetOnBoard+32)*(i%6), 8 , 32, 32)];

                [button setImage:[UIImage imageNamed:self.selectedChess[i].imageName
                                            inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
                        forState:UIControlStateNormal];
                button.tag = i ;
                [button addTarget:self action:@selector(clickOnHand:) forControlEvents:UIControlEventTouchUpInside];
                //self.selectedArray = [self addObject:button forArray:self.selectedArray];
                [cell.contentView addSubview:button];
            }



        } else if (indexPath.row == 1){

            //cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
            //cell.backgroundColor = [UIColor redColor];

            cell.backgroundColor = [UIColor clearColor];
            cell.userInteractionEnabled = YES;
            NSUInteger a = [self.selectedChess count] >12?12:[self.selectedChess count];
            for (int i=6; i<(a); i++){
                UIButton* button;

                button = [[UIButton alloc]initWithFrame:CGRectMake(15+(offsetOnBoard+32)*(i%6), 8 , 32, 32)];

                [button setImage:[UIImage imageNamed:self.selectedChess[i].imageName
                                            inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
                        forState:UIControlStateNormal];
                button.tag = i ;
                [button addTarget:self action:@selector(clickOnHand:) forControlEvents:UIControlEventTouchUpInside];
                //self.selectedArray = [self addObject:button forArray:self.selectedArray];
                [cell addSubview:button];
            }


        } else if (indexPath.row == 2){

            cell.backgroundColor = [UIColor clearColor];
           // cell.selectionStyle = UITableViewCellSelectionStyleDefault;
            for (int i=12; i<([self.selectedChess count]); i++){
                UIButton* button;

                button = [[UIButton alloc]initWithFrame:CGRectMake(15+(offsetOnBoard+32)*(i%6), 8 , 32, 32)];

                [button setImage:[UIImage imageNamed:self.selectedChess[i].imageName
                                            inBundle:[NSBundle mainBundle] compatibleWithTraitCollection:nil]
                        forState:UIControlStateNormal];
                button.tag = i ;
                [button addTarget:self action:@selector(clickOnHand:) forControlEvents:UIControlEventTouchUpInside];
                //self.selectedArray = [self addObject:button forArray:self.selectedArray];
                [cell addSubview:button];
            }



        }


    } else if (indexPath.section == 1){
        {
            if (indexPath.row == 0){
              //   UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.separatorInset = UIEdgeInsetsMake(0, 100000, 0, 0);
                if (!self.chessControl){
                    self.chessControl = [[UISegmentedControl alloc]initWithItems:self.filter];
                    self.chessControl.center = cell.center;
                    self.chessControl.frame = CGRectMake(0, 0, SCREEN_WIDTH, 28);
                    self.chessControl.bounds = CGRectMake(0, 0, SCREEN_WIDTH, 28);


                }
                cell.backgroundColor =[UIColor clearColor];
                [cell addSubview:self.chessControl];
                self.chessControl.selectedSegmentIndex = self.filter_selected;
                [self.chessControl addTarget:self
                                     action:@selector(filterClick)
                           forControlEvents:UIControlEventValueChanged];

            }else {
                // UITableViewCell*cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
                cell.backgroundColor = [UIColor clearColor];
                int offset;
                offset = ((SCREEN_WIDTH-30) - 32*5) / 4;
                for (int i=0;i<5;i++){
                    if ([self.hero[self.filter_selected] count]>(5)*(indexPath.row-1)+i){
                        NSString*imageName = self.hero[self.filter_selected][(5)*(indexPath.row-1)+i].imageName;

                     //DLog(@"%@",imageName);
                        UIImage* name = [UIImage imageNamed:imageName];
                        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(15+(offset+32)*i, 8, 32, 32)];
                        [button setImage:name forState:UIControlStateNormal];
                        button.tag = self.filter_selected * 100 +(5)*(indexPath.row-1)+i;
                        // 第一位：mana 第二位：棋子
                        [button addTarget:self action:@selector(clickOnChess:) forControlEvents:UIControlEventTouchUpInside];
                        [cell addSubview:button];
                    }
                }

            }
        }
    } else if (indexPath.section == 2){
        if (indexPath.row == 0){
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = [NSString stringWithFormat:@"Level %d",(int)self.level];
            return cell;
//            if (!self.stepper){
//            self.stepper = [[UIStepper alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-100, 6, 0, 0)];
//            self.stepper.minimumValue = 1;
//            self.stepper.maximumValue = 10;
//            }
//            self.stepper.value = self.level;
//            [cell addSubview:self.stepper];
//
//            [_stepper addTarget:self action:@selector(stepperClick) forControlEvents:UIControlEventTouchUpInside];
        } else {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
            UIView* imageView = [[UIView alloc]initWithFrame:CGRectMake(15, 7.5, SCREEN_WIDTH-15, 32)];
            for (int i=0;i<[self.result[indexPath.row-1] count];i++){
                CGFloat offset = (SCREEN_WIDTH-350) / 10;
                if (offset <0) offset = 0;
                UIImageView* image = [[UIImageView alloc]initWithFrame:CGRectMake(i*32+i*offset, 0, 32, 32)];
                image.image = [UIImage imageNamed:self.result[indexPath.row-1][i].imageName];
                [imageView addSubview:image];
            }
            NSString* finalStr ;
            for (int i=0;i<[self.finalComboResult[indexPath.row-1] count];i++){
                NSString* localizedStr = [NSString stringWithFormat:@"%@",self.finalComboResult[indexPath.row-1][i]];
                NSString * desc = [NSString stringWithFormat:@"DOTA_Tooltip_modifier_%@_buff_Description",localizedStr];
                localizedStr = [NSString stringWithFormat:@"DOTA_Tooltip_modifier_%@_buff",localizedStr];
                if ([localizedStr hasSuffix:@"11_buff"]){
                    localizedStr = [NSString stringWithFormat:@"%@_buff_plus_plus",[localizedStr stringByReplacingOccurrencesOfString:@"11_buff" withString:@""]];
                    desc = [NSString stringWithFormat:@"%@_buff_plus_plus_Description",
                    [desc stringByReplacingOccurrencesOfString:@"11_buff_Description" withString:@""]]
                    ;

                }
                if ([localizedStr hasSuffix:@"1_buff"]){
                    localizedStr = [NSString stringWithFormat:@"%@_buff_plus",[localizedStr stringByReplacingOccurrencesOfString:@"1_buff" withString:@""]];
                    desc = [NSString stringWithFormat:@"%@_buff_plus_Description",
                            [desc stringByReplacingOccurrencesOfString:@"1_buff_Description" withString:@""]]
                    ;
                }
                if ([localizedStr hasSuffix:@"druid_buff"]){
                    localizedStr = @"DOTA_Tooltip_ability_is_druid";
                    desc = @"";
                }
                DLog(@"%@",localizedStr);
                NSString* lstr = NSLocalizedString(desc, "");
                lstr = [lstr stringByReplacingOccurrencesOfString:@"%%" withString:@"%"];
                lstr = [NSString stringWithFormat:@"%@:%@",NSLocalizedString(localizedStr, ""),lstr];
                if (finalStr == NULL)
                    finalStr = lstr ;
                else
                    finalStr = [NSString stringWithFormat:@"%@\n%@",finalStr,lstr];
            }


            [cell addSubview:imageView];
           // [cell.textLabel addSubview:imageView];
            UILabel* detail = [[UILabel alloc]initWithFrame:CGRectMake(15, 32, SCREEN_WIDTH, 25+[self.finalComboResult[indexPath.row-1] count]*15)];
            detail.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
            detail.text = finalStr;
            [cell addSubview:detail];
            detail.numberOfLines = 0;
            //cell.detailTextLabel.text = finalStr;
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;

}

-(NSArray*)calcAbilityCombo:(NSMutableArray<Chess*>*) chess{
   //return [[DOTAManager sharedInstance]checkBuff:[chess copy] ];
    NSMutableDictionary* combo = [[DOTAManager sharedInstance]comboAbilityType];
    NSMutableArray* comboFinal = [[NSMutableArray alloc]init];
    NSMutableDictionary* tmpChess = [[NSMutableDictionary alloc]init];// 棋子种族计数
    for (Chess* c in chess){
        for (NSString* ability in c.ability){
            if ([tmpChess valueForKey:ability]){
                NSNumber* count = [tmpChess objectForKey:ability];
                count = [NSNumber numberWithInt:[count intValue]+1];

                [tmpChess setValue:count forKey:ability];
            } else {
                [tmpChess setValue:[NSNumber numberWithInt:1] forKey:ability];
            }
        }
    }
    for (NSString* c in combo){
     //   for (NSString* k in [combo[c] allKeys]){
        NSMutableDictionary* dic = combo[c];
        NSString* k = c;
        NSString* oriStr = [k stringByReplacingOccurrencesOfString:@"1" withString:@""];
        NSNumber* count = [tmpChess valueForKey:oriStr];
        int condition = [dic[@"condition"]intValue];
        if (count!=NULL){
                DLog(@"%@, %@",oriStr,count);
                int cou = [count intValue];
                if (cou >= condition){
                    [comboFinal addObject:c];
                }

     //       }
        }
    }
    DLog(@"Combo = %@",comboFinal);
    return [comboFinal copy];
}


- (void)calcCombo{

#define FLAG_1      1
#define FLAG_0      0
#define POS_NULL    -1

    NSMutableArray* combination = [[NSMutableArray alloc]init];
    NSMutableSet* set1 = [[NSMutableSet alloc]initWithArray:self.selectedChess ];
    NSMutableArray* finalArray = [[set1 allObjects] mutableCopy];
    DLog(@"FinalArray = %@",finalArray);


    [CombinationLogic Select:(int)[finalArray count]
                           m:(int)self.level
                    allChess:finalArray
                       vvOut:combination];
    self.result = combination;
    //DLog(@"%lu %@",(unsigned long)(int)[combination count],combination);

    self.finalResult = [[NSMutableArray alloc]init];
    self.finalComboResult = [[NSMutableArray alloc]init];
    DLog(@"Combination = %@",self.result);
    for (int i=0;i<[self.result count];i++){
        NSArray* combo = [self calcAbilityCombo:self.result[i]];
        DLog(@"Combo = %@",combo);
        if ([combo count] != 0) // 如果没有能组合的技能就不要
        {
            [self.finalResult addObject:self.result[i]];
            [self.finalComboResult addObject:combo];
        }
    }
    self.result = self.finalResult;
    DLog(@"%@",self.result);
    NSInteger resultCount = [self.result count]+1;
    NSIndexSet* set = [NSIndexSet indexSetWithIndex:2];
    self.nowResult = resultCount;
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
    DLog(@"%@",[self calcAbilityCombo:finalArray]);


}


- (void) stepperClick{
    self.level = (NSInteger)_stepper.value;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:2];
   // [self updateOnBoardView];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    [self calcCombo];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0){
        return 28;
    }
    if (indexPath.section == 0 || indexPath.section == 1)
        return 44;
    if (indexPath.section == 2 && indexPath.row != 0){

       return 44 + 10+[self.finalComboResult[indexPath.row-1] count] * 15;
    }

    return UITableViewAutomaticDimension;
}
- (void)filterClick{
    self.filter_selected = self.chessControl.selectedSegmentIndex;
    NSIndexSet* set = [NSIndexSet indexSetWithIndex:1];
    [_tableView reloadSections:set withRowAnimation:UITableViewRowAnimationNone];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{

    if (section == 0){
        return NSLocalizedString(@"Selected", "棋盘上的棋子");
    } else if (section == 2) {
        return NSLocalizedString(@"Result", "棋手信息");
    } else if (section == 1) {
        return NSLocalizedString(@"Choose Chess", "");
    }
    return @"";
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        if ([self.selectedChess count] == 0) return 1;
        return ceil((double)[self.selectedChess count] / 6) ;
    }
    if (section == 2){

        return self.nowResult;
    }
    if (section == 1){
        NSInteger heroCount = ceil((double)[self.hero[self.filter_selected] count]/5)+1;
        NSInteger rowCount = self.row;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
        NSInteger offset = rowCount - heroCount;
        while (offset < 0) {
            offset ++;
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        while (offset > 0) {
            offset --;
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        }
        self.row = heroCount;
        return heroCount;
    }

    return 0;
}

@end
