//
//  TextNotesViewController.m
//  MyScript App
//
//  Created by Nishanth Salinamakki on 10/24/15.
//  Copyright (c) 2015 Nishanth Salinamakki. All rights reserved.
//

#import "TextNotesViewController.h"

@interface TextNotesViewController ()

@property (nonatomic, strong) NSData                        *data;
@property (nonatomic, strong) UIImageView                   *imageView;
@property (nonatomic, strong) UIPopoverController           *menuPopoverController;
@property (nonatomic, strong) NSMutableArray                *pagesData;
@property (nonatomic, strong) UIBarButtonItem               *btExport;
@property (nonatomic, strong) MenuTableViewController       *menuTableViewController;
@property (nonatomic, strong) ExportMenuTableViewController *exportMenuTableViewController;

@property (nonatomic, strong) MLTWWord         *currentWord;
@property (nonatomic, assign) MLTWMultilineMode currentMode;

@property (nonatomic, assign) int  currentPage;
@property (nonatomic, assign) BOOL pageLoading;

@property (nonatomic, strong) UIBarButtonItem *btItemExport;

@end

@implementation TextNotesViewController

// locale defined here
NSString *const LOCALE_EN = @"en_US";

//----------------------------------
#pragma mark Init & Life's cycle
//----------------------------------

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Notes";
    
    // Init value
    [self setLineSpaceIndex:1];
    [self setScrollingView:YES];
    [self setAutoScroll:NO];
    
    // put colors to views
    [self colorViews];
    
    // create & show the toolbar
    [self createToolBar];
    
    // configure page index (to manage previous & next page)
    _pagesData   = [NSMutableArray array];
    _currentPage = 0;
    [self updatePageNumber];
    
    // configure the widget
    [self initWidget];
}

- (void)colorViews
{
    [_lineView setBackgroundColor:[UIColor purpleColor]];
    [_textView setBackgroundColor:[UIColor purpleColor]];
    [_candidateView setBackgroundColor:[UIColor purpleColor]];
    [_textView setTextColor:[UIColor purpleColor]];
    [_btReflow setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
    [_lblNotif setTextColor:[UIColor purpleColor]];
}

- (void)createToolBar
{
    // Init the toolbar
    _btItemExport   = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"MLTW_Export"] style:UIBarButtonItemStylePlain target:self action:@selector(showExportMenu:)];
    UIBarButtonItem *btItemRemove   = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"glyphicons_trash"] style:UIBarButtonItemStylePlain target:self action:@selector(clear)];
    UIBarButtonItem *wolframAlphaIcon = [[UIBarButtonItem alloc] initWithImage: [UIImage imageNamed: @"wolframalpha_logo"] style:UIBarButtonItemStyleDone target: self action: @selector(wolframQuery)];
    
    [self.navigationItem setRightBarButtonItems:@[_btItemExport, btItemRemove, wolframAlphaIcon]];
}

- (void) wolframQuery {
    //NSString *text = [self text];
    NSString *text = @"shoes";
    NSLog(@"TEXT ON SCREEN: %@", text);
    //Wolfram App ID is: LTW5PH-XA766A928W
    NSString *requestWolframAPIURL = [@"http://api.wolframalpha.com/v2/query?appid=LTW5PH-XA766A928W&input=" stringByAppendingString: text];
    requestWolframAPIURL = [requestWolframAPIURL stringByAppendingString: @"&format=image,plaintext"];
    
    NSString *requestWolframAPIURL2 = [@"http://api.wolframalpha.com/v2/query?input=" stringByAppendingString: text];
    [requestWolframAPIURL2 stringByAppendingString: @"&appid=LTW5PH-XA766A928W"];
    //NSString *requestURL = [@"http://www.wolframalpha.com/input/?i=" stringByAppendingString: text];
    //Get info on how to get and convert XML query returns into something readable
    NSURL *wolframURL = [NSURL URLWithString: requestWolframAPIURL2];
    NSURLRequest *request = [NSURLRequest requestWithURL: wolframURL];
    [NSURLConnection sendAsynchronousRequest: request queue: [NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSLog(@"THE DATA RETURNED IS: %@", data);
        NSString* dataString = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
        NSLog(@"THE DATA IN STRING FORMAT IS: %@", dataString);
        NSError *error = nil;
        NSDictionary *xmlDoc = [XMLReader dictionaryForXMLData: data error: &error];
        NSLog(@"THE JSON FILE: %@", xmlDoc);
    }];
    [[UIApplication sharedApplication] openURL: wolframURL];
}

