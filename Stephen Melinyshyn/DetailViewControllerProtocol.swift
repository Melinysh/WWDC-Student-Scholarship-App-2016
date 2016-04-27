//
//  DetailViewControllerProtocol.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-20.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit

 protocol DetailViewControllable {
	func additionalSetup(info : CardInfo)
	var view : UIView! { get set }
	var infoField : UITextView! { get set }
}

extension DetailViewControllable {
	func initViews(info : CardInfo) {
		view.backgroundColor = info.backgroundColor
		//print(view.frame)
		let bgC = CGColorGetComponents(info.backgroundColor.CGColor)
		infoField.backgroundColor = UIColor(red: bgC[0] * 0.8, green: bgC[1] * 0.8, blue: bgC[2] * 0.8, alpha: 1)
		infoField.text = info.info
		infoField.textColor = info.textColor
		infoField.layer.cornerRadius = 5
		infoField.editable = false
		infoField.font = UIFont(name: "Avenir-Book", size: 19)
		view.subviews.forEach { $0.alpha = 0 }
		additionalSetup(info)
	}
	
	func animateViews() {
		UIView.animateWithDuration(0.4) { 
			self.view.subviews.forEach { $0.alpha = 1 }
		}

	}
}