//
//  CardView.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-18.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit

class CardView: UIView {

	@IBOutlet weak var thumbnail: UIImageView!
	@IBOutlet weak var titleLabel: UILabel!
	@IBOutlet weak var stackView: UIStackView!
	
	let cornerRad : CGFloat = 26
	var info : CardInfo!
	
	
	 func setup(_ i : CardInfo) {

		info = i
		self.titleLabel.text = info.eventName
		self.titleLabel.alpha = 1
		self.thumbnail.image = UIImage(named: info.imageName)
		self.thumbnail.alpha = 1
		self.backgroundColor = info.backgroundColor
		self.titleLabel.textColor = info.textColor
		thumbnail.layer.cornerRadius = self.cornerRad
		thumbnail.contentMode = UIViewContentMode.scaleAspectFill
		thumbnail.clipsToBounds = true
		self.translatesAutoresizingMaskIntoConstraints = false

		self.layer.shadowColor = UIColor.black().cgColor
		self.layer.shadowOpacity = 0.1
		self.layer.shadowRadius = 4
		self.layer.shadowOffset = CGSize(width: 3.0, height: 4.0)
		self.layer.drawsAsynchronously = true
		self.layer.cornerRadius = cornerRad
		self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
		
		// prepare for drop animation
		self.alpha = 0
		self.transform = CGAffineTransform(scaleX: 1.35, y: 1.35)
	}
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */
	

	override func layoutSubviews() {
		super.layoutSubviews()
		//self.layer.cornerRadius = cornerRad != nil ? cornerRad : 0
		self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.layer.cornerRadius).cgPath
		// experimental code for just two corner rads, seems to hit performance
		/*	let cornerBezPath = UIBezierPath(roundedRect: self.imageView.bounds, byRoundingCorners: UIRectCorner.TopRight.union(UIRectCorner.TopLeft) , cornerRadii: CGSize(width: 20, height: 20))
		let cornerRadLayer = CAShapeLayer()
		cornerRadLayer.path = cornerBezPath.CGPath
		cornerRadLayer.frame = self.imageView.bounds
		self.imageView.layer.mask = cornerRadLayer*/
		
	}
}
