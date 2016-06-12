//
//  QuestionFeedWallTableViewController.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 11/15/15.
//  Copyright © 2015 Nishanth Salinamakki. All rights reserved.
//

#import "QuestionFeedWallTableViewController.h"

@interface QuestionFeedWallTableViewController ()

@end

@implementation QuestionFeedWallTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [[UIColor alloc] initWithRed: 1.0 green: .4 blue: 1.0 alpha: 1.0];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    self.questionFeedArray = [[NSArray alloc] init];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem: UIBarButtonSystemItemCompose target: self action: @selector(changeVC)];
    
    PFQuery *questionQuery = [PFQuery queryWithClassName: @"Question"];
    [questionQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            // Query succeeded.
            NSLog(@"Successfully retrieved %d questions", objects.count);
            // Do something with the found objects
            for (PFObject *object in objects) {
                NSLog(@"%@", object.objectId);
                NSLog(@"%@", object[@"questionString"]);
                self.questionFeedArray = [[NSArray alloc] initWithArray: objects];
                [self.tableView reloadData];
            }
        }
        else {
            // Log details of the failure
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        }
    }];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear: YES];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.questionFeedArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle reuseIdentifier: @"Cell"];
    }
    
    PFObject *questionPost = [self.questionFeedArray objectAtIndex: indexPath.row];
    [questionPost saveInBackground];
    
    cell.textLabel.text = questionPost[@"questionTopic"];
    cell.textLabel.textColor = [[UIColor alloc] initWithRed: 1.0 green: .4 blue: 1.0 alpha: 1.0];
    cell.detailTextLabel.text = questionPost[@"questionString"];
    cell.detailTextLabel.textColor = [[UIColor alloc] initWithRed: 1.0 green: .4 blue: 1.0 alpha: 1.0];
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *questionPost = [self.questionFeedArray objectAtIndex: indexPath.row];
    NSString *questionTopic = questionPost[@"questionTopic"];
    NSString *questionString = questionPost[@"questionString"];
    UIImageView *questionImage = questionPost[@"questionImage"];
    NSLog(@"QUESTION TOPIC: %@", questionTopic);
    NSLog(@"QUESTION STRING: %@", questionString);
    NSLog(@"QUESTION IMAGE: %@", questionImage); //should not be nil
    //QuestionObject *question = [[QuestionObject alloc] initWithQuestionTopic: questionTopic andQuestion: questionString andImage: nil];
    //QuestionDetailTableViewController *questionDetailTVC = [[QuestionDetailTableViewController alloc] initWithStyle: UITableViewStylePlain];
    //questionDetailTVC.questionObject = question;
}

- (void) changeVC {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName: @"Main" bundle: nil];
    AskQuestionViewController *askQuestionVC = [storyboard instantiateViewControllerWithIdentifier: @"AskQuestionVC"];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: askQuestionVC];
    [self presentViewController: nav animated: YES completion:^{
        
    }];
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([sender isKindOfClass: [UITableViewCell class]]) {
        if ([segue.destinationViewController isKindOfClass: [QuestionDetailTableViewController class]]) {
            //if ([segue.identifier isEqualToString: @"questionDetailSegue"]) {
                NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
                QuestionDetailTableViewController *nextViewController = segue.destinationViewController;
                
                PFObject *questionPost = [self.questionFeedArray objectAtIndex: indexPath.row];
                NSString *questionTopic = questionPost[@"questionTopic"];
                NSString *questionString = questionPost[@"questionString"];
                UIImageView *questionImage = questionPost[@"questionImage"];
                
                QuestionObject *question = [[QuestionObject alloc] initWithQuestionTopic: questionTopic andQuestion: questionString andImage: questionImage];
                nextViewController.questionObject = question;
            //}
        }
    }
}

@end
