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
		var r : CGFloat = 0
		var g : CGFloat = 0
		var b : CGFloat = 0
		var a : CGFloat = 0
		info.backgroundColor.getRed(&r, green: &g, blue: &b, alpha: &a)
		
		infoField.backgroundColor = UIColor(red: r * 0.8, green: g * 0.8, blue: b * 0.8, alpha: 1.0)
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
