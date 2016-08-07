//
//  MeshwurkViewController.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-23.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit
import SafariServices

class MeshwurkViewController: UIViewController, DetailViewControllable {

	@IBOutlet weak var githubButton: UIButton!
	@IBOutlet weak var screenshot3: UIImageView!
	@IBOutlet weak var screenshot2: UIImageView!
	@IBOutlet weak var screenshot1: UIImageView!
	@IBOutlet weak var stackView: UIStackView!
	@IBOutlet weak var infoField: UITextView!

	@IBAction func seeOnGithub(_ sender: AnyObject) {
		let sfVC = SFSafariViewController(url: URL(string: "https://github.com/Melinysh/Meshwork")!)
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
		becomeFirstResponder()
		githubButton.setTitleColor(UIColor.white, for: UIControlState())
		githubButton.backgroundColor = self.view.tintColor
		githubButton.layer.cornerRadius = 4.0
		githubButton.layer.masksToBounds = true
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
	}
	
	func didTap(_ sender : UIGestureRecognizer) {
		let pt = sender.location(in: stackView)
		let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "screenshotDetail") as! DetailScreenshotViewController
		detailVC.view.backgroundColor = self.view.backgroundColor
		if screenshot1.frame.contains(pt) {
			detailVC.imageView.image = screenshot1.image
			detailVC.navBar.topItem?.title = "List Of Those Nearby"
		} else if screenshot3.frame.contains(pt) {
			detailVC.imageView.image = screenshot3.image
			detailVC.navBar.topItem?.title = "Graph View Of Those Nearby"
		} else if screenshot2.frame.contains(pt) {
			detailVC.imageView.image = screenshot2.image
			detailVC.navBar.topItem?.title = "Detail Contact View"
		} else {
			return
		}
		self.present(detailVC, animated: true, completion: nil)
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
