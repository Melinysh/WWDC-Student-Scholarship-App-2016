//
//  DetailViewControllerProtocol.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-20.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit

protocol DetailViewControllable : class {
	func additionalSetup(_ info : CardInfo)
	var view : UIView! { get set }
	var infoField : UITextView! { get set }
}

extension DetailViewControllable {
	func initViews(_ info : CardInfo) {
		view.backgroundColor = info.backgroundColor
		//print(view.frame)
		let bgC = info.backgroundColor.cgColor.components
		infoField.backgroundColor = UIColor(red: (bgC?[0])! * 0.8,
										  green: (bgC?[1])! * 0.8,
										   blue: (bgC?[2])! * 0.8,
										  alpha: 1)
		infoField.text = info.info
		infoField.textColor = info.textColor
		infoField.layer.cornerRadius = 5
		infoField.isEditable = false
		infoField.isSelectable = false
		infoField.font = UIFont(name: "Avenir-Book", size: 19)
		view.subviews.forEach { $0.alpha = 0 }
		additionalSetup(info)
	}
	
	func animateViews() {
		weak var weakSelf = self
		UIView.animate(withDuration: 0.4) { 
			weakSelf?.view.subviews.forEach { $0.alpha = 1 }
		}

	}
}
