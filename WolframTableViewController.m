//
//  WolframTableViewController.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 11/11/15.
//  Copyright © 2015 Nishanth Salinamakki. All rights reserved.
//

#import "WolframTableViewController.h"

@interface WolframTableViewController ()

@end

@implementation WolframTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.selectedIndex = -1;
    
    self.tableView.delegate = self;
    
    [self.navigationItem setTitle: @"Cipher DataPad"];
    
    //[self.navigationController.navigationBar setBarTintColor: self.cellBackgroundColor];
    [self.navigationController.navigationBar setTintColor: self.cellBackgroundColor];
    
    [self.tableView setSeparatorStyle: UITableViewCellSeparatorStyleSingleLine];
    [self.tableView setSeparatorColor: self.cellBackgroundColor];
    
    NSLog(@"POD ID ARRAY IN WTVC: %@", self.podIDArray);
    NSLog(@"POD ID LINK ARRAY IN WTVC: %@", self.podImagesLinkArray);
    
    NSLog(@"POD STATE NAME IN WTVC: %@", self.podStateName);
    NSLog(@"POD STATE LINK IN WTVC: %@", self.podStateLink);
    NSLog(@"POD STATE IMAGE LINK IN WTVC: %@", self.podStateImageLink);
    
    /*
    NSLog(@"POD STATE NAME ARRAY IN WTVC: %@", self.podStatesNamesArray);
    NSLog(@"POD STATE LINK ARRAY IN WTVC: %@", self.podStatesLinksArray);
    NSLog(@"POD STATE LINK IMAGE ARRAY IN WTVC: %@", self.podStatesImagesLinksArray);
    */

    UIBarButtonItem *shareDataButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCamera target: self action: @selector(saveWolframData)];
    UIBarButtonItem *saveDataButton = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"MLTW_Export"] style: UIBarButtonItemStyleDone target: self action: @selector(displayActivityViewController)];
    self.navigationItem.leftBarButtonItems = @[shareDataButton, saveDataButton];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemDone target: self action: @selector(removeViewController)];
    NSData *data = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: [self.podImagesLinkArray objectAtIndex: 0]]];
    
    self.dataScreenshotCollectionViewController = [[DataScreenshotCollectionViewController alloc] init];
}

- (void) removeViewController {
    [self dismissViewControllerAnimated: YES completion: nil];
}

- (void) displayActivityViewController {
    CGRect screen = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(screen.size);
    [self.view.window.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *dataScreenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    NSArray *dataArray = @[dataScreenshot];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems: dataArray applicationActivities: nil];
    [self presentViewController: activityVC animated:YES completion:nil];
}

