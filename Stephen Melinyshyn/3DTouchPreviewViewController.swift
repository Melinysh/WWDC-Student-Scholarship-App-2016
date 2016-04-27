//
//  3DTouchPreviewViewController.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-26.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit

class PreviewViewController: UIViewController {

	@IBOutlet weak var textField: UITextView!
	
	
	override func viewDidAppear(animated: Bool) {
		self.textField.setContentOffset(CGPointZero, animated: false)
	}
}
