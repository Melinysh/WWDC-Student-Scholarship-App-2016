//
//  MeCardViewController.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-21.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit
import MapKit
import SafariServices

class MeCardViewController: UIViewController, DetailViewControllable {
	@IBOutlet weak var infoField: UITextView!
	@IBOutlet weak var websiteButton: UIButton!
	@IBOutlet weak var mapView: MKMapView!

	func buttonPressed() {
		let sfVC = SFSafariViewController(url: URL(string: "https://melinysh.me")!)
		self.present(sfVC, animated: true, completion: nil)
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
	
	override func viewDidAppear(_ animated: Bool) {
		self.infoField.setContentOffset(CGPoint.zero, animated: false)
		self.animateViews()

	}
	
	override func canBecomeFirstResponder() -> Bool {
		return true
	}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func additionalSetup(_ info: CardInfo)  {
		self.becomeFirstResponder()
		websiteButton.isEnabled = true
		websiteButton.addTarget(self, action: #selector(buttonPressed), for: UIControlEvents.touchUpInside)
		let zoomLocation = CLLocationCoordinate2D(latitude: 44.2286091, longitude: -76.4837246)
		let viewRegion = MKCoordinateRegionMakeWithDistance(zoomLocation, 2000.344, 2000.344)
		mapView.setRegion(viewRegion, animated: true)
		websiteButton.setTitleColor(UIColor.white(), for: UIControlState())
		websiteButton.backgroundColor = self.view.tintColor
		websiteButton.layer.cornerRadius = 4.0
		websiteButton.layer.masksToBounds = true
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
