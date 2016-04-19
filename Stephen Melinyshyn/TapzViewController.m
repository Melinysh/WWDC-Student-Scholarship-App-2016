//
//  TapzViewController.m
//  Stephen
//
//  Created by Stephen Melinyshyn on 2014-04-07.
//  Copyright (c) 2014 BluLightning. All rights reserved.
//

#import "TapzViewController.h"
#import "Ball.h"

@interface TapzViewController ()
@end

@implementation TapzViewController
bool hasPresented = false;


/*=-=-=-= START OF MANDATORY VIEW METHODS =-=-=-=-*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeColor) name:@"shake" object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
	if (!hasPresented) {
		Ball * ball1 = [[Ball alloc]initAtPoint:CGPointMake(5, 210)];
		Ball * ball2 = [[Ball alloc]initAtPoint:CGPointMake(self.view.frame.size.width - 90, 200)];
		[self.view addSubview:ball1];
		[self.view addSubview:ball2];
		hasPresented = true;
	}
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*=-=-=-= END OF MANDATORY VIEW METHODS =-=-=-=-*/

/*=-=-=-= START OF COLOR CHANGE METHODS =-=-=-=-*/

-(BOOL) canBecomeFirstResponder{
	return YES;
}

-(BOOL) prefersStatusBarHidden {
	return YES;
}

//detects that shake has ended, calls method to change color
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        // User was shaking the device. Post a notification named "shake."
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:self];
    }
}


//changes screen color after shake, randomly
-(void)ChangeColor{
    int num = arc4random_uniform(10);
    if (num == 0) {
        [self.view setBackgroundColor:[UIColor whiteColor]];
    } else if (num == 1){
        [self.view setBackgroundColor:[UIColor blackColor]];
    } else if (num == 2){
        [self.view setBackgroundColor:[UIColor brownColor]];
    } else if(num == 3){
        [self.view setBackgroundColor:[UIColor blueColor]];
    } else if (num ==4){
        [self.view setBackgroundColor:[UIColor redColor]];
    } else if (num == 5){
        [self.view setBackgroundColor:[UIColor purpleColor]];
    } else if (num == 6){
        [self.view setBackgroundColor:[UIColor yellowColor]];
    } else if (num == 7){
        [self.view setBackgroundColor:[UIColor orangeColor]];
    }else if (num == 8){
        [self.view setBackgroundColor:[UIColor greenColor]];
    }else if (num == 9){
        [self.view setBackgroundColor:[UIColor grayColor]];
    }else if (num == 10){
        [self.view setBackgroundColor:[UIColor whiteColor]]; 
    }
}

/*=-=-=-= END OF COLOR CHANGE METHODS =-=-=-=-*/




/*=-=-=-= START OF SEGUE SWITCHING METHODS =-=-=-=-*/
- (IBAction)StartGame:(id)sender {
    [self performSegueWithIdentifier:@"ToGameView" sender:self];
    NSLog(@"ToGameView Segue Performed.");
}

- (IBAction)ShowHighscores:(id)sender {
    [self performSegueWithIdentifier:@"ToHighscoresView" sender:self];
}

- (IBAction)ShowHowToPlay:(id)sender {
    [self performSegueWithIdentifier:@"ToHowToPlayView" sender:self];
}

- (IBAction)goBack:(id)sender {
	hasPresented = false;
	[self dismissViewControllerAnimated:true completion:nil];
}
/*=-=-=-= END OF SEGUE SWITCHING METHODS =-=-=-=-*/

@end
