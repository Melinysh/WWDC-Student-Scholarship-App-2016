//
//  TapzCardViewController.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-20.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit

class TapzCardViewController: UIViewController, DetailViewControllable {

	@IBOutlet weak var ball: UIImageView!
	@IBOutlet weak var ball2: UIImageView!
	@IBOutlet weak var infoField: UITextView!
	@IBOutlet weak var playButton: UIButton!



	override func viewDidLoad() {
		super.viewDidLoad()
		// Do any additional setup after loading the view.
	}
	

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func additionalSetup(info: CardInfo) {		
	}

	
	override func traitCollectionDidChange(previousTraitCollection: UITraitCollection?) {
		ball.removeFromSuperview()
		ball2.removeFromSuperview()
		self.view.addSubview(ball)
		self.view.addSubview(ball2)
		applyBallAnimations()
	}
	
	func applyBallAnimations() {
		ball.layer.removeAllAnimations()
		ball2.layer.removeAllAnimations()
		
		let position = self.view.frame.width < self.view.frame.height || UIDevice.currentDevice().userInterfaceIdiom == .Pad ? "position.x" : "position.y"
		
		let animation = CAKeyframeAnimation(keyPath: position)
		animation.duration = 3.0
		animation.beginTime = CACurrentMediaTime()
		animation.repeatCount = HUGE
		let startPT = NSNumber(double: Double(self.ball.center.x))
		let endPT = position == "position.x" ? NSNumber(double: Double(self.view.frame.width - self.ball.frame.width)) : NSNumber(double: Double(self.view.frame.height - self.ball.frame.width))
		animation.values = [startPT, endPT, startPT]
		animation.removedOnCompletion = false
		animation.autoreverses = true
		animation.rotationMode = kCAAnimationLinear
		let rotation = CAKeyframeAnimation(keyPath: "transform.rotation")
		rotation.duration = 1.0
		rotation.repeatCount = HUGE
		rotation.fillMode = kCAFillModeForwards
		rotation.removedOnCompletion = false
		rotation.cumulative = true
		rotation.delegate = self
		let currentAngle =  Float(0.0)
		let a1 = currentAngle + (0.5 * Float(M_PI))
		let a2 = currentAngle + Float(M_PI)
		let angles : [NSNumber] = [
			NSNumber(float: currentAngle),
			NSNumber(float: a1),
			NSNumber(float: a2)
		]
		rotation.values = angles
		
		self.ball.layer.addAnimation(rotation, forKey: "show")
		self.ball.layer.addAnimation(animation, forKey: "pos")
		
		let animation2 = CAKeyframeAnimation(keyPath: position)
		animation2.duration = 3.0
		animation2.beginTime = CACurrentMediaTime() + 0.5
		animation2.repeatCount = HUGE
		animation2.values = [startPT, endPT, startPT]
		animation2.removedOnCompletion = false
		animation2.autoreverses = true
		animation2.rotationMode = kCAAnimationLinear
		let rotation2 = CAKeyframeAnimation(keyPath: "transform.rotation")
		rotation2.duration = 1.0
		rotation2.beginTime = CACurrentMediaTime() + 0.5
		rotation2.repeatCount = HUGE
		rotation2.fillMode = kCAFillModeForwards
		rotation2.removedOnCompletion = false
		rotation2.cumulative = true
		rotation2.delegate = self
		rotation2.values = angles
		self.ball2.layer.addAnimation(rotation2, forKey: "show")
		self.ball2.layer.addAnimation(animation2, forKey: "pos")
	}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
