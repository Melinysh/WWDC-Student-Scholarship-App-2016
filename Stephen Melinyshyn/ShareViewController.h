//
//  ShareViewController.h
//  Tapz
//
//  Created by Stephen Melinyshyn on 2014-04-03.
//  Copyright (c) 2014 StephenMel. All rights reserved.
//

#import <Social/Social.h>
#import <Accounts/Accounts.h>

@interface ShareViewController : UIViewController
{
    SLComposeViewController *mySLComposerSheet;
}


- (IBAction)toFaceBook:(id)sender;
- (IBAction)toTwitter:(id)sender;


- (IBAction)toGameView:(id)sender;
- (IBAction)toMainMenu:(id)sender;

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *topText;

@property (nonatomic) NSString * score;
@end