- (void)initWidget
{
    // widget settings
    _widget.delegate               = self;
    _widget.guidelineFirstPosition = 150.;
    _widget.autoScrollDisabled     = YES;
    
    // widget colors
    _widget.inkColor              = [UIColor purpleColor];
    _widget.inkColorHighlight     = [UIColor purpleColor];
    _widget.guidelinesColor       = [[UIColor purpleColor] colorWithAlphaComponent:0.4];
    _widget.scrollBackgroundColor = [[UIColor purpleColor] colorWithAlphaComponent:0.5];
    
    // start configuration with english
    [self configureRecognitionForLocale:LOCALE_EN];
    
    [self.view addSubview: _widget];
    NSLog(@"INITIALIZING WIDGET!");
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    // remove popover if present (iPad)
    if (_menuPopoverController)
        [_menuPopoverController dismissPopoverAnimated:YES];
    
    if (_currentWord)
        [self createCandidatesFromWord:_currentWord];
    
    // reflow after a rotation
    [_widget reflow];
}

//----------------------------------
#pragma mark - MultiLine View delegate - Configuration
//----------------------------------

- (void)configureRecognitionForLocale:(NSString *)locale
{
//    _locale = locale;
//    
//    NSArray *resources = [self resourcesForLocale:locale];
//    
//    NSData *certificate = [self certificate];
//    
//    [_widget configureWithLocale:locale resources:resources lexicon:nil certificate: certificate density:132 * 2];
}

- (NSArray *)resourcesForLocale:(NSString *)locale
{
    NSString *akCur, *lkText;
    
    if ([locale isEqualToString:LOCALE_EN])
    {
        akCur  = [[NSBundle mainBundle] pathForResource:@"en_US-ak-cur.lite" ofType:@"res"];
        lkText = [[NSBundle mainBundle] pathForResource:@"en_US-lk-text.lite" ofType:@"res"];
    }
    
    NSArray *resources = @[akCur, lkText];
    return resources;
}

- (NSString *)labelForLocale:(NSString *)locale
{
    if ([locale isEqualToString:LOCALE_EN])
    {
        return @"English";
    }
    
    return nil;
}

- (void)multiLineViewDidBeginConfiguration:(MLTWMultiLineView *)view
{
    NSLog(@"Text configuration began");
}

- (void)multiLineViewDidEndConfiguration:(MLTWMultiLineView *)view
{
    // show locale label
    //[_lblNotif setText:[self labelForLocale:_locale]];
    NSLog(@"Text configuration ends");
}

- (void)multiLineView:(MLTWMultiLineView *)view didFailConfigurationWithError:(NSError *)error
{
    NSLog(@"Fail configuration: %@", [error localizedDescription]);
}

- (void)multiLineView:(MLTWMultiLineView *)view didSelectionWord:(MLTWWord *)word isHighlighted:(BOOL)isHighlighted
{
    [self clearCandidateView];
    
    if (word)
        [self createCandidatesFromWord:word];
    else if (!_widget.text && ![_widget.text isEqualToString:@""]) // page empty  --> go to top
        [_widget scrollWordToTop:nil];
}

//----------------------------------
#pragma mark - MultiLine View delegate - Recognition
//----------------------------------

- (void)multiLineViewDidStartRecognition:(MLTWMultiLineView *)view
{
    [_activityIndicator startAnimating];
    _btReflow.enabled = NO;
    NSLog(@"START RECOGNITION!");
}

- (void)multiLineViewDidEndRecognition:(MLTWMultiLineView *)view
{
    // enable button (after changing page for example)
    if (_pageLoading)
    {
        _pageLoading = NO;
        [self updateButtonsState];
    }
    
    // stop activity wheel
    [_activityIndicator stopAnimating];
    
    _btReflow.enabled = YES;
    
    // scroll textview for long recognized text
    if (_currentMode == MLTWMultilineModeWriting)
        [_textView scrollRangeToVisible:NSMakeRange([_textView.text length], 0)];
}

//----------------------------------
#pragma mark - MultiLine View delegate - Text
//----------------------------------

- (void)multiLineView:(MLTWMultiLineView *)view didChangeText:(NSString *)text
{
    _textView.text = text;
}

//----------------------------------
#pragma mark - MultiLine View delegate - Gestures
//----------------------------------

- (void)multiLineView:(MLTWMultiLineView *)view didDetectInsertGestureForWord:(MLTWWord *)word atIndex:(NSUInteger)characterIndex
{
    // insert space
    if (characterIndex > 0 && characterIndex < word.text.length)
        [_widget addSpaceWithWord:word atIndex:characterIndex];
    else
        [_widget setInsertionMode:word atIndex:characterIndex];
}

