//
//  NearbeyeCardViewController.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-23.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit
import SafariServices

class NearbeyeCardViewController: UIViewController, DetailViewControllable {

	@IBOutlet weak var githubButton: UIButton!
	@IBOutlet weak var screenshot3: UIImageView!
	@IBOutlet weak var screenshot2: UIImageView!
	@IBOutlet weak var screenshot1: UIImageView!
	@IBOutlet weak var stackview: UIStackView!
	@IBOutlet weak var infoField: UITextView!

	@IBAction func seeOnGithub(_ sender: AnyObject) {
		let sfVC = SFSafariViewController(url: URL(string: "https://github.com/Melinysh/NearbEYE")!)
		self.present(sfVC, animated: true, completion: nil)
	}

	override var canBecomeFirstResponder: Bool {
		return true
	}
	
	override func viewDidAppear(_ animated: Bool) {
		self.infoField.setContentOffset(CGPoint.zero, animated: false)
		self.animateViews()

	}
	
	func additionalSetup(_ info: CardInfo) {
		self.becomeFirstResponder()
		githubButton.setTitleColor(UIColor.white, for: UIControlState())
		githubButton.backgroundColor = self.view.tintColor
		githubButton.layer.cornerRadius = 4.0
		githubButton.layer.masksToBounds = true

		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
	}
	
	func didTap(_ sender : UIGestureRecognizer) {
		let pt = sender.location(in: stackview)
		let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "screenshotDetail") as! DetailScreenshotViewController
		detailVC.view.backgroundColor = self.view.backgroundColor
		if screenshot1.frame.contains(pt) {
			detailVC.imageView.image = screenshot1.image
			detailVC.navBar.topItem?.title = "Main Camera View"
		} else if screenshot2.frame.contains(pt) {
			detailVC.imageView.image = screenshot2.image
			detailVC.navBar.topItem?.title = "Detail View With Map Highlight"
		} else if screenshot3.frame.contains(pt) {
			detailVC.imageView.image = screenshot3.image
			detailVC.navBar.topItem?.title = "Another Camera View"
		} else {
			return
		}
		self.present(detailVC, animated: true, completion: nil)
	}
}
