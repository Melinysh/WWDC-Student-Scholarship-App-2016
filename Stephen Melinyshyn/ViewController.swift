//
//  ViewController.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-18.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
	var viewsAndRotations = [CardView : CGFloat]()
	var cardViews = [CardView]()
	
	// For card animation during drags
	var animator : UIDynamicAnimator!
	var attachmentBehavior : UIAttachmentBehavior?
	var snapBehavior : UISnapBehavior!
	
	@IBOutlet weak var resetButton: UIButton!
	@IBOutlet weak var undoButton: UIButton!
	
	@IBAction func undo(sender: AnyObject) {
		guard let currentTopCard = self.view.subviews.last as? CardView else { return }
		for i in 0..<cardViews.count {
			if cardViews[i] == currentTopCard && i < cardViews.count - 1 {
				dropCard(cardViews[i+1])
				
				// if undo puts back top card, remove undo button
				if i+1 == cardViews.count - 1 {
					UIView.animateWithDuration(0.40, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
						self.undoButton.alpha = 0
					}, completion: nil)
				}
				return
			}
		}
	}
	
	@IBAction func reset(sender: AnyObject) {
		generateCardViews()
		dropCards()
	}
	
	@IBAction func panDetected(sender: AnyObject) {
		guard let card = self.view.subviews.last as? CardView else { return }
		let location = sender.locationInView(view)
		let boxLocation = sender.locationInView(card)
		if sender.state == UIGestureRecognizerState.Began {
			if let b = attachmentBehavior {
				animator.removeBehavior(b)
			}
			let centerOffset = UIOffsetMake(boxLocation.x - CGRectGetMidX(card.bounds), boxLocation.y - CGRectGetMidY(card.bounds))
			attachmentBehavior = UIAttachmentBehavior(item: card, offsetFromCenter: centerOffset, attachedToAnchor: location)
			animator.addBehavior(attachmentBehavior!)
		} else if sender.state == UIGestureRecognizerState.Changed {
			attachmentBehavior!.anchorPoint = location
		} else if sender.state == UIGestureRecognizerState.Ended {
			animator.removeBehavior(attachmentBehavior!)
			snapBehavior = UISnapBehavior(item: card, snapToPoint: view.center)
			animator.addBehavior(snapBehavior)
			
			let translation = sender.translationInView(view)
			if abs(translation.y) > 100 || abs(translation.x) > 100 {
				card.userInteractionEnabled = false
				animator.removeAllBehaviors()
				let gravity = UIGravityBehavior(items: [card])
				gravity.gravityDirection = CGVectorMake(translation.x/15, translation.y/15) //pulled in the direction of the swipe
				animator.addBehavior(gravity)
				
				UIView.animateKeyframesWithDuration(0.1, delay: 0.3, options: UIViewKeyframeAnimationOptions(), animations: { () -> Void in
					card.alpha = 0
					}, completion: { (fin) -> Void in
						card.removeFromSuperview()
						self.animator.removeAllBehaviors()
						
						self.viewsAndRotations[card] = 0

						if let newTopCard = self.view.subviews.last as? CardView {
							UIView.animateWithDuration(0.3, animations: { () -> Void in
								newTopCard.center = self.view.center
								self.undoButton.alpha = 1
							})
							self.snapBehavior = UISnapBehavior(item: newTopCard, snapToPoint: self.view.center)
							self.animator.addBehavior(self.snapBehavior)
							//self.view.backgroundColor = newTopCard.backgroundColor
						} else {
							let alert = UIAlertController(title: "You're all done!", message: "Go back to the start?", preferredStyle: UIAlertControllerStyle.Alert)
							let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Cancel, handler: { (a) -> Void in
								self.generateCardViews()
								self.dropCards()
							})
							let no = UIAlertAction(title: "No, thanks", style: .Default, handler: nil)
							alert.addAction(yes)
							alert.addAction(no)
							self.presentViewController(alert, animated: true, completion: nil)
						}
						print("There are \(self.view.subviews.count) subviews left.")
				})
				
			}
		}
	}

	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		animator = UIDynamicAnimator(referenceView: view)
		
		generateCardViews()
		dropCards()
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func generateCardViews() {
		viewsAndRotations.removeAll()
		cardViews.forEach{$0.removeFromSuperview()}
		cardViews.removeAll()
		CardData().allCardInfo().forEach { (info) in
			let card = UINib(nibName: "Card", bundle: nil).instantiateWithOwner(CardView(), options: nil).first! as! CardView
			card.setup(info)
			
			// generate angle 
			var angle : Float = Float(arc4random_uniform(10)) // in degress
			
			if arc4random() % 2 == 1 { //50% chance of negative angle.
				angle = -angle
			}
			//convert angle into radians
			angle *= (Float(M_PI) / Float(180))
			viewsAndRotations[card] = CGFloat(angle)
			
			cardViews.append(card)
		}
	}
	
	func dropUptoCard(cardNumber : Int) {
		cardViews = Array(cardViews[0..<cardNumber])
		dropCards()
	}

	
	func dropCards() {
		for i in 0..<cardViews.count {
			let card = cardViews[i]
			if i == cardViews.count - 1 {
				self.viewsAndRotations[card] = CGFloat(0)
				//	self.view.backgroundColor = card.backgroundColor
			}
			self.view.addSubview(card)
			
			// apply constraints
			let verticle = NSLayoutConstraint.constraintsWithVisualFormat("V:|-offset-[card]-offset-|", options: NSLayoutFormatOptions(), metrics: ["offset": self.view.frame.height/8], views: ["card" : card])
			let horizontal = NSLayoutConstraint(item: card, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 1)
			let ratio = NSLayoutConstraint(item: card, attribute: NSLayoutAttribute.Width, relatedBy: .Equal, toItem: card, attribute: NSLayoutAttribute.Height, multiplier: 0.6, constant: 1)
			//let left = NSLayoutConstraint(item: card, attribute: .Leading, relatedBy: .GreaterThanOrEqual, toItem: self.view, attribute: .LeadingMargin, multiplier: 1, constant: 1)
			//	let right = NSLayoutConstraint(item: card, attribute: .Trailing, relatedBy: .GreaterThanOrEqual, toItem: self.view, attribute: .TrailingMargin, multiplier: 1, constant: 1)
			self.view.addConstraints(verticle)
			self.view.addConstraints([ratio, horizontal/*, left, right*/])
			
			
			UIView.animateWithDuration(0.30, delay: 0.3 * Double(i), usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
				card.alpha = 1
				card.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(self.viewsAndRotations[card]!), CGAffineTransformMakeScale(1, 1))
				}, completion: nil)
		}
		UIView.animateWithDuration(0.40, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
			self.undoButton.alpha = 0
			}, completion: nil)
	}
	
	func dropCard(card :CardView) {
		
		self.view.addSubview(card)
		
		// apply constraints
		let verticle = NSLayoutConstraint.constraintsWithVisualFormat("V:|-offset-[card]-offset-|", options: NSLayoutFormatOptions(), metrics: ["offset": self.view.frame.height/8], views: ["card" : card])
		let horizontal = NSLayoutConstraint(item: card, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 1)
		let ratio = NSLayoutConstraint(item: card, attribute: NSLayoutAttribute.Width, relatedBy: .Equal, toItem: card, attribute: NSLayoutAttribute.Height, multiplier: 0.6, constant: 1)
		self.view.addConstraints(verticle)
		self.view.addConstraint(ratio)
		self.view.addConstraint(horizontal)
		
		
		UIView.animateWithDuration(0.30, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
			card.alpha = 1
			card.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(self.viewsAndRotations[card]!), CGAffineTransformMakeScale(1, 1))
			}, completion: nil)
	}
	
	
}

