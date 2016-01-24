//
//  MenuTableViewController.m
//  MultiLineTextWidgetSample
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import "InputHeightTableViewController.h"
#import "LineSpaceTableViewController.h"
#import "TextNotesViewController.h"
#import "MenuTableViewController.h"

@interface MenuTableViewController ()

@end

@implementation MenuTableViewController
{
    UISwitch *_candidateSwitch;
}

static NSString *CellIdentifier = @"Cell";

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.tableView setBackgroundColor:[UIColor whiteColor]];

    // remove empty cells
    [self.tableView setTableFooterView:[UIView new]];
    [self setTitle:@"Settings"];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        UIBarButtonItem *close = [[UIBarButtonItem alloc] initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closePopoverOrModal)];

        self.navigationItem.rightBarButtonItem = close;
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 4;
}

- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    return [NSString stringWithFormat:@"MultiLine version : %@", [MLTWMultiLineView versionString]];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];

    switch (indexPath.row)
    {
    case 0:
        cell.textLabel.text = @"Scrolling view";
        {
            UISwitch *gestureSwitch = [[UISwitch alloc] init];
            gestureSwitch.on = _viewController.scrollingView;
            [gestureSwitch addTarget:self action:@selector(scrollViewChange:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = gestureSwitch;
        }
        break;

    case 1:
        cell.textLabel.text = @"Input height";
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        // disable cell if scroll view mode
        cell.userInteractionEnabled = _viewController.scrollingView;
        cell.textLabel.enabled      = _viewController.scrollingView;
        break;

    case 2:
        cell.textLabel.text = @"Line space";
        cell.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
        break;

    case 3:
        cell.textLabel.text = @"Auto scroll";
        {
            UISwitch *gestureSwitch = [[UISwitch alloc] init];
            gestureSwitch.on = _viewController.isAutoScroll;
            [gestureSwitch addTarget:self action:@selector(autoScrollChange:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = gestureSwitch;
        }

    default:
        break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row)
    {
    case 1:
        [self presentInputViewHeight];
        break;

    case 2:
        [self presentLineSpaceView];
        break;
    }

    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark Action for cell

- (void)scrollViewChange:(UISwitch *)uiSwitch
{
    _viewController.scrollingView = !_viewController.scrollingView;

    // remove the scroll view if page mode
    if (!_viewController.scrollingView)
    {
        CGFloat heightView = [_viewController widgetViewHeight];
        [_viewController setInputViewHeight:heightView];
    }

    [self.tableView reloadData];
}

- (void)presentInputViewHeight
{
    InputHeightTableViewController *inputViewHeightTableViewController = [[InputHeightTableViewController alloc] initWithStyle:UITableViewStylePlain];

    inputViewHeightTableViewController.viewController = _viewController;

    [self.navigationController pushViewController:inputViewHeightTableViewController animated:YES];
}

- (void)presentLineSpaceView
{
    LineSpaceTableViewController *lineSpaceTableViewController = [[LineSpaceTableViewController alloc] initWithStyle:UITableViewStylePlain];

    lineSpaceTableViewController.viewController = _viewController;

    [self.navigationController pushViewController:lineSpaceTableViewController animated:YES];
}

- (void)autoScrollChange:(UISwitch *)uiSwitch
{
    _viewController.autoScroll = !_viewController.autoScroll;
    [self.tableView reloadData];
}

#pragma mark Close view

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