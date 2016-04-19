//
//  Bomb.h
//  Tapz
//
//  Created by Stephen Melinyshyn on 2014-04-06.
//  Copyright (c) 2014 StephenMel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Bomb : UIImageView


@property (nonatomic) double Xspeed;
@property (nonatomic) double Yspeed;
@property (nonatomic) double acceleration;

-(id) initAtPoint:(CGPoint)pt;
-(void) addFallAnimationForLayer: (CALayer *) layer;

@end
