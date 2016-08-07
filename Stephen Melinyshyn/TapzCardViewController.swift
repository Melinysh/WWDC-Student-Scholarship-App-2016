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
	
	func additionalSetup(_ info: CardInfo) {
		playButton.setTitleColor(UIColor.white, for: UIControlState())
		playButton.backgroundColor = self.view.tintColor
		playButton.layer.cornerRadius = 4.0
		playButton.layer.masksToBounds = true
	}
	
	override func viewDidAppear(_ animated: Bool) {
		self.infoField.setContentOffset(CGPoint.zero, animated: false)
		self.animateViews()
	}

	override func viewWillAppear(_ animated: Bool) {
		applyBallAnimations()
	}
	
	func applyBallAnimations() {
		ball.layer.removeAllAnimations()
		ball2.layer.removeAllAnimations()
		
		let position = self.view.frame.width < self.view.frame.height || UIDevice.current.userInterfaceIdiom == .pad ? "position.x" : "position.y"
		
		let animation = CAKeyframeAnimation(keyPath: position)
		animation.duration = 3.0
		animation.beginTime = CACurrentMediaTime()
		animation.repeatCount = HUGE
		let startPT = NSNumber(value: Double(self.ball.center.x))
		let endPT = position == "position.x" ? NSNumber(value: Double(self.view.frame.width - self.ball.frame.width)) : NSNumber(value: Double(self.view.frame.height - self.ball.frame.width))
		animation.values = [startPT, endPT, startPT]
		animation.isRemovedOnCompletion = false
		animation.autoreverses = true
		animation.rotationMode = kCAAnimationLinear
		let rotation = CAKeyframeAnimation(keyPath: "transform.rotation")
		rotation.duration = 1.0
		rotation.repeatCount = HUGE
		rotation.fillMode = kCAFillModeForwards
		rotation.isRemovedOnCompletion = false
		rotation.isCumulative = true
		//rotation.delegate = self
		let currentAngle =  Float(0.0)
		let a1 = currentAngle + (0.5 * Float(M_PI))
		let a2 = currentAngle + Float(M_PI)
		let angles : [NSNumber] = [
			NSNumber(value: currentAngle),
			NSNumber(value: a1),
			NSNumber(value: a2)
		]
		rotation.values = angles
		
		self.ball.layer.add(rotation, forKey: "show")
		self.ball.layer.add(animation, forKey: "pos")
		
		let animation2 = CAKeyframeAnimation(keyPath: position)
		animation2.duration = 3.0
		animation2.beginTime = CACurrentMediaTime() + 0.5
		animation2.repeatCount = HUGE
		animation2.values = [startPT, endPT, startPT]
		animation2.isRemovedOnCompletion = false
		animation2.autoreverses = true
		animation2.rotationMode = kCAAnimationLinear
		let rotation2 = CAKeyframeAnimation(keyPath: "transform.rotation")
		rotation2.duration = 1.0
		rotation2.beginTime = CACurrentMediaTime() + 0.5
		rotation2.repeatCount = HUGE
		rotation2.fillMode = kCAFillModeForwards
		rotation2.isRemovedOnCompletion = false
		rotation2.isCumulative = true
		//∫	rotation2.delegate = self
		rotation2.values = angles
		self.ball2.layer.add(rotation2, forKey: "show")
		self.ball2.layer.add(animation2, forKey: "pos")
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
