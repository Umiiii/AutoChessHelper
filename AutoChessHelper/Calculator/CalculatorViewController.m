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
        [self updateSelectedView:YES];
    else
        [self updateSelectedView:NO];

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
    if (animated)

    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    else
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    self.level = 1;
    self.round = 1;
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

//    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.selectedBackgroundView = [[UIView alloc]initWithFrame:cell.bounds];
//    cell.selectedBackgroundView.backgroundColor = [UIColor clearColor];
}

-(void)test{
    DLog(@"test");
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
            NSArray*exp = [[NSArray alloc]initWithObjects:@(0),@(1),@(2),@(4),@(8),@(16),@(32),@(56),@(88),@(0), nil];
          //  UITableViewCell* cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@  %ld, %@ Exp⬆️",NSLocalizedString(@"Level", ""),(long)self.level,exp[self.level]];
            //cell.textLabel.textAlignment = NSTextAlignmentCenter;
            if (!self.stepper){
                self.stepper = [[UIStepper alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-104, (44-29)/2, 0, 0)];
                _stepper.value = 1;
                _stepper.stepValue = 1;
                _stepper.maximumValue = 10;
                _stepper.minimumValue = 1;
                [_stepper addTarget:self action:@selector(stepperClick) forControlEvents:UIControlEventValueChanged];
            }
            NSString* localizedString = [NSString stringWithFormat:@"DOTA_Tooltip_modifier_hero_level%ld_Description",(long)self.level];
            localizedString = NSLocalizedString(localizedString, nil);
            localizedString = [localizedString stringByReplacingOccurrencesOfString:@"\%\%" withString:@"\%"];
            //            localizedString = [localizedString stringByReplacingOccurrencesOfString:@"($1)" withString:@""];
            //            localizedString = [localizedString stringByReplacingOccurrencesOfString:@"($2)" withString:@""];
            //            localizedString = [localizedString stringByReplacingOccurrencesOfString:@"($3)" withString:@""];
            //            localizedString = [localizedString stringByReplacingOccurrencesOfString:@"($4)" withString:@""];
            //            localizedString = [localizedString stringByReplacingOccurrencesOfString:@"($5)" withString:@""];
            localizedString = [localizedString stringByReplacingOccurrencesOfString:@"<br>" withString:@" "];
            localizedString = [localizedString stringByReplacingOccurrencesOfString:@"Chess:" withString:@""];
            localizedString = [NSString stringWithFormat:@"<center>%@</center>",localizedString];
            NSMutableAttributedString *str =  [
                                               [NSMutableAttributedString alloc] initWithData:[NSLocalizedString(localizedString, nil) dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                               documentAttributes:nil
                                               error:nil];
            [str addAttribute:NSFontAttributeName value:AppFontContentStyle() range:NSMakeRange(0, str.length)];
            self.gameInfoView.numberOfLines = 0;
            self.gameInfoView.attributedText =  str;
            [cell addSubview:_stepper];


        } else if (indexPath.row == 1){
           //  UITableViewCell*cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"cell"];
            cell.textLabel.text = [NSString stringWithFormat:@"Round %ld",(long)self.round];
            if (!self.roundStepper){
                self.roundStepper = [[UIStepper alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-104, (44-29)/2, 0, 0)];
                self.roundStepper.value = 1;
                self.roundStepper.stepValue = 1;
                self.roundStepper.maximumValue = 100;
                [self.roundStepper addTarget:self action:@selector(roundStepperClick) forControlEvents:UIControlEventValueChanged];

                // Fatigue = self.round - 50;
            }
            if (self.round > 50){
                cell.textLabel.text = [NSString stringWithFormat:@"%@ ⚠️%@ %ld",cell.textLabel.text,NSLocalizedString(@"Fatigue damage", ""),self.round-50];

            }
            [cell addSubview:self.roundStepper];

        } else if (indexPath.row == 2){
           //  UITableViewCell*cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];//
            NSString* text = [NSString stringWithFormat:@"pve_%ld",(long)self.round];
            cell.textLabel.text = NSLocalizedString(text, "");
            NSString* imageName = [[NSString alloc]init]   ;
            switch (self.round) {
                case 1:
                case 2:
                case 3:
                    imageName = @"npc_dota_hero_creep_radiant_png";
                    break;
                case 10:
                    imageName = @"npc_dota_neutral_granite_golem_png";
                    break;
                case 15:
                    imageName = @"npc_dota_neutral_giant_wolf_png";
                    break;
                case 20:
                    imageName = @"npc_dota_lone_druid_bear_png";
                    break;
                case 25:
                    imageName = @"npc_dota_neutral_enraged_wildkin_png";
                    break;
                case 30:
                    imageName = @"npc_dota_neutral_big_thunder_lizard_png";
                    break;
                case 35:
                    imageName = @"npc_dota_neutral_black_dragon_png";
                    break;
                case 40:
                    imageName = @"npc_dota_neutral_dark_troll_png";
                    break;
                case 45:
                    imageName = @"npc_dota_hero_default_png";
                    break;
                case 50:
                    imageName = @"npc_dota_hero_roshan_png";
                    break;
                default:
                    break;
            }
            imageName = [NSString stringWithFormat:@"full_%@",imageName];
            cell.imageView.autoresizingMask = ( UIViewAutoresizingNone );
            cell.imageView.autoresizesSubviews = NO;
            cell.imageView.layer.masksToBounds = YES;
            cell.imageView.bounds = CGRectMake(0, 0, 128, 72);
            cell.imageView.frame = CGRectMake(0, 0, 128, 72);
            cell.imageView.contentMode = UIViewContentModeTop;
            cell.imageView.image = [self imageFromImage:[UIImage imageNamed:imageName]inRect:CGRectMake(0, 0, 128, 72)];
           
        }
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;

}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 2){
        UIView* view = [[UIView alloc]initWithFrame:CGRectMake(20, 0, SCREEN_WIDTH-20, 100)];
        [view addSubview:self.gameInfoView];
        return view;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2){

        return 44;
    }
    return 0;
}
- (void) stepperClick{
    self.level = (NSInteger)_stepper.value;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:2];
   // [self updateOnBoardView];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

}


- (void) roundStepperClick{
    self.round = (NSInteger)_roundStepper.value;
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:2];
    NSIndexPath *indexPath2=[NSIndexPath indexPathForRow:2 inSection:2];
    if (self.round == 1 || self.round == 2 || self.round == 3 || self.round == 10 || self.round == 15 || self.round == 20 ||
        self.round == 25 || self.round == 30 || self.round == 35 || self.round == 40 || self.round == 45 || self.round == 50){
        if ([self.tableView cellForRowAtIndexPath:indexPath2] == nil)
        [self.tableView insertRowsAtIndexPaths:@[indexPath2 ] withRowAnimation:UITableViewRowAnimationFade];
    } else {
        if ([self.tableView cellForRowAtIndexPath:indexPath2] != nil)
        [self.tableView deleteRowsAtIndexPaths:@[indexPath2] withRowAnimation:UITableViewRowAnimationFade];
    }
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1 && indexPath.row == 0){
        return 28;
    }
    if (indexPath.section == 0 || indexPath.section == 1)
        return 44;
    if (indexPath.section == 2 && indexPath.row == 2)
        return 72;

    return 44;
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
        return NSLocalizedString(@"Game info", "棋手信息");
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
        if (self.round == 1 || self.round == 2 || self.round == 3)
            return 3;
        if (self.round >= 10)
            if (self.round % 5 == 0)
                return 3;
        return 2;
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
