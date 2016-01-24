//
//  ExportMenuTableViewController.m
//  MultiLineTextWidgetSample
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import "ExportMenuTableViewController.h"
#import "MenuTableViewController.h"

@interface ExportMenuTableViewController ()

@property (nonatomic, assign) BOOL         exportText;
@property (nonatomic, assign) BOOL         exportImage;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;

@end

static NSString *CellIdentifier = @"ExportCellIdentifier";

@implementation ExportMenuTableViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];
    
    _exportImage = NO;
    _exportText  = NO;
    
    // remove empty cells
    [self.tableView setTableFooterView:[UIView new]];
    [self setTitle:@"Export"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closePopoverOrModal)];
        self.navigationItem.rightBarButtonItem = close;
    }
    else
    {
        self.preferredContentSize = CGSizeMake(300, 250);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    _selectedIndexPath = nil;
    
    [self.tableView reloadData];
}

//----------------------------------
#pragma mark Table view data source
//----------------------------------

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    
    if ([_selectedIndexPath isEqual:indexPath])
    {
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityView.hidesWhenStopped = YES;
        [activityView setColor:[UIColor grayColor]];
        [activityView startAnimating];
        
        cell.accessoryView = activityView;
    }
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"Export Text";
            
            break;
            
        case 1:
            cell.textLabel.text = @"Export Image";
            break;
            
        case 2:
            cell.textLabel.text = @"Export both";
            break;
            
        default:
            break;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // add activity indicator
    _selectedIndexPath = indexPath;
    [self.tableView reloadData];
    
    // show export view after showing activity indicator
    [self performSelector:@selector(showExportView) withObject:nil afterDelay:0.1];
}

- (void)showExportView
{
    switch (_selectedIndexPath.row)
    {
        case 0:
            [_viewController exportText];
            break;
            
        case 1:
            [_viewController exportImage];
            break;
            
        case 2:
            [_viewController exportImageAndText];
            break;
            
        default:
            break;
    }
}

- (void)closePopoverOrModal
{
    if (_parentPopopController)
    {
        [_parentPopopController dismissPopoverAnimated:YES];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end