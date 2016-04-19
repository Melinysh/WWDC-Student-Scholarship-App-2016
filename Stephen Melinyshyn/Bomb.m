//
//  Bomb.m
//  Tapz
//
//  Created by Stephen Melinyshyn on 2014-04-06.
//  Copyright (c) 2014 StephenMel. All rights reserved.
//

#import "Bomb.h"

@implementation Bomb

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)init{
    self = [super init];
    if(self){
        int randX = arc4random() % (int)[UIScreen mainScreen].bounds.size.width ; //randomly choosen
        int randY = 50 +(arc4random() % ((int)[UIScreen mainScreen].bounds.size.height-150));//randomly choosen
        self.frame = CGRectMake(randX, randY, 100, 100);
        [self setImage:[UIImage imageNamed:@"bomb.png"]];
        self.contentMode = UIViewContentModeScaleAspectFill;
        [self setOpaque:NO];
        self.backgroundColor = [UIColor clearColor];
        
        //For the dropping animation
        [self addFallAnimationForLayer:self.layer];
    }
    return self;
}

-(id) initAtPoint:(CGPoint)pt{
    self = [super init];
    if(self){
        self.frame = CGRectMake(pt.x, pt.y, 100, 100);
        [self setImage:[UIImage imageNamed:@"bomb.png"]];
        self.contentMode = UIViewContentModeScaleAspectFill;
        [self setOpaque:NO];
        self.backgroundColor = [UIColor clearColor];
        
        //For the dropping animation
        [self addFallAnimationForLayer:self.layer];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


//Creates the animation of the bomb bouncing. Returns void. Takes a CALayer ptr.
-(void) addFallAnimationForLayer: (CALayer *) layer{
    NSString *keypath = @"transform.translation.y";
    CAKeyframeAnimation *translation = [CAKeyframeAnimation animationWithKeyPath:keypath];
    translation.duration = 1.5f;
    translation.repeatCount = HUGE_VAL;
    translation.autoreverses = YES;
    translation.beginTime = CACurrentMediaTime() + (float)arc4random_uniform(5) /(arc4random()%12 + 1);//current time + delay
    NSMutableArray *values = [[NSMutableArray alloc] init];
    [values addObject:[NSNumber numberWithFloat:0.0f]];
    
    CGFloat height = [[UIScreen mainScreen] bounds].size.height - layer.frame.origin.y - (layer.frame.size.height /2);
    
    [values addObject:[NSNumber numberWithFloat:height]];
    translation.values = values;
    
    NSMutableArray *timingFunctions = [[NSMutableArray alloc]init];
    [timingFunctions addObject:[CAMediaTimingFunction functionWithName: kCAMediaTimingFunctionEaseIn]];
    
    translation.timingFunctions = timingFunctions;
    
    [layer addAnimation:translation forKey:keypath];
}



@end