- (void)multiLineView:(MLTWMultiLineView *)view didDetectJoinGestureForWord:(MLTWWord *)word atIndex:(NSUInteger)characterIndex
{
    // remove space
    [_widget removeSpaceWithWord:word atIndex:characterIndex];
}

- (void)multiLineView:(MLTWMultiLineView *)view didDetectSingleTapGestureForWord:(MLTWWord *)word atIndex:(NSUInteger)characterIndex
{
    // select word (with scroll)
    [_widget setCorrectionMode:word];
}

- (void)multiLineView:(MLTWMultiLineView *)view didDetectSelectionGestureForWords:(NSArray *)words
{
    if (words && words.count > 0)
        [_widget setCorrectionMode:[words objectAtIndex:0]];
}

- (void)multiLineView:(MLTWMultiLineView *)view didDetectReturnGestureForWord:(MLTWWord *)word atIndex:(NSUInteger)characterIndex
{
    [_widget addLineBreakForWord:word atIndex:characterIndex];
}

- (void)multiLineView:(MLTWMultiLineView *)view didDetectUnderlineGestureForWords:(NSArray *)words
{
    if (words && words.count > 0)
        [_widget setCorrectionMode:[words objectAtIndex:0]];
}

- (void)multiLineView:(MLTWMultiLineView *)view didChangeModeWithPreviousMode:(MLTWMultilineMode)previousMode newMode:(MLTWMultilineMode)newMode
{
    _currentMode = newMode;
    
    NSString *modeLabel;
    
    switch (newMode) {
        case MLTWMultilineModeWriting:
            modeLabel = @"Writing";
            break;
            
        case MLTWMultilineModeCorrection:
            modeLabel = @"Correction";
            break;
            
        case MLTWMultilineModeInsertion:
            modeLabel = @"Insertion";
            break;
            
        default:
            modeLabel = @"None";
            break;
    }
}

//----------------------------------
#pragma mark - Candidates
//----------------------------------

/**
 *  Create a candidate bar to change the text of the word.
 *  Each candidate is represented by a button. A tap on it will change the recognition text
 *
 *  @param word the word's candidate to show
 */
- (void)createCandidatesFromWord:(MLTWWord *)word
{
    _currentWord = word;
    
    NSArray *candidates = word.candidates;
    
    CGFloat candidatesCount        = candidates.count;
    CGFloat spaceBetweenCandidates = 2;
    CGFloat originX                = spaceBetweenCandidates;
    CGFloat minSize                = (_candidateView.frame.size.width / candidatesCount) - spaceBetweenCandidates;
    
    for (int i = 0; i < candidatesCount; i++)
    {
        // get candidate label
        BOOL      isSelected;
        NSString *candidate = [candidates objectAtIndex:i];
        
        isSelected = [candidate isEqualToString:word.text];
        
        // create a button
        UIButton *btCandidate = [UIButton buttonWithType:UIButtonTypeCustom];
        [btCandidate setTitleColor:[UIColor purpleColor] forState:UIControlStateNormal];
        [btCandidate setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        [btCandidate setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
        [btCandidate setTitle:candidate forState:UIControlStateNormal];
        [btCandidate addTarget:self action:@selector(changeCandidate:) forControlEvents:UIControlEventTouchUpInside];
        
        CGSize size;
        
        if ([[[UIDevice currentDevice] systemVersion] intValue] < 7)
        {
            // for iOS 6 and <
            size = [btCandidate.titleLabel.text sizeWithFont:btCandidate.titleLabel.font
                                           constrainedToSize:CGSizeMake(FLT_MAX, btCandidate.bounds.size.height)
                                               lineBreakMode:NSLineBreakByWordWrapping];
        }
        else
        {
            CGSize                 maximumLabelSize = CGSizeMake(_candidateView.frame.size.width, MAXFLOAT);
            NSDictionary          *attr             = @{NSFontAttributeName: btCandidate.titleLabel.font};
            NSStringDrawingOptions options          = NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin;
            
            CGRect labelBounds = [btCandidate.titleLabel.text boundingRectWithSize:maximumLabelSize
                                                                           options:options
                                                                        attributes:attr
                                                                           context:nil];
            size = labelBounds.size;
        }
        
        // add padding
        size.width += 10;
        
        btCandidate.frame = CGRectMake(originX, 0, MAX(size.width, minSize), 40);
        
        // current text
        if (isSelected)
        {
            [btCandidate setBackgroundColor:[UIColor purpleColor]];
            btCandidate.highlighted = YES;
        }
        else
        {
            [btCandidate setBackgroundColor:[UIColor purpleColor]];
        }
        
        [_candidateView addSubview:btCandidate];
        
        originX += btCandidate.frame.size.width + spaceBetweenCandidates;
    }
    
    // update scroll view
    [_candidateView setContentSize:CGSizeMake(originX, 40)];
}

- (void)changeCandidate:(UIButton *)sender
{
    // clear previous selected button
    [self clearSelectedButton];
    
    // set the new button settings
    [sender setBackgroundColor:[UIColor purpleColor]];
    
    // Replace text
    [_widget replaceWord:_currentWord withNewText:sender.titleLabel.text];
}

- (void)clearSelectedButton
{
    NSArray *subViews = _candidateView.subviews;
    
    for (UIView *subView in subViews)
    {
        if ([[subView class] isSubclassOfClass:[UIButton class]])
        {
            [subView setBackgroundColor:[UIColor purpleColor]];
        }
    }
}

- (void)clearCandidateView
{
    NSArray *subViews = _candidateView.subviews;
    
    for (UIView *subView in subViews)
    {
        [subView removeFromSuperview];
    }
}

//----------------------------------
#pragma mark - Navigation
//----------------------------------

- (void)showMenu:(id)sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // Show iPad menu (popover)
        [self showMenuPopover:sender];
    }
    else
    {
        // Show iPhone menu (full screen)
        [self showMenuViewController];
    }
}

