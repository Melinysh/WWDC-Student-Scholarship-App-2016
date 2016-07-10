//
//  WattpadCardViewController.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-23.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit
import SafariServices

class WattpadCardViewController: UIViewController, DetailViewControllable {
	@IBOutlet weak var infoField: UITextView!

	@IBOutlet weak var wattpadButton: UIButton!
	@IBOutlet weak var image1: UIImageView!
	@IBOutlet weak var image2: UIImageView!
	@IBOutlet weak var stackView: UIStackView!
	
	@IBAction func goToWattpad(_ sender: AnyObject) {
		let sfVC = SFSafariViewController(url: URL(string: "https://wattpad.com")!)
		self.present(sfVC, animated: true, completion: nil)
	}
	
	override func canBecomeFirstResponder() -> Bool {
		return true
	}
	
	override func viewDidAppear(_ animated: Bool) {
		self.infoField.setContentOffset(CGPoint.zero, animated: false)
		self.animateViews()
	}
	
	func additionalSetup(_ info: CardInfo) {
		self.becomeFirstResponder()
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
		wattpadButton.setTitleColor(UIColor.white(), for: UIControlState())
		wattpadButton.backgroundColor = self.view.tintColor
		wattpadButton.layer.cornerRadius = 4.0
		wattpadButton.layer.masksToBounds = true
	}
	
	func didTap(_ sender : UIGestureRecognizer) {
		let pt = sender.location(in: stackView)
		let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "screenshotDetail") as! DetailScreenshotViewController
		detailVC.view.backgroundColor = self.view.backgroundColor
		if image1.frame.contains(pt) {
			detailVC.imageView.image = image1.image
			detailVC.navBar.topItem?.title = "Wattpad CEO Allen Lau"
		} else if image2.frame.contains(pt) {
			detailVC.imageView.image = image2.image
			detailVC.navBar.topItem?.title = "Wattpad Games Room"
		} else {
			return
		}
		self.present(detailVC, animated: true, completion: nil)
	}
}
