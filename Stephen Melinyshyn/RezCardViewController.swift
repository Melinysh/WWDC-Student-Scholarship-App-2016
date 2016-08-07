//
//  RezCardViewController.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-23.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit

class RezCardViewController: UIViewController, DetailViewControllable {

	@IBOutlet weak var infoField: UITextView!
	
	@IBOutlet weak var screenshot1: UIImageView!
	@IBOutlet weak var screenshot3: UIImageView!
	@IBOutlet weak var screenshot2: UIImageView!
	@IBOutlet weak var stackView: UIStackView!
	
	override var canBecomeFirstResponder: Bool {
		return true
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		self.infoField.setContentOffset(CGPoint.zero, animated: false)
		self.animateViews()
	}
	
	func additionalSetup(_ info: CardInfo) {
		self.becomeFirstResponder()
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
	}

	func didTap(_ sender : UIGestureRecognizer) {
		let pt = sender.location(in: stackView)
		let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "screenshotDetail") as! DetailScreenshotViewController
		detailVC.view.backgroundColor = self.view.backgroundColor
		if screenshot1.frame.contains(pt) {
			detailVC.imageView.image = screenshot1.image
			detailVC.navBar.topItem?.title = "Main Items View"
		} else if screenshot3.frame.contains(pt) {
			detailVC.imageView.image = screenshot3.image
			detailVC.navBar.topItem?.title = "Rez Menu"
		} else if screenshot2.frame.contains(pt) {
			detailVC.imageView.image = screenshot2.image
			detailVC.navBar.topItem?.title = "Reading an Article"
		} else {
			return
		}
		self.present(detailVC, animated: true, completion: nil)
	}
	
}