- (void)showMenuPopover:(UIBarButtonItem *)sender
{
    if ([_menuPopoverController isPopoverVisible])
    {
        // hide menu popover
        [_menuPopoverController dismissPopoverAnimated:NO];
    }
    else
    {
        if (!_menuTableViewController)
        {
            _menuTableViewController                = [[MenuTableViewController alloc] initWithStyle:UITableViewStylePlain];
            _menuTableViewController.viewController = self;
        }
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_menuTableViewController];
        
        _menuPopoverController = [[UIPopoverController alloc] initWithContentViewController:nav];
        
        [_menuTableViewController setParentPopopController:_menuPopoverController];
        
        // show
        [self showPopoverFromBarButtonItem:sender];
    }
}

- (void)showMenuViewController
{
    _menuTableViewController                = [[MenuTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _menuTableViewController.viewController = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_menuTableViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showPopoverFromBarButtonItem:(UIBarButtonItem *)sender
{
    UIView *view = [sender valueForKey:@"view"];
    
    if (view)
    {
        CGRect frame = view.frame;
        
        // Fix wrong popover arrow position
        [_menuPopoverController presentPopoverFromRect:frame
                                                inView:view.superview
                              permittedArrowDirections:UIPopoverArrowDirectionUp
                                              animated:YES];
    }
}

//----------------------------------
#pragma mark - Export
//----------------------------------

- (void)showExportMenu:(UIBarButtonItem *)sender
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // Show iPad menu (popover)
        [self showExportMenuPopover:sender];
    }
    else
    {
        // Show iPhone menu (full screen)
        [self showExportMenuViewController];
    }
}

- (void)showExportMenuPopover:(UIBarButtonItem *)sender
{
    _btExport = sender;
    
    if ([_menuPopoverController isPopoverVisible])
    {
        // hide menu popover
        [_menuPopoverController dismissPopoverAnimated:NO];
    }
    else
    {
        if (!_exportMenuTableViewController)
        {
            _exportMenuTableViewController                = [[ExportMenuTableViewController alloc] initWithStyle:UITableViewStylePlain];
            _exportMenuTableViewController.viewController = self;
        }
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_exportMenuTableViewController];
        
        _menuPopoverController = [[UIPopoverController alloc] initWithContentViewController:nav];
        
        [_exportMenuTableViewController setParentPopopController:_menuPopoverController];
        
        // show
        [self showPopoverFromBarButtonItem:sender];
    }
}

