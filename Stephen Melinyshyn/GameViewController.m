//
//  GameViewController.m
//  Tapz
//
//  Created by Stephen Melinyshyn on 2014-03-12.
//  Copyright (c) 2014 StephenMel. All rights reserved.
//

#import "GameViewController.h"
#import "ShareViewController.h"
#import "Ball.h"
#import "Bomb.h"

@interface GameViewController ()
{
    NSMutableArray *balls;
    NSMutableArray *bombs;
    double averageScore;
    BOOL isGameReady;
    UIImageView *explosion;
	
}

@end

@implementation GameViewController


/*=-=-=-= START OF MANDATORY VIEW METHODS =-=-=-=-*/

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
    isGameReady = NO; 
    
    
    [self becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ChangeColor) name:@"shake" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginGame) name:@"begin game" object:nil];
	
}

- (void) viewDidAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"begin game" object:self]; //gets out of viewDidLoad method, solves bugs
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden {return YES;}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (BOOL)shouldAutorotate
{
	return NO;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations{
	return UIInterfaceOrientationMaskPortrait;
}
/*=-=-=-= END OF MANDATORY VIEW METHODS =-=-=-=-*/



/*=-=-=-= START OF COLOR CHANGING METHODS =-=-=-=-*/

//Required for shake to change color feature.
-(BOOL) canBecomeFirstResponder{
    return YES;
}


//Detects when shake has ended.
- (void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    if (motion == UIEventSubtypeMotionShake)
    {
        // User was shaking the device. Post a notification named "shake."
        [[NSNotificationCenter defaultCenter] postNotificationName:@"shake" object:self];
    }
}

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
/*=-=-=-= END OF COLOR CHANGING METHODS =-=-=-=-*/






/*=-=-=-= START OF GAME INIT METHODS =-=-=-=-*/

//First method called to begin game. Sets all key values of game (Ex. _numOfBalls)
-(void)beginGame{
    NSLog(@"beginGame called.");
    _numOfBalls = arc4random_uniform(44) + 10;
    _numOfBombs = _numOfBalls / 10; //insures ratio of balls to bombs
    averageScore = 0;
    
    
    //BOMBS
    bombs = [[NSMutableArray alloc]init];
    for (int h = 0; h < _numOfBombs; h++)
        [bombs addObject:[[Bomb alloc]init]];
    for (int i = 0; i < bombs.count; i++)
        [self.view addSubview:bombs[i]];
    

    //BALLS
    balls = [[NSMutableArray alloc]init];
    for (int j = 0; j < _numOfBalls; j++)
        [balls addObject:[[Ball alloc]init]];
    for (int k = 0; k < balls.count; k++)
        [self.view addSubview:balls[k]];
    
    
    
    _timer = [[NSDate date] timeIntervalSinceReferenceDate];//init timer
    isGameReady = YES;
    NSLog(@"Game load completed.\n %lu balls added \n %lu bombs added \n isGameready: %d", (unsigned long)balls.count, (unsigned long)bombs.count, isGameReady);
    
    
}

/*=-=-=-= END OF GAME INIT METHODS =-=-=-=-*/

/*=-=-=-= START OF GAME PLAY METHODS =-=-=-=-*/

//Determines when touch has ended, removes a ball if tocuh occurs in the same region that a ball exsists
// also includes code for no balls left and alert pop-up initialization.
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    BOOL hasBallBeenRemoved = NO;
    UITouch *touch=[[event allTouches]anyObject];
    CGPoint touchPoint = [touch locationInView:touch.view];
    
    for (UIImageView *view in balls)
    {
        if([view.layer.presentationLayer hitTest:touchPoint] && isGameReady == YES) //tests if the animated image of the ball if hit
        {
            [view removeFromSuperview];
            [balls removeObject:view];
            NSLog(@"balls.count: %lu (%d)", (unsigned long)balls.count, isGameReady);
            hasBallBeenRemoved = YES;
            break;
        }
    }
    

    
    if(balls.count == 0 && isGameReady == YES){ //if no ball images left
        
        //Calculate score
        NSTimeInterval endTimer = [[NSDate date] timeIntervalSinceReferenceDate];
        NSTimeInterval finalTime = endTimer - _timer; //determine total time spent since start
        averageScore = (double)_numOfBalls/finalTime;
        [self addToScores:averageScore];
        NSLog(@"Score added.");
        
        isGameReady = NO;
        
        NSString *btnTitle = [[NSString alloc] initWithFormat:@"You removed an average of %.2f balls a  second. Play again?", averageScore];
		UIAlertController *controller = [UIAlertController alertControllerWithTitle:@"You won!" message:btnTitle preferredStyle:UIAlertControllerStyleAlert];
		UIAlertAction *playAgain = [UIAlertAction actionWithTitle:@"Play Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[self cleanUpBombs:YES Balls:NO];
			[self beginGame];
		}];
		UIAlertAction *share = [UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			NSLog(@"Share button pressed.");
			[self cleanUpBombs:YES Balls:NO];
			[self performSegueWithIdentifier:@"toShareView" sender:self];
		}];
		UIAlertAction *goBack = [UIAlertAction actionWithTitle:@"Main Menu" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
			[self cleanUpBombs:YES Balls:NO];
			[self dismissViewControllerAnimated:true completion:nil];
		}];
		[controller addAction:share];
		[controller addAction:playAgain];
		[controller addAction:goBack];
		[self presentViewController:controller animated:true completion:nil];

        NSLog(@"Alert shown.");
        
    }
    
    //Detect touch on bomb
    for (UIImageView *view in bombs)
    {
        if([view.layer.presentationLayer hitTest:touchPoint ] && hasBallBeenRemoved == NO) //tests if the animated image of the ball if hit
        {
            //[view removeFromSuperview];
            //[bombs removeObject:view];
            NSLog(@"BOMB HIT!");
            [self cleanUpBombs:YES Balls:YES];
            
            explosion = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"explosion.png"]];
            
            explosion.contentMode = UIViewContentModeScaleAspectFill;
            
            explosion.transform = CGAffineTransformMakeScale(0.5, 0.5);
            
            [self.view addSubview:explosion];
            [UIView animateWithDuration:3.0
                                  delay:0.0
                                options:UIViewAnimationOptionCurveEaseOut
                             animations:^{
                                 explosion.transform = CGAffineTransformIdentity;
                                 explosion.frame = CGRectMake(2, 0, 350, 600);
                             }
                             completion:nil];
			UIAlertController *gameOverController = [[UIAlertController alloc]init];
			[gameOverController setTitle:@"Game Over!"];
			UIAlertAction *gameOverAction = [UIAlertAction actionWithTitle:@"Play Again" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				NSLog(@"Play again button pressed.");
				[self cleanUpBombs:YES Balls:YES];
				[self beginGame];
			}];
			UIAlertAction *goToMM = [UIAlertAction actionWithTitle:@"Main Menu" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
				//NSLog(@"Play again button pressed.");
				[self cleanUpBombs:YES Balls:YES];
				[self dismissViewControllerAnimated:true completion:nil];
			}];
			[gameOverController addAction:gameOverAction];
			[gameOverController addAction:goToMM];
			[self presentViewController:gameOverController animated:true completion:nil];
            isGameReady = NO; //to stop PWB
            break;
        }
    }
}


