//
//  WWDCCardViewController.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-23.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit

class WWDCCardViewController: UIViewController, DetailViewControllable {

	@IBOutlet weak var infoField: UITextView!
	
	override func viewDidAppear(_ animated: Bool) {
		self.infoField.setContentOffset(CGPoint.zero, animated: false)
		self.animateViews()
	}
	
	func additionalSetup(_ info: CardInfo) {
	 // no-op
	}
}
