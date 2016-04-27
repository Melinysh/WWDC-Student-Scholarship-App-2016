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
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
    }
	
	override func canBecomeFirstResponder() -> Bool {
		return true
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	override func viewDidAppear(animated: Bool) {
		self.infoField.setContentOffset(CGPointZero, animated: false)
		self.animateViews()

	}
	
	func additionalSetup(info: CardInfo) {
		self.becomeFirstResponder()
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
	}

	func didTap(sender : UIGestureRecognizer) {
		let pt = sender.locationInView(stackView)
		let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("screenshotDetail") as! DetailScreenshotViewController
		detailVC.view.backgroundColor = self.view.backgroundColor
		if CGRectContainsPoint(screenshot1.frame, pt) {
			detailVC.imageView.image = screenshot1.image
			detailVC.navBar.topItem?.title = "Main Items View"
		} else if CGRectContainsPoint(screenshot3.frame, pt) {
			detailVC.imageView.image = screenshot3.image
			detailVC.navBar.topItem?.title = "Rez Menu"
		} else if CGRectContainsPoint(screenshot2.frame, pt) {
			detailVC.imageView.image = screenshot2.image
			detailVC.navBar.topItem?.title = "Reading an Article"
		} else {
			return
		}
		self.presentViewController(detailVC, animated: true, completion: nil)
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
