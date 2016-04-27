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
	
	@IBAction func goToWattpad(sender: AnyObject) {
		let sfVC = SFSafariViewController(URL: NSURL(string: "https://wattpad.com")!)
		self.presentViewController(sfVC, animated: true, completion: nil)
	}
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func canBecomeFirstResponder() -> Bool {
		return true
	}
	
	override func viewDidAppear(animated: Bool) {
		self.infoField.setContentOffset(CGPointZero, animated: false)
		self.animateViews()

	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func additionalSetup(info: CardInfo) {
		self.becomeFirstResponder()
		self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTap)))
		wattpadButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
		wattpadButton.backgroundColor = self.view.tintColor
		wattpadButton.layer.cornerRadius = 4.0
		wattpadButton.layer.masksToBounds = true
	}
	
	func didTap(sender : UIGestureRecognizer) {
		let pt = sender.locationInView(stackView)
		let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("screenshotDetail") as! DetailScreenshotViewController
		detailVC.view.backgroundColor = self.view.backgroundColor
		if CGRectContainsPoint(image1.frame, pt) {
			detailVC.imageView.image = image1.image
			detailVC.navBar.topItem?.title = "Wattpad CEO Allen Lau"
		} else if CGRectContainsPoint(image2.frame, pt) {
			detailVC.imageView.image = image2.image
			detailVC.navBar.topItem?.title = "Wattpad Games Room"
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
