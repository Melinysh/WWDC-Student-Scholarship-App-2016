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
	
	let progressIndicator = UIProgressView(progressViewStyle: UIProgressViewStyle.bar)
	
	
	var cardIndexToDrop = -1 {
		didSet {
			self.generateCardViews()
			self.dropUptoCard(cardIndexToDrop)
		}
	}
	
	var verticleOffset : CGFloat!
	var horizontalOffset : CGFloat!
	
	var previewingContext : UIViewControllerPreviewing!
	
	@IBOutlet weak var resetButton: UIButton!
	@IBOutlet weak var undoButton: UIButton!
	
	
	@IBAction func undo(_ sender: AnyObject) {
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
					weak var weakSelf = self
					UIView.animate(withDuration: 0.40, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
						weakSelf?.undoButton.alpha = 0
					}, completion: nil)
				}
				return
			}
		}
	}
	
	@IBAction func reset(_ sender: AnyObject) {
		progressIndicator.setProgress(0.0, animated: true)
		generateCardViews()
		dropCards()
	}
	
	@IBAction func panDetected(_ sender: AnyObject) {
		guard let card = self.view.subviews.last as? CardView else { return }
		let location = sender.location(in: view)
		let boxLocation = sender.location(in: card)
		if sender.state == UIGestureRecognizerState.began {
			if let b = attachmentBehavior {
				animator.removeBehavior(b)
			}
			
			let centerOffset = UIOffsetMake(boxLocation.x - card.bounds.midX, boxLocation.y - card.bounds.midY)
			attachmentBehavior = UIAttachmentBehavior(item: card, offsetFromCenter: centerOffset, attachedToAnchor: location)
			animator.addBehavior(attachmentBehavior!)
		} else if sender.state == UIGestureRecognizerState.changed {
			attachmentBehavior!.anchorPoint = location
		} else if sender.state == UIGestureRecognizerState.ended {
			let translation = sender.translation(in: view)
			if abs(translation.y) > 100 || abs(translation.x) > 100 {
				attachmentBehavior?.anchorPoint = location

				weak var weakSelf = self
				UIView.animateKeyframes(withDuration: 0.4, delay: 0.0, options: UIViewKeyframeAnimationOptions(), animations: { () -> Void in
					card.alpha = 0
					card.isUserInteractionEnabled = false
					}, completion: { (fin) -> Void in
						guard let actualSelf = weakSelf else { return }
						
						// reset attributes
						if !(card.subviews.last is UIStackView) { card.subviews.last!.removeFromSuperview() } // remove detail view from card
						card.setup(card.info)
						card.addGestureRecognizer(UITapGestureRecognizer(target: actualSelf, action: #selector(actualSelf.didTapCard)))
						card.removeFromSuperview()
						actualSelf.animator.removeAllBehaviors()
						
						let newProgress = Float(1.0) / Float(actualSelf.cardViews.count) + actualSelf.progressIndicator.progress
						actualSelf.progressIndicator.setProgress(newProgress, animated: true)
						
						actualSelf.viewsAndRotations[card] = 0

						if let newTopCard = actualSelf.view.subviews.last as? CardView {
							UIView.animate(withDuration: 0.3, animations: { () -> Void in
								newTopCard.center = actualSelf.view.center
								actualSelf.undoButton.alpha = 1
							})
							actualSelf.snapBehavior = UISnapBehavior(item: newTopCard, snapTo: actualSelf.view.center)
							actualSelf.animator.addBehavior(actualSelf.snapBehavior)
							actualSelf.view.backgroundColor = newTopCard.backgroundColor
							UIApplication.shared.keyWindow?.backgroundColor = newTopCard.backgroundColor
							actualSelf.progressIndicator.tintColor = newTopCard.backgroundColor
						} else {
							let alert = UIAlertController(title: "You're all done!", message: "Go back to the start?", preferredStyle: UIAlertControllerStyle.alert)
							let yes = UIAlertAction(title: "Yes", style: UIAlertActionStyle.cancel, handler: { (a) -> Void in
								actualSelf.reset(actualSelf)
							})
							let no = UIAlertAction(title: "No, thanks", style: .default, handler: nil)
							alert.addAction(yes)
							alert.addAction(no)
							actualSelf.present(alert, animated: true, completion: nil)
						}
						print("There are \(self.view.subviews.count) subviews left.")
						if actualSelf.traitCollection.forceTouchCapability == .available {
							actualSelf.previewingContext = actualSelf.registerForPreviewing(with: actualSelf, sourceView: actualSelf.view)
						}
				})
			}
		}
	}

	
	override func viewDidLoad() {
		super.viewDidLoad()
		animator = UIDynamicAnimator(referenceView: view)
		if traitCollection.forceTouchCapability == .available {
			previewingContext =  self.registerForPreviewing(with: self, sourceView: view)
		}
	}
	
	override func viewDidDisappear(_ animated: Bool) {
		NotificationCenter.default.removeObserver(self)
	}
	
	override func viewDidAppear(_ animated: Bool) {
		verticleOffset = self.view.frame.height/7
		horizontalOffset = self.view.frame.width/11
		progressIndicator.translatesAutoresizingMaskIntoConstraints = false
		view.insertSubview(progressIndicator, at: 1)
		self.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[indicator]|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: nil, views: ["indicator" : progressIndicator]))
		if cardIndexToDrop == -1 {
			generateCardViews()
			dropCards()
		}
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
			let card = UINib(nibName: "Card", bundle: nil).instantiate(withOwner: CardView(), options: nil).first! as! CardView
			
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
	
	func dropUptoCard(_ cardNumber : Int) {
		verticleOffset = self.view.frame.height/7
		horizontalOffset = self.view.frame.width/11

		for i in 0..<cardNumber {
			let card = cardViews[i]
			if i == cardNumber - 1 {
				self.viewsAndRotations[card] = CGFloat(0)
				self.view.backgroundColor = card.backgroundColor
				UIApplication.shared.keyWindow?.backgroundColor = card.backgroundColor
			}
			
			// prepare to animate
			self.view.addSubview(card)
			
			// apply constraints
			applyConstraintsToCard(card)
			
			UIView.animate(withDuration: 0.30, delay: 0.3 * Double(i), usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
				card.alpha = 1
				card.layer.shadowOpacity = 0.8
				card.transform = CGAffineTransform(rotationAngle: self.viewsAndRotations[card]!).concatenating((CGAffineTransform(scaleX: 1, y: 1)))
				}, completion: nil)
		}
			UIView.animate(withDuration: 0.40, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
				if cardNumber == self.cardViews.count-1 {
					self.undoButton.alpha = 0
				} else {
					self.undoButton.alpha = 1
				}
				}, completion: nil)
		
		// set rotation back to zero on other cards
		self.progressIndicator.setProgress(0, animated: false)
		for i in cardNumber..<cardViews.count {
			self.viewsAndRotations[cardViews[i]] = 0
			let newProgress = Float(1.0) / Float(self.cardViews.count) + self.progressIndicator.progress
			self.progressIndicator.setProgress(newProgress, animated: true)
		}
		self.progressIndicator.tintColor = cardViews[cardNumber-1].backgroundColor
	}
	

	
	func dropCards() {
		weak var weakSelf = self
		for i in 0..<cardViews.count {
			let card = cardViews[i]
			if i == cardViews.count - 1 {
				self.viewsAndRotations[card] = CGFloat(0)
				self.view.backgroundColor = card.backgroundColor
				UIApplication.shared.keyWindow?.backgroundColor = card.backgroundColor
			}
			
			// prepare to animate
			self.view.addSubview(card)
			
			// apply constraints
			applyConstraintsToCard(card)

			UIView.animate(withDuration: 0.30, delay: 0.3 * Double(i), usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
				guard let actualSelf = weakSelf else {
					return
				}
				card.alpha = 1
				card.layer.shadowOpacity = 0.8
				card.transform = CGAffineTransform(rotationAngle: actualSelf.viewsAndRotations[card]!).concatenating(CGAffineTransform(scaleX: 1, y: 1))
			}, completion: nil)
		}
		UIView.animate(withDuration: 0.40, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
			weakSelf?.undoButton.alpha = 0
		}, completion: nil)
	}
	
	func dropCard(_ card :CardView) {
		
		// prepare to animate
		card.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)

		self.view.addSubview(card)
		self.view.backgroundColor = card.backgroundColor
		applyConstraintsToCard(card)

		weak var weakSelf = self
		UIView.animate(withDuration: 0.30, delay: 0.1, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.7, options: UIViewAnimationOptions.curveEaseIn, animations: { () -> Void in
			guard let actualSelf = weakSelf else {
				return
			}
			card.alpha = 1
			card.subviews.forEach { $0.alpha = 1 }
			card.layer.shadowOpacity = 0.8
			card.transform = CGAffineTransform(rotationAngle: actualSelf.viewsAndRotations[card]!).concatenating(CGAffineTransform(scaleX: 1, y: 1))
			}, completion: nil)
	}
	
	func applyConstraintsToCard(_ card : CardView) {
		let verticle = NSLayoutConstraint.constraints(withVisualFormat: "V:|-offset-[card]-offset-|", options: NSLayoutFormatOptions.alignAllCenterX, metrics: ["offset": verticleOffset], views: ["card" : card])
		let horizontal = NSLayoutConstraint.constraints(withVisualFormat: "H:|-hOffset-[card]-hOffset-|", options: NSLayoutFormatOptions.alignAllCenterY, metrics: ["hOffset" : horizontalOffset], views: ["card" : card])
		self.view.addConstraints(verticle + horizontal)
	}

	// Card Interactions
	func didTapCard(_ tap : UITapGestureRecognizer?) {
		guard let card = self.view.subviews.last as? CardView else { return }
		if card.stackView.alpha == 0 { return } // card has already been expanded
		weak var weakSelf = self
		UIView.animate(withDuration: 0.15, animations: {
			card.stackView.alpha = 0
			card.layer.shadowOpacity = 0
			}) { (finished) in
				guard let actualSelf = weakSelf else { return }
				let firstCardConstraints = actualSelf.view.constraints.filter {$0.firstItem is CardView}.filter{$0.firstItem as! CardView == card}
				let secondCardConstraints = actualSelf.view.constraints.filter {$0.secondItem is CardView}.filter{$0.secondItem as! CardView == card}
				UIView.animate(withDuration: 0.3, animations: {
					firstCardConstraints.forEach { $0.constant = 0 }
					secondCardConstraints.forEach { $0.constant = 0 }
					card.layoutIfNeeded()
					actualSelf.view.layoutIfNeeded()
					card.layer.cornerRadius = 0
					card.frame = self.view.frame
				}) { (fin) in
					let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: card.info.storyboard) as! DetailViewControllable
					detailVC.view.frame = actualSelf.view.frame
					card.addSubview(detailVC.view)
					detailVC.initViews(card.info)
					card.removeGestureRecognizer(card.gestureRecognizers!.last!)
					card.layoutIfNeeded()
					detailVC.view.setNeedsUpdateConstraints()
					if actualSelf.traitCollection.forceTouchCapability == .available {
						actualSelf.unregisterForPreviewing(withContext: (actualSelf.previewingContext)!)
					}
				}
		}
	}
	
	
}

