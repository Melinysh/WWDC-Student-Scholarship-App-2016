//
//  HowToPlayViewController.m
//  Tapz
//
//  Created by Stephen Melinyshyn on 2014-03-12.
//  Copyright (c) 2014 StephenMel. All rights reserved.
//

#import "HowToPlayViewController.h"

@interface HowToPlayViewController ()

@end

@implementation HowToPlayViewController

/*-=-=-=- START OF MANDATORY VIEW METHODS -=-=-=-=*/

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) canBecomeFirstResponder{
	return YES;
}

-(BOOL) prefersStatusBarHidden {
	return YES;
}

- (BOOL)shouldAutorotate
{
	return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
/*-=-=-=- END OF MANDATORY VIEW METHODS -=-=-=-=*/

/*-=-=-=- START OF SEGUE METHOD -=-=-=-=*/
- (IBAction)ToMainMenu:(id)sender {
	[self dismissViewControllerAnimated:true completion:nil];
}
/*-=-=-=- END OF SEGUE METHOD -=-=-=-=*/
@end
