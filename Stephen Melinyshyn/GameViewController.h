//
//  GameViewController.h
//  Tapz
//
//  Created by Stephen Melinyshyn on 2014-03-12.
//  Copyright (c) 2014 StephenMel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameViewController : UIViewController <UIAlertViewDelegate>


@property (nonatomic) NSTimeInterval timer;
@property (nonatomic) int numOfBalls;
@property (nonatomic) int numOfBombs;

@end
