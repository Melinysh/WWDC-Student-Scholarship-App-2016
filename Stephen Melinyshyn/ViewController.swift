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
	
	let progressIndicator = UIProgressView(progressViewStyle: UIProgressViewStyle.Bar)
	
	
	var verticleOffset : CGFloat!
	var horizontalOffset : CGFloat!
	
	var previewingContext : UIViewControllerPreviewing!
	
	@IBOutlet weak var resetButton: UIButton!
	@IBOutlet weak var undoButton: UIButton!
	
	
	@IBAction func undo(sender: AnyObject) {
		progressIndicator.setProgress(progressIndicator.progress - (Float(1.0) / Float(self.cardViews.count)), animated: true)
		guard let currentTopCard = self.view.subviews.last as? CardView else {
			generateCardViews()
			viewsAndRotations[cardViews.first!] = 0 // don't rotate the single card
			dropCard(cardViews.first!)
			return
		}
		for i in 0..<cardViews.count {
			if cardViews[i] == currentTopCard && i < cardViews.count - 1 {
				let c = cardViews[i+1]
				c.setup(c.info)
				dropCard(c)
				
				self.progressIndicator.tintColor = c.backgroundColor
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
		progressIndicator.setProgress(0.0, animated: true)
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
				//card.userInteractionEnabled = tr
				animator.removeAllBehaviors()
				let gravity = UIGravityBehavior(items: [card])
				gravity.gravityDirection = CGVectorMake(translation.x/15, translation.y/15) //pulled in the direction of the swipe
				animator.addBehavior(gravity)
				
				UIView.animateKeyframesWithDuration(0.1, delay: 0.3, options: UIViewKeyframeAnimationOptions(), animations: { () -> Void in
					card.alpha = 0
					}, completion: { (fin) -> Void in
						// reset attributes
						if !(card.subviews.last is UIStackView) { card.subviews.last!.removeFromSuperview() } // remove detail view from card
						card.setup(card.info)
						card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.didTapCard)))
						card.removeFromSuperview()
						self.animator.removeAllBehaviors()
						
						let newProgress = Float(1.0) / Float(self.cardViews.count) + self.progressIndicator.progress
						self.progressIndicator.setProgress(newProgress, animated: true)
						
						self.viewsAndRotations[card] = 0

						if let newTopCard = self.view.subviews.last as? CardView {
							UIView.animateWithDuration(0.3, animations: { () -> Void in
								newTopCard.center = self.view.center
								self.undoButton.alpha = 1
							})
							self.snapBehavior = UISnapBehavior(item: newTopCard, snapToPoint: self.view.center)
							self.animator.addBehavior(self.snapBehavior)
							self.view.backgroundColor = newTopCard.backgroundColor
							UIApplication.sharedApplication().keyWindow?.backgroundColor = newTopCard.backgroundColor
							self.progressIndicator.tintColor = newTopCard.backgroundColor
						} else {
							let alert = UIAlertController(title: "You're all done!", message: "Go back to the start?", preferredStyle: UIAlertControllerStyle.Alert)
							let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.Cancel, handler: { (a) -> Void in
								self.reset(self)
							})
							let no = UIAlertAction(title: "No, thanks", style: .Default, handler: nil)
							alert.addAction(yes)
							alert.addAction(no)
							self.presentViewController(alert, animated: true, completion: nil)
						}
						print("There are \(self.view.subviews.count) subviews left.")
						if self.traitCollection.forceTouchCapability == .Available {
							self.previewingContext = self.registerForPreviewingWithDelegate(self, sourceView: self.view)
						}
				})
				
			}
		}
	}

	
	override func viewDidLoad() {
		super.viewDidLoad()
		animator = UIDynamicAnimator(referenceView: view)
		NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(rotated), name: UIDeviceOrientationDidChangeNotification, object: nil)
		if traitCollection.forceTouchCapability == .Available {
			previewingContext =  self.registerForPreviewingWithDelegate(self, sourceView: view)
		}
	}
	
	override func viewDidDisappear(animated: Bool) {
		NSNotificationCenter.defaultCenter().removeObserver(self)
	}
	
	override func viewDidAppear(animated: Bool) {
		verticleOffset = self.view.frame.height/7
		horizontalOffset = self.view.frame.width/11
		progressIndicator.translatesAutoresizingMaskIntoConstraints = false
		view.insertSubview(progressIndicator, atIndex: 1)
		self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[indicator]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["indicator" : progressIndicator]))
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
			
			card.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapCard)))
			
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
				self.view.backgroundColor = card.backgroundColor
				UIApplication.sharedApplication().keyWindow?.backgroundColor = card.backgroundColor
			}
			
			// prepare to animate
			self.view.addSubview(card)
			
			// apply constraints
			applyConstraintsToCard(card)
			
			UIView.animateWithDuration(0.30, delay: 0.3 * Double(i), usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
				card.alpha = 1
				card.layer.shadowOpacity = 0.8
				card.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(self.viewsAndRotations[card]!), CGAffineTransformMakeScale(1, 1))
			}, completion: nil)
		}
		UIView.animateWithDuration(0.40, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
			self.undoButton.alpha = 0
		}, completion: nil)
	}
	
	func dropCard(card :CardView) {
		
		// prepare to animate
		card.transform = CGAffineTransformMakeScale(1.35, 1.35)

		self.view.addSubview(card)
		self.view.backgroundColor = card.backgroundColor
		applyConstraintsToCard(card)

		
		UIView.animateWithDuration(0.30, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
			card.alpha = 1
			card.subviews.forEach { $0.alpha = 1 }
			card.layer.shadowOpacity = 0.8
			card.transform = CGAffineTransformConcat(CGAffineTransformMakeRotation(self.viewsAndRotations[card]!), CGAffineTransformMakeScale(1, 1))
			}, completion: nil)
	}
	
	func applyConstraintsToCard(card : CardView) {
		//	print("View height: \(view.frame.height) and /7 is \(view.frame.height/7) [verticle]")
		//print("View width: \(view.frame.width) and /11 is \(view.frame.height/11) [horiz]")
		// apply constraints
		let verticle = NSLayoutConstraint.constraintsWithVisualFormat("V:|-offset-[card]-offset-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: ["offset": verticleOffset], views: ["card" : card])
		//let align = NSLayoutConstraint(item: card, attribute: .CenterX, relatedBy: .Equal, toItem: self.view, attribute: .CenterX, multiplier: 1, constant: 1)
		let horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|-hOffset-[card]-hOffset-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: ["hOffset" : horizontalOffset], views: ["card" : card])
		//let left = NSLayoutConstraint(item: card, attribute: .Leading, relatedBy: .GreaterThanOrEqual, toItem: self.view, attribute: .LeadingMargin, multiplier: 1, constant: 1)
		//	let right = NSLayoutConstraint(item: card, attribute: .Trailing, relatedBy: .GreaterThanOrEqual, toItem: self.view, attribute: .TrailingMargin, multiplier: 1, constant: 1)
		self.view.addConstraints(verticle + horizontal)
		//self.view.addConstraint(align)
	}
	
	override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
		super.viewWillTransitionToSize(size, withTransitionCoordinator: coordinator)
		guard let topCard = self.view.subviews.last as? CardView else {
			return
		}
		// set shadow back after arbitrary time delay to avoid shadow appearing misplaced during rotation. Not a fan of this hack.
		dispatch_async(dispatch_get_main_queue()) {
			UIView.animateWithDuration(1.2, animations: {
				self.view.subviews.filter { $0 is CardView }.forEach{$0.layer.shadowOpacity = 0}
			})
			self.animator.removeAllBehaviors()
			//	let newPT = CGPoint(x: self.view.center.y, y: self.view.center.x)
			self.snapBehavior = UISnapBehavior(item: topCard, snapToPoint: self.view.center)
			self.animator.addBehavior(self.snapBehavior)
			self.cardViews.forEach { $0.updateConstraints() }
		}
	}
	
	func rotated() {

		// set shadow back after arbitrary time delay to avoid shadow appearing misplaced during rotation. Not a fan of this hack.
		dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64( 300 * USEC_PER_SEC)), dispatch_get_main_queue()) {
			UIView.animateWithDuration(1.5, animations: {
				self.view.subviews.filter { $0 is CardView }.forEach{$0.layer.shadowOpacity = 0.8}
			})
		}
	}

	// Card Interactions
	func didTapCard(tap : UITapGestureRecognizer?) {
		guard let card = self.view.subviews.last as? CardView else { return }
		if card.stackView.alpha == 0 { return } // card has already been expanded
		UIView.animateWithDuration(0.15, animations: {
			card.stackView.alpha = 0
			card.layer.shadowOpacity = 0
			}) { (finished) in
				let firstCardConstraints = self.view.constraints.filter {$0.firstItem is CardView}.filter{$0.firstItem as! CardView == card}
				let secondCardConstraints = self.view.constraints.filter {$0.secondItem is CardView}.filter{$0.secondItem as! CardView == card}

				UIView.animateWithDuration(0.3, animations: {
					firstCardConstraints.forEach { $0.constant = 0 }
					secondCardConstraints.forEach { $0.constant = 0 }
					card.layer.cornerRadius = 0
					self.view.layoutIfNeeded()
				}) { (fin) in
					
					let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier(card.info.storyboard) as! DetailViewControllable
					detailVC.view.frame = self.view.frame
					card.addSubview(detailVC.view)
					detailVC.initViews(card.info)
					card.removeGestureRecognizer(card.gestureRecognizers!.last!)
					
					//	card.removeGestureRecognizer(card.gestureRecognizers!.first!)
					let verticle = NSLayoutConstraint.constraintsWithVisualFormat("V:|[detV]|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: ["detV" : detailVC.view])
					let horizontal = NSLayoutConstraint.constraintsWithVisualFormat("H:|[detV]|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ["detV" : detailVC.view])
					card.addConstraints(verticle + horizontal)
					card.updateConstraints()
					detailVC.view.updateConstraints()
					//detailVC.animateViews()
					
					if self.traitCollection.forceTouchCapability == .Available {
						self.unregisterForPreviewingWithContext(self.previewingContext)
					}
				}
		}
	}
	
	
}

