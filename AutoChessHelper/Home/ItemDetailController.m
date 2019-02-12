//
//  ItemDetailController.m
//  AutoChessHelper
//
//  Created by Cirno on 2019/2/10.
//  Copyright © 2019 Cirno. All rights reserved.
//

#import "ItemDetailController.h"

@interface ItemDetailController ()

@end

@implementation ItemDetailController
-(UIImage *) imageCompressForWidthScale:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{

    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

    if(CGSizeEqualToSize(imageSize, size) == NO){

        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;

        if(widthFactor > heightFactor){

            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;

        }else if(widthFactor < heightFactor){

            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }

    UIGraphicsBeginImageContext(size);

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [sourceImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();

    if(newImage == nil){

        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}

-(NSString*)imageName:(NSString*)itemName{
    NSString* imageName;
    itemName = [itemName stringByReplacingOccurrencesOfString:@"_recipe" withString:@""];
    imageName = [[DOTAManager sharedInstance]items][itemName][@"AbilityTextureName"];
    imageName = [imageName stringByReplacingOccurrencesOfString:@"item_" withString:@""];
    imageName = [NSString stringWithFormat:@"%@_png",imageName];
    return imageName;
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
- (void)viewDidLoad {
    [super viewDidLoad];
    if (!self.image){
        NSString*imageName;
        imageName = [[DOTAManager sharedInstance]items][self.itemName][@"AbilityTextureName"];
        self.image = [self handleImage:imageName];

    }
    self.destItem  = [[NSMutableArray alloc]init];
    NSString*localizedName = [NSString stringWithFormat:@"DOTA_Tooltip_ability_%@",self.itemName];
    NSMutableAttributedString *name =  [
                                        [NSMutableAttributedString alloc] initWithData:[NSLocalizedString(localizedName, nil) dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                        documentAttributes:nil
                                        error:nil];

    self.title = [[name mutableString]copy];


    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT) style:UITableViewStyleGrouped];
    NSMutableDictionary* recipe = [[DOTAManager sharedInstance]recipe];
    if ([self checkRecipe:self.itemName]){

        // 找原料
        NSString* s = [NSString stringWithFormat:@"item_recipe_%@",[self.itemName stringByReplacingOccurrencesOfString:@"item_" withString:@""]];
        self.image = [self handleImage:[self imageName:s]];
        NSMutableString* str = recipe[s][@"ItemRequirements"][@"01"];

        self.srcItem = [str componentsSeparatedByString:@";"];
        DLog(@"trim:%@",self.srcItem);

    }
    for (NSString* str in [recipe allKeys]){
        NSString* requirement = recipe[str][@"ItemRequirements"][@"01"];
        if ([requirement containsString:self.itemName])
            [self.destItem addObject:recipe[str][@"ItemResult"] ];

    }

}


#pragma mark - Table view data source

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return NSLocalizedString(@"Item", "");
            break;
        case 1:
            return NSLocalizedString(@"Assemable Item", "");
            break;
        case 2:
            return NSLocalizedString(@"Recipe", "");
            break;
        default:
            break;
    }
    return  nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0)
        return ;
    ItemDetailController* ctr = [[ItemDetailController alloc]init];
    NSString* itemName;
    if (indexPath.section == 1)
        itemName = self.destItem[indexPath.row];
    else if (indexPath.section == 2)
        itemName = self.srcItem[indexPath.row];
    ctr.itemName = itemName;
    [self.navigationController pushViewController:ctr animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self checkRecipe:self.itemName])
        return 3;
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0)
        return 2;
    if (section == 1)
        return [self.destItem count];
    if (section == 2)
        return [self.srcItem count];
    return 1;
}