//Adds score as string into standardUserDefaults array, no sorting.
-(void) addToScores:(double) score{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableArray *scores = [[NSMutableArray alloc]initWithArray:[defaults arrayForKey:@"TapzScores"]];
    
    NSDateFormatter *format = [[NSDateFormatter alloc]init];
    NSDate *now = [[NSDate alloc]init];
    format.dateStyle = NSDateFormatterMediumStyle;
    format.timeStyle = NSDateFormatterShortStyle;
    
    [scores addObject:[NSString stringWithFormat:@"%.2f    %@", score, [format stringFromDate:now]]];
    [defaults setObject:scores forKey:@"TapzScores"];
}




-(void)cleanUpBombs:(BOOL)cleanUpBombs Balls:(BOOL)cleanUpBalls{
    if(cleanUpBombs == YES){//Remove Bombs
        int bombCount = (int)(bombs.count-1);
        for (int i = bombCount; i >= 0; i--)
            [bombs[i] removeFromSuperview];
        //NSLog(@"Bombs removed from superview.");
        for (int j = bombCount; j >= 0; j--)
            [bombs removeObjectAtIndex:j];
        //NSLog(@"BOMBS REMOVED. (%lu)", (unsigned long)bombs.count);
    }
    
    if(cleanUpBalls == YES){//remove Balls
        int BallsCount = (int)(balls.count-1);
        //NSLog(@"ball.count: %d\nBallsCount: %d", balls.count, BallsCount);
        for (int k = BallsCount; k >= 0; k--)
            [balls[k] removeFromSuperview];
        //NSLog(@"Balls removed from superview.");
        for (int l = BallsCount; l >= 0; l--)
            [balls removeObjectAtIndex:l];
        //NSLog(@"BALLS REMOVED. (%lu)", (unsigned long)balls.count);
    }
	[explosion removeFromSuperview];
    _numOfBombs = 0;
    _numOfBalls = 0;
    
    NSLog(@"Clean up completed.");
}

/*=-=-=-= END OF GAME PLAY METHODS =-=-=-=-*/


//Segue method for scores view, sends score and message for display
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if([segue.identifier  isEqual: @"toShareView"]){
        ShareViewController * shareVC = segue.destinationViewController;
        shareVC.score = [NSString stringWithFormat:@"%.2f", averageScore];
    }
}
         

@end
