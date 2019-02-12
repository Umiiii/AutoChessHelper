//
//  ItemController.m
//  
//
//  Created by Cirno on 2019/2/10.
//

#import "ItemController.h"

@interface ItemController ()

@end

@implementation ItemController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Item", "");
    self.item = [[DOTAManager sharedInstance]gamedata][@"ITEM_LIST"];
    self.combinedItem = [[DOTAManager sharedInstance]gamedata][@"combined_items"];

}

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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self.item count]+1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section < [self.item count])
        return [self.item[section] count];
    else
        return [self.combinedItem count];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSString*rawName;
    NSString*imageName;
    NSString*localizedName;
    NSString*localizedDescription;
    if (!cell)
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    if (indexPath.section <( [self.item count] )){
        rawName = self.item[indexPath.section][indexPath.row];
        imageName = [[DOTAManager sharedInstance]items][rawName][@"AbilityTextureName"];
        imageName = [imageName stringByReplacingOccurrencesOfString:@"item_" withString:@""];
        imageName = [NSString stringWithFormat:@"%@_png",imageName];

    } else {
        rawName = self.combinedItem[indexPath.row];
        imageName = [[DOTAManager sharedInstance]items][rawName][@"AbilityTextureName"];
        imageName = [imageName stringByReplacingOccurrencesOfString:@"item_" withString:@""];
        imageName = [NSString stringWithFormat:@"%@_png",imageName];


    }
    localizedName = [NSString stringWithFormat:@"DOTA_Tooltip_ability_%@",rawName];
    localizedDescription = [NSString stringWithFormat:@"%@_Description",localizedName];
    UIImage* originImage = [UIImage imageNamed:imageName];
    if (originImage.size.width == 88)
        originImage = [self imageCompressForWidthScale:originImage targetWidth:44];
    else
        originImage = [self imageCompressForWidthScale:originImage targetWidth:64];
originImage = [self imageFromImage:originImage inRect:CGRectMake(0, 0, 44, 32)];
//    CGSize itemSize = CGSizeMake(44, 32);
//    UIGraphicsBeginImageContextWithOptions(itemSize, NO, UIScreen.mainScreen.scale);
//    CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
//    [originImage drawInRect:imageRect];
    cell.imageView.image = originImage;
   // UIGraphicsEndImageContext();

//
//    cell.imageView.image = originImage;
//    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    localizedDescription = NSLocalizedString(localizedDescription, "");
    localizedDescription = [localizedDescription stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
    if ([self checkRecipe:rawName]){
        localizedDescription = [NSString stringWithFormat:@"%@ %@",localizedDescription,NSLocalizedString(@"Assemble", "")];
    }
    NSMutableAttributedString *str =  [
                                       [NSMutableAttributedString alloc] initWithData:[NSLocalizedString(localizedDescription, nil) dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                       documentAttributes:nil
                                       error:nil];

    NSMutableAttributedString *name =  [
                                       [NSMutableAttributedString alloc] initWithData:[NSLocalizedString(localizedName, nil) dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType}
                                       documentAttributes:nil
                                       error:nil];
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:11.0f] range:NSMakeRange(0, str.length)];
    [name addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13.0f] range:NSMakeRange(0, name.length)];
    cell.textLabel.attributedText = name;
    cell.detailTextLabel.attributedText = str;




    cell.detailTextLabel.numberOfLines = 0;
    return cell;
}

-(BOOL)checkRecipe:(NSString*)item{
    NSMutableDictionary* recipe = [[DOTAManager sharedInstance]recipe];
    for (NSString* key in [recipe allKeys]){
        NSString*requirement = recipe[key][@"ItemRequirements"][@"01"];

        if ([requirement containsString:item])
            return YES;
    }
    return NO;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section < [self.item count])
        return [NSString stringWithFormat:@"Class %ld",section+1];
    else
        return NSLocalizedString(@"Advanced Item", "");
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    ItemDetailController* ctr = [[ItemDetailController alloc]init];
    ctr.image = [tableView cellForRowAtIndexPath:indexPath].imageView.image;
    NSString* itemName;
    if (indexPath.section < [self.item count])
        itemName = self.item[indexPath.section][indexPath.row];
    else
        itemName = self.combinedItem[indexPath.row];
    ctr.itemName = itemName;
    [self.navigationController pushViewController:ctr animated:YES];
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
