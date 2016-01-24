//
//  LineSpaceTableViewController.m
//  MultiLineTextWidgetSample
//
//  Copyright (c) 2014 MyScript. All rights reserved.
//

#import "LineSpaceTableViewController.h"
#import "TextNotesViewController.h"

static NSString *CellIdentifier = @"LineSpaceCellIdentifier";

@implementation LineSpaceTableViewController

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
        
        [self setTitle:@"Line Space"];
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
    
    NSInteger indexSelected = _viewController.lineSpaceIndex;
    
    switch (indexPath.row)
    {
        case 0:
            cell.textLabel.text = @"S";
            
            if (indexSelected == 0)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            break;
            
        case 1:
            cell.textLabel.text = @"M";
            
            if (indexSelected == 1)
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            
            break;
            
        case 2:
            cell.textLabel.text = @"L";
            
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
    CGFloat size = [self lineSpaceFromIndex:indexPath.row];
    
    _viewController.lineSpaceIndex = indexPath.row;
    
    [_viewController.widget setGuidelinesHeight:size];
    [_viewController.widget setGuidelineFirstPosition:size + 50];
    [_viewController.widget reflow];
    
    [self.tableView reloadData];
}

- (CGFloat)lineSpaceFromIndex:(int)cellRowIndex
{
    CGFloat lineSpace = 0;
    switch (cellRowIndex) {
        case 0:
            lineSpace = 75;
            break;
        case 1:
            lineSpace = 100;
            break;
        case 2:
            lineSpace = 200;
            break;
            
        default:
            break;
    }
    
    return lineSpace;
}

@end