- (void)showExportMenuViewController
{
    _exportMenuTableViewController                = [[ExportMenuTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _exportMenuTableViewController.viewController = self;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:_exportMenuTableViewController];
    [self presentViewController:nav animated:YES completion:nil];
}

//----------------------------------
#pragma mark Menu Buttons
//----------------------------------

#pragma mark Clear
- (void)clear
{
    [self clearCandidateView];
    
    [_widget clear];
}

#pragma mark Scroll/Page Mode

- (void)setScrollingView:(BOOL)scrollingView
{
    _scrollingView = scrollingView;
    
    [self updatePaginationState:_scrollingView];
}

- (void)setAutoScroll:(BOOL)autoScroll
{
    _autoScroll = autoScroll;
    
    _widget.autoScrollDisabled = !autoScroll;
}

#pragma mark Scroll view

- (CGFloat)widgetViewHeight
{
    return _widget.frame.size.height;
}

- (void)setInputViewHeight:(CGFloat)inputViewHeight
{
    [_widget setInputViewHeight:inputViewHeight];
}

- (CGFloat)inputViewHeight
{
    return [_widget inputViewHeight];
}

#pragma mark Export

- (NSString *)text
{
    return _widget.text;
}

- (UIImage *)image
{
    return [_widget exportAsImageWithBackground:NO exactHeight:YES];
}

- (void)exportText
{
    [self closeExportViewController];
    
    NSString *textToShare = self.text;
    
    if (textToShare && ![textToShare isEqualToString:@""])
    {
        [self showOpenInPopoverWithText:textToShare image:nil];
    }
    else
    {
        [self showNoExportMessage];
    }
}

- (void)exportImage
{
    [self closeExportViewController];
    
    UIImage *imageToShare = self.image;
    
    if (imageToShare)
    {
        [self showOpenInPopoverWithText:nil image:imageToShare];
    }
    else
    {
        [self showNoExportMessage];
    }
}

- (void)exportImageAndText
{
    [self closeExportViewController];
    
    NSString *textToShare  = self.text;
    UIImage  *imageToShare = self.image;
    
    if (imageToShare && textToShare)
    {
        [self showOpenInPopoverWithText:textToShare image:imageToShare];
    }
    else
    {
        [self showNoExportMessage];
    }
}

- (void)showNoExportMessage
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Nothing to export" message:@"Write something in the page so you have something to export" delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
    
    [alertView show];
}

- (void)showOpenInPopoverWithText:(NSString *)text image:(UIImage *)image
{
    NSMutableArray *itemsToShare = [NSMutableArray array];
    
    if (text)
    {
        [itemsToShare addObject:text];
        
        // add print action
        UISimpleTextPrintFormatter *printData = [[UISimpleTextPrintFormatter alloc] initWithText:text];
        [itemsToShare addObject:printData];
    }
    
    if (image)
        [itemsToShare addObject:image];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:itemsToShare applicationActivities:nil];
    activityVC.title                 = @"Export text";
    activityVC.excludedActivityTypes = @[UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        // ios 8 & +
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.)
        {
            activityVC.popoverPresentationController.barButtonItem = _btItemExport;
        }
        // < ios 8
        else
        {
            activityVC.modalInPopover = YES;
        }
        [self presentViewController:activityVC animated:YES completion:nil];
    }
    else
    {
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}

- (void)closeExportViewController
{
    if (_menuPopoverController)
    {
        [_menuPopoverController dismissPopoverAnimated:YES];
    }
    else
    {
        [_exportMenuTableViewController dismissViewControllerAnimated:NO completion:nil];
    }
}

#pragma mark Page actions

- (void)updatePageNumber
{
    [_lblPageNumber setText:[NSString stringWithFormat:@"%d", _currentPage + 1]];
}

- (IBAction)previousPageAction:(UIButton *)sender
{
    if (_currentPage > 0)
    {
        [self changePage:NO];
    }
}

- (IBAction)nextPageAction:(UIButton *)sender
{
    if (_currentPage < 10) // Max pages
    {
        [self changePage:YES];
    }
}

- (IBAction)reflowAction:(UIButton *)sender
{
    [_widget reflow];
}

- (void)changePage:(BOOL)next
{
    NSData *pageData = [_widget save];
    
    // save current page (insert or replace if existed)
    if (_pagesData.count > _currentPage)
        [_pagesData replaceObjectAtIndex:_currentPage withObject:pageData];
    else
        [_pagesData insertObject:pageData atIndex:_currentPage];
    
    // change page
    if (next)
        ++_currentPage;
    else
        --_currentPage;
    
    _pageLoading = YES;
    [self loadCurrentPage];
}

- (void)loadCurrentPage
{
    // disable button for loading a new page
    if (_pageLoading)
    {
        _btPrevPage.enabled = NO;
        _btNextPage.enabled = NO;
    }
    
    // update page number
    [self updatePageNumber];
    
    // load next page (if exist)
    if (_pagesData.count > _currentPage)
        [_widget load:[_pagesData objectAtIndex:_currentPage]];
    else
        [_widget clear];
}

- (void)updateButtonsState
{
    _btPrevPage.enabled = _currentPage > 0;
    _btNextPage.enabled = _currentPage < 9;
}

- (void)updatePaginationState:(BOOL)isScrollingView
{
    _btNextPage.hidden    = isScrollingView;
    _btPrevPage.hidden    = isScrollingView;
    _lblPageNumber.hidden = isScrollingView;
}

@end
