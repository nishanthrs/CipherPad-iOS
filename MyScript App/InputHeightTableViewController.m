//
//  InputHeightTableViewController.m
//  MultiLineTextWidgetSample
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import "InputHeightTableViewController.h"

@interface InputHeightTableViewController ()

@end

static NSString *CellIdentifier = @"InputHeightCellIdentifier";

@implementation InputHeightTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];

    if (self)
    {
        [self.tableView setBackgroundColor:[UIColor whiteColor]];

        // Custom initialization
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CellIdentifier];

        // remove empty cells
        [self.tableView setTableFooterView:[UIView new]];

        [self setTitle:@"Input Height"];
    }

    return self;
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

    NSInteger indexSelected = [self indexForSize: _viewController.inputViewHeight];

    switch (indexPath.row)
    {
    case 0:
        cell.textLabel.text = @"1x";

        if (indexSelected == 0)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;

        break;

    case 1:
        cell.textLabel.text = @"2x";

        if (indexSelected == 1)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;

        break;

    case 2:
        cell.textLabel.text = @"5x";

        if (indexSelected == 2)
            cell.accessoryType = UITableViewCellAccessoryCheckmark;

        break;

    default:
        break;
    }

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat size = [self sizeForIndex:indexPath.row];

    [_viewController setInputViewHeight: size];

    [self.tableView reloadData];
}

- (CGFloat)sizeForIndex:(NSInteger)index
{
    CGFloat heightView = [_viewController widgetViewHeight];
    CGFloat size       = 0;

    switch (index)
    {
    case 0:
        size = heightView;
        break;

    case 1:
        size = heightView * 2;
        break;

    case 2:
        size = heightView * 5;
        break;

    default:
        break;
    }

    return size;
}

- (NSInteger)indexForSize:(CGFloat)size
{
    CGFloat heightView = [_viewController widgetViewHeight];

    if (size >= heightView * 5)
        return 2;

    if (size >= heightView * 2)
        return 1;

    if (size <= heightView)
        return 0;

    return -1;
}

@end