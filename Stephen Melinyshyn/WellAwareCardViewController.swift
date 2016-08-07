//
//  WellAwareCardViewController.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-23.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit

class WellAwareCardViewController: UIViewController, DetailViewControllable {
	@IBOutlet weak var stackView: UIStackView!

	@IBOutlet weak var screenshot1: UIImageView!
	@IBOutlet weak var screenshot2: UIImageView!
	@IBOutlet weak var infoField: UITextView!

	override func viewDidAppear(_ animated: Bool) {
		self.infoField.setContentOffset(CGPoint.zero, animated: false)
		self.animateViews()
	}
	
	override var canBecomeFirstResponder: Bool {
		return true
	}
	
	func additionalSetup(_ info: CardInfo) {
		becomeFirstResponder()
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
	}
	
	func didTap(_ sender : UIGestureRecognizer) {
		let pt = sender.location(in: stackView)
		let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "screenshotDetail") as! DetailScreenshotViewController
		detailVC.view.backgroundColor = self.view.backgroundColor
		if screenshot1.frame.contains(pt) {
			detailVC.imageView.image = screenshot1.image
			detailVC.navBar.topItem?.title = "Work-In-Progress Menu"
		}  else if screenshot2.frame.contains(pt) {
			detailVC.imageView.image = screenshot2.image
			detailVC.navBar.topItem?.title = "Main Map View"
		} else {
			return
		}
		self.present(detailVC, animated: true, completion: nil)
	}
}