- (UIImage*)handleImage:(NSString*)imageName{
    imageName = [imageName stringByReplacingOccurrencesOfString:@"item_" withString:@""];
    DLog(@"name=%@",imageName);

    UIImage* originImage = [UIImage imageNamed:imageName];
    DLog(@"ori=%@",originImage);
    if (originImage.size.width == 88)
        originImage = [self imageCompressForWidthScale:originImage targetWidth:44];
    else
        originImage = [self imageCompressForWidthScale:originImage targetWidth:64];
    originImage = [self imageFromImage:originImage inRect:CGRectMake(0, 0, 44, 32)];
    return originImage;

}
-(NSString*)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (section == 0){
        return NSLocalizedString(@"Item drop probability", "");

    } return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1)
        return  80.0f;
    return UITableViewAutomaticDimension;
}
-(BOOL)checkRecipe:(NSString*)item{
    NSMutableDictionary* recipe = [[DOTAManager sharedInstance]recipe];
    for (NSString* key in [recipe allKeys]){
        NSString*kt = [key stringByReplacingOccurrencesOfString:@"recipe_" withString:@""];
        if ([kt isEqualToString:item]) return  YES;

    }
    return NO;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" ];
    if (!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    NSString*localizedName;
    NSString*localizedDescription;
   // NSString*imageName;
    float titleSize = 13,detailSize = 11;
    cell.detailTextLabel.numberOfLines = 0;
    if(indexPath.section == 0){
        if (indexPath.row == 1){
           // cell.textLabel.text = NSLocalizedString(@"Item drop probability", "");
            for (int i=0;i<9;i++){
                UILabel* title = [[UILabel alloc]initWithFrame:CGRectMake(i*(SCREEN_WIDTH/9), 5, (SCREEN_WIDTH/9), 20)];
                title.text = [NSString stringWithFormat:@"%d",i+1];
                title.textAlignment = NSTextAlignmentCenter;
                title.font = [UIFont boldSystemFontOfSize:12.0f];
                UILabel* prob = [[UILabel alloc]initWithFrame:CGRectMake(i*(SCREEN_WIDTH/9), 20, (SCREEN_WIDTH/9), 20)];
                prob.textAlignment = NSTextAlignmentCenter;
                NSArray* p = [[DOTAManager sharedInstance]allDropItemProbility][self.itemName][@"p"];
                int count =[[[DOTAManager sharedInstance]allDropItemProbility][self.itemName][@"count"] intValue];
                float prob1 = [p[i] floatValue] / count;
                prob.font = [UIFont systemFontOfSize:9.0f];
                prob.text = [NSString stringWithFormat:@"%.2f%%",prob1];
                [cell addSubview:title];
                [cell addSubview:prob];

            }
            return cell;
        }
        localizedName = [NSString stringWithFormat:@"DOTA_Tooltip_ability_%@",self.itemName];
        localizedDescription = [NSString stringWithFormat:@"%@_Description",localizedName];
        titleSize = 16;
        detailSize = 14;
        cell.imageView.image = self.image;
    }
    if (indexPath.section == 1){
        localizedName = [NSString stringWithFormat:@"DOTA_Tooltip_ability_%@",self.destItem[indexPath.row]];
        localizedDescription = [NSString stringWithFormat:@"%@_Description",localizedName];
       // imageName = [NSString stringWithFormat:@"%@_png",self.destItem[indexPath.row]];
        cell.imageView.image = [self handleImage:[self imageName:self.destItem[indexPath.row]]];
    }
    if (indexPath.section == 2){
        localizedName = [NSString stringWithFormat:@"DOTA_Tooltip_ability_%@",self.srcItem[indexPath.row]];
        localizedDescription = [NSString stringWithFormat:@"%@_Description",localizedName];

        cell.imageView.image = [self handleImage:[self imageName:self.srcItem[indexPath.row]]];
    }
        NSMutableAttributedString *str =  [
                                           [NSMutableAttributedString alloc] initWithData:[NSLocalizedString(localizedDescription, nil) dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                           documentAttributes:nil
                                           error:nil];

        NSMutableAttributedString *name =  [
                                            [NSMutableAttributedString alloc] initWithData:[NSLocalizedString(localizedName, nil) dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                            documentAttributes:nil
                                            error:nil];
        [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:detailSize] range:NSMakeRange(0, str.length)];
        [name addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:titleSize] range:NSMakeRange(0, name.length)];
        cell.textLabel.attributedText = name;
        cell.detailTextLabel.attributedText = str;



    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
