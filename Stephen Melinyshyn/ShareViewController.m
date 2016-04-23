//
//  ShareViewController.m
//  Tapz
//
//  Created by Stephen Melinyshyn on 2014-04-03.
//  Copyright (c) 2014 StephenMel. All rights reserved.
//

#import "ShareViewController.h"
#import "GameViewController.h"
#import "Ball.h"
#import "Bomb.h"

@interface ShareViewController ()
{
    UIImageView *ball;
    UIImageView *bomb;
}

@end

@implementation ShareViewController

@synthesize topText = _topText;
@synthesize score = _score;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _topText.text = [NSString stringWithFormat:@"Congrats!\nYou just scored %@ on Tapz!", _score];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _topText.text = [NSString stringWithFormat:@"Congrats! You just scored %@ on Tapz!", _score];


}

-(void)viewDidAppear:(BOOL)animated{
    bomb = [[Bomb alloc] initAtPoint:(CGPointMake(0, 170))];
    [self.view addSubview:bomb];
    ball = [[Ball alloc]initAtPoint:(CGPointMake(self.view.frame.size.width - 90, 200))];
    [self.view addSubview:ball];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate
{
	return NO;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations{
	return UIInterfaceOrientationMaskPortrait;
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


- (IBAction)toFaceBook:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) //check if Facebook Account is linked
    {
        mySLComposerSheet = [[SLComposeViewController alloc] init];
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook]; //Tell him with what social plattform to use it, e.g. facebook or twitter
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Look! I just scored %@ on Tapz!", _score]];
        
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    } else { //check if everything worked properly. Give out a message on the state.
		UIAlertController *controller = [[UIAlertController alloc]init];
		[controller setTitle:@"Sorry, no Facebook account detected. Please check your settings."];
		UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style: UIAlertActionStyleDefault handler:nil];
		[controller addAction:action];
		[self presentViewController:controller animated:true completion:nil];
	}
    
    [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        } //check if everything worked properly. Give out a message on the state.
        NSLog(@"%@",output);
    }];

}

- (IBAction)toTwitter:(id)sender {
    if([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter]) //check if Twitter Account is linked
    {
        mySLComposerSheet = [[SLComposeViewController alloc] init]; //initiate the Social Controller
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [mySLComposerSheet setInitialText:[NSString stringWithFormat:@"Look! I scored %@ on Tapz!", _score ]];
        [self presentViewController:mySLComposerSheet animated:YES completion:nil];
    } else { //check if everything worked properly. Give out a message on the state.
		UIAlertController * aController = [[UIAlertController alloc] init];
		[aController setTitle:@"Sorry, no Twitter account detected. Please check your settings."];
		UIAlertAction * action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
		[aController addAction:action];
		[self presentViewController:aController animated:true completion:nil];
    }
    [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
        NSString *output;
        switch (result) {
            case SLComposeViewControllerResultCancelled:
                output = @"Action Cancelled";
                break;
            case SLComposeViewControllerResultDone:
                output = @"Post Successfull";
                break;
            default:
                break;
        }
        NSLog(@"%@", output);
    }];

}

- (IBAction)toGameView:(id)sender {
    NSLog(@"toGameView button pressed. (From shareView)");
	[self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)toMainMenu:(id)sender {
     NSLog(@"Main Menu button pressed (From shareView).");
	//((GameViewController*)self.parentViewController).shouldDimiss = true;
	[self dismissViewControllerAnimated:true completion:nil];
	[self.presentingViewController dismissViewControllerAnimated:true completion:nil];
}




@end
