//
//  ScoresTableViewController.m
//  Tapz
//
//  Created by Stephen Melinyshyn on 2014-03-12.
//  Copyright (c) 2014 StephenMel. All rights reserved.
//

#import "ScoresTableViewController.h"

@interface ScoresTableViewController () <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *scores;

}
@end

@implementation ScoresTableViewController

/*=-=-=-= START OF MANDATORY VIEW METHODS =-=-=-=-*/

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    //Prevents the tab bar from covering the first table cell. +54's are offset to insure first table cell isn't block
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.tableView.contentInset = UIEdgeInsetsMake(0.0f+54, 0.0f+54, CGRectGetHeight(self.tabBarController.tabBar.frame), 0.0f);
    
    //Creates top UIBar with Nav and button for returning to Main Menu. -54 value adjusts for offset to show 1st cell
    UINavigationBar *uiNavBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0-54, [[UIScreen mainScreen]bounds].size.width, 54)];
    UINavigationItem *uiNavItem = [[UINavigationItem alloc] initWithTitle:@"Top 10 Scores"];
    [uiNavBar pushNavigationItem:uiNavItem animated:NO];
    UIBarButtonItem *BackBtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleDone target:self action:@selector(BackToMainMenu)];
    uiNavItem.leftBarButtonItem = BackBtn;
    [self.view addSubview:uiNavBar];
    
    
    //prevents first cell from being covered by UINavBar
    self.tableView.frame = CGRectMake(0,uiNavBar.frame.size.height, [[UIScreen mainScreen]bounds].size.width, self.view.frame.size.height-uiNavBar.frame.size.height);
    
    
    //Loads NSUserDefaults for saved scores
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    scores = [[NSArray alloc] initWithArray:[defaults arrayForKey:@"TapzScores"]];
    
    scores = [[[scores sortedArrayUsingSelector:@selector(compare:)]reverseObjectEnumerator] allObjects];
    
    
    //Delegate assignement
    self.tableView.dataSource = self;
    self.tableView.delegate = self;    
    
    //Stops table view from sliding horizontally.
    self.tableView.contentOffset = CGPointZero;
    self.tableView.scrollEnabled = NO;
}

- (void) viewDidAppear:(BOOL)animated
{
}

-(BOOL) canBecomeFirstResponder{
	return YES;
}

-(BOOL) prefersStatusBarHidden {
	return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    int limit = 10;
    if(scores.count < 10)
        limit = (int)scores.count;
    return limit;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"cell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
    }
    
    NSString *cellContents = [[NSString alloc]initWithFormat:@"#%d:    %@", (int)indexPath.row+1, scores[indexPath.row]];
    
    cell.textLabel.text =  cellContents; //sets the string of score to label with it numbered (1. .. 2...)
    
    
    return cell;
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Returns NO so we can't delete tablecells. Was only required for debugging.
    return NO;
}



// Override to support editing and deleting the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *copy = [scores mutableCopy];
        [copy removeObjectAtIndex:indexPath.row];
        [[NSUserDefaults standardUserDefaults] setObject:copy forKey:@"TapzScores"];
        scores = copy;
        //[tableView reloadData];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

/*=-=-=-= END OF MANDATORY VIEW METHODS =-=-=-=-*/


/*=-=-=-= START OF SEGUE SWITCHING METHOD =-=-=-=-*/
- (void)BackToMainMenu {
    NSLog(@"Back button pressed.");
    [self dismissViewControllerAnimated:true completion:nil];
}
/*=-=-=-= END OF SEGUE SWITCHING METHOD =-=-=-=-*/


@end
