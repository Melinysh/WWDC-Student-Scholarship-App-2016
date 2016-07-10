//
//  3DTouchExtension.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-26.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit

extension ViewController : UIViewControllerPreviewingDelegate {
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, viewControllerForLocation location: CGPoint) -> UIViewController? {
		guard let topCard = view.subviews.last as? CardView else { return nil }
		guard let viewController = self.storyboard?.instantiateViewController(withIdentifier: "peekPreview") as? PreviewViewController else { return nil }
		
		viewController.view.backgroundColor = topCard.backgroundColor
		let bgC = topCard.backgroundColor!.cgColor.components
		viewController.textField.backgroundColor = UIColor(red: (bgC?[0])! * 0.8, green: (bgC?[1])! * 0.8, blue: (bgC?[2])! * 0.8, alpha: 1)
		viewController.textField.text = topCard.info.info
		viewController.textField.textColor = topCard.info.textColor
		viewController.textField.layer.cornerRadius = 5
		viewController.textField.isEditable = false
		viewController.preferredContentSize = CGSize(width: topCard.frame.width/2, height: topCard.frame.height/2)
		
		return viewController
	}
	
	func previewingContext(_ previewingContext: UIViewControllerPreviewing, commit viewControllerToCommit: UIViewController) {
		didTapCard(nil)
	}
}