- (void) saveWolframData {
    //Take a screenshot and save it to photos
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)])
        UIGraphicsBeginImageContextWithOptions(self.view.bounds.size, NO, [UIScreen mainScreen].scale);
    else
        UIGraphicsBeginImageContext(self.view.bounds.size);
    [self.view.window.layer renderInContext: UIGraphicsGetCurrentContext()];
    UIImage *dataScreenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(dataScreenshot, nil, nil, nil);
    NSData *imageData = UIImagePNGRepresentation(dataScreenshot);
    [self.screenshotDataArray addObject: imageData];
    self.dataScreenshotCollectionViewController.screenshotDataArray = self.screenshotDataArray;
    
    [TAOverlay showOverlayWithLabel: @"Photo Saved!" Options: TAOverlayOptionOverlayTypeSuccess | TAOverlayOptionAutoHide | TAOverlayOptionOverlaySizeRoundedRect];
    [TAOverlay setOverlayIconColor: self.cellBackgroundColor];
    [TAOverlay setOverlayLabelTextColor: self.cellBackgroundColor];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.podImagesLinkArray count];
    }
    else if (section == 1) {
        return 1;
    }
    else {
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"WolframCell"];
    if (cell == nil) {
        cell = [[WolframTableViewCell alloc] initWithStyle: UITableViewCellStyleDefault reuseIdentifier: @"WolframCell"];
    }
    
    if (indexPath.section == 0) {
        cell.backgroundColor = self.cellBackgroundColor;//[[UIColor alloc] initWithRed: 172.0/255.0 green: 102.0/255.0 blue: 1.0 alpha: 0.1];
        
        UILabel *podLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 10, 250, 50)];
        podLabel.font = [UIFont fontWithName: @"Avenir Next" size: 16.0];
        podLabel.text = [self.podIDArray objectAtIndex: indexPath.row];
        podLabel.textColor = [UIColor whiteColor];
        podLabel.adjustsFontSizeToFitWidth = YES;
        UIImageView *podImage = [[UIImageView alloc] initWithImage: [[UIImage alloc] initWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: [self.podImagesLinkArray objectAtIndex: indexPath.row]]]]];
        [podImage setTintColor: [[UIColor alloc] initWithRed: 172.0/255.0 green: 102.0/255.0 blue: 1.0 alpha: 0.1]];
        if (podImage.image.size.width > 300) {
            //Rescale image w/ same proportions
            podImage.image = [UIImage imageWithData: UIImagePNGRepresentation(podImage.image) scale: podImage.image.size.width / 260];
        }
        
        podImage.frame = CGRectMake(20, 70, podImage.image.size.width, podImage.image.size.height);
        [cell.contentView addSubview: podLabel];
        [cell.contentView addSubview: podImage];
        
        cell.clipsToBounds = YES;
    }
    else if (indexPath.section == 1) {
        cell.backgroundColor = self.cellBackgroundColor;
        
        UILabel *podStateLabel = [[UILabel alloc] initWithFrame: CGRectMake(20, 10, 250, 50)];
        podStateLabel.text = self.podStateName;
        podStateLabel.font = [UIFont fontWithName: @"Avenir Next" size: 16.0];
        podStateLabel.textColor = [UIColor whiteColor];
        podStateLabel.adjustsFontSizeToFitWidth = YES;
        UIImageView *podStateImage = [[UIImageView alloc] initWithImage: [[UIImage alloc] initWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: self.podStateImageLink]]]];
        if (podStateImage.image.size.width > 300) {
            //Rescale image w/ same proportions
            podStateImage.image = [UIImage imageWithData: UIImagePNGRepresentation(podStateImage.image) scale: podStateImage.image.size.width / 260];
        }
        
        podStateImage.frame = CGRectMake(20, 70, podStateImage.image.size.width, podStateImage.image.size.height);
        [cell.contentView addSubview: podStateLabel];
        [cell.contentView addSubview: podStateImage];
        
        cell.clipsToBounds = YES;
    }
    else {
        
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *podImage = [[UIImageView alloc] initWithImage: [[UIImage alloc] initWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: [self.podImagesLinkArray objectAtIndex: indexPath.row]]]]];
    UIImageView *podStateImage = [[UIImageView alloc] initWithImage: [[UIImage alloc] initWithData: [NSData dataWithContentsOfURL: [NSURL URLWithString: self.podStateImageLink]]]];
    
    if (indexPath.section == 1) {
        return podStateImage.image.size.height + 200;
    }
    else {
        return podImage.image.size.height + 80;
    }
    
//    SELECTION OF TABLE VIEW CELLS (CODE FOR FUTURE USE)
//    if (self.selectedIndex == indexPath.row) {
//        return podImage.image.size.height + 130;
//    }
//    else {
//        return podImage.image.size.height + 80;
//    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row == self.selectedIndex) {
//        self.selectedIndex = -1;
//        NSLog(@"DESELECT %i", self.selectedIndex);
//        [self.tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        [self.tableView reloadData];
//    }
//    else {
//        self.selectedIndex = indexPath.row;
//        NSLog(@"SELECT %i", self.selectedIndex);
//        [self.tableView reloadRowsAtIndexPaths: [NSArray arrayWithObject: indexPath] withRowAnimation: UITableViewRowAnimationFade];
//        [self.tableView reloadData];
//    }
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
