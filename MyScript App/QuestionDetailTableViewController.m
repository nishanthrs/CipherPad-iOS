//
//  QuestionDetailTableViewController.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 6/12/16.
//  Copyright © 2016 Nishanth Salinamakki. All rights reserved.
//

#import "QuestionDetailTableViewController.h"

@interface QuestionDetailTableViewController ()

@end

@implementation QuestionDetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.delegate = self;
    self.comments = [[NSArray alloc] init];
    
    self.questionObject = [[QuestionObject alloc] initWithQuestionTopic: self.questionObject.questionTopic andQuestion: self.questionObject.questionString andImage: self.questionObject.questionImage];
    NSLog(@"QUESTION TOPIC: %@", self.questionObject.questionTopic);
    NSLog(@"QUESTION: %@", self.questionObject.questionString);
    
    self.invisibleTextField = [[UITextField alloc] initWithFrame: CGRectMake(0, 100, 150, 50)];
    self.invisibleTextField.delegate = self;
    //[self.view addSubview: self.invisibleTextField];
    self.toolbarTextField = [[UITextField alloc] init];
    self.toolbarTextField.delegate = self;
    [self.view addSubview: self.toolbarTextField];
    self.customToolbar = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height+50, 320, 70)];
    
    PFQuery *commentQuery = [PFQuery queryWithClassName: [@"Comment" stringByAppendingString: [self.questionObject.questionTopic.lowercaseString substringToIndex: 3]]];
    [commentQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        if (!error) {
            NSLog(@"SUCCESSFULLY RETRIEVED %d COMMENTS", objects.count);
            for (PFObject *object in objects) {
                NSLog(@"%@", object[@"comment"]);
                self.comments = [[NSArray alloc] initWithArray: objects];
                //[self.comments addObject: object[@"comment"]];
                [self.tableView reloadData];
            }
        }
        else {
            NSLog(@"ERROR: %@ %@", error, [error userInfo]);
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
    return [self.comments count] + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"Cell" forIndexPath: indexPath];
    
    if (indexPath.row == 0) {
        cell.textLabel.text = self.questionObject.questionTopic;
        cell.detailTextLabel.text = self.questionObject.questionString;
        [[cell detailTextLabel] setNumberOfLines: 0];
        cell.imageView.image = self.questionObject.questionImage.image;
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"Comment";
        cell.detailTextLabel.text = @"";
        UIImage *commentIcon = [UIImage imageNamed: @"comment_icon"];
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(30, 30), NO, 0.0);
        [commentIcon drawInRect:CGRectMake(0, 0, 30, 30)];
        cell.imageView.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
    }
    else {
        PFObject *commentPost = [self.comments objectAtIndex: indexPath.row-2];
        [commentPost saveInBackground];
        
        cell.textLabel.text = [commentPost objectForKey: @"comment"];
        //cell.textLabel.text = [self.comments objectAtIndex: indexPath.row];
        //cell.textLabel.text = commentPost[@"comment"];
        [[cell textLabel] setNumberOfLines: 0];
        cell.detailTextLabel.text = @"";
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 80;
    }
    else if (indexPath.row == 1) {
        return 45;
    }
    else {
        return 75;
    }
}

-(UIView *)addtoolbar:(CGRect )frame{
    
    self.customToolbar.frame = frame;
    self.customToolbar.backgroundColor = [UIColor darkGrayColor];
    
    //give new frame to your textfield
    self.toolbarTextField.frame = CGRectMake(5,10, 220, 30);
    [self.customToolbar addSubview: self.toolbarTextField];
    
    UIButton *done = [UIButton buttonWithType:UIButtonTypeCustom];
    done.frame = CGRectMake(235,10, 60, 30);
    [done setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [done setTitle:@"Done" forState:UIControlStateNormal];
    [done addTarget:self  action:@selector(pressdone) forControlEvents:UIControlEventTouchUpInside];
    [self.customToolbar addSubview: done];
    [self.view addSubview: self.customToolbar];
    
    return self.customToolbar;
    
}

-(void)pressdone{
    
    [self addtoolbar:CGRectMake(0, self.view.frame.size.height+50, 320, 50)];
    
    //set there orignal frame of your textfield
    //self.toolbarTextField.frame = CGRectMake(30, 120 + (50*[self.comments count]), 123, 37);
    NSString *commentText = self.toolbarTextField.text;
    PFObject *commentObject = [PFObject objectWithClassName: [@"Comment" stringByAppendingString: [self.questionObject.questionTopic.lowercaseString substringToIndex: 3]]];
    commentObject[@"comment"] = commentText;
    [commentObject saveInBackground];
    //[self.comments addObject: commentText];
    NSLog(@"TOOLBAR TEXT FIELD TEXT: %@", self.toolbarTextField.text);
    [self.view addSubview: self.toolbarTextField];
    [self.toolbarTextField resignFirstResponder];
    //[self.invisibleTextField resignFirstResponder];
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 1) {
        NSLog(@"CLICKED!");
        [self.toolbarTextField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0];
        //[self.toolbarTextField becomeFirstResponder];
    }
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    [UIView animateWithDuration:0.7 animations:^{
        [self addtoolbar:CGRectMake(0, self.view.frame.size.height-216-35, 320, 50)];
    }];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    
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
