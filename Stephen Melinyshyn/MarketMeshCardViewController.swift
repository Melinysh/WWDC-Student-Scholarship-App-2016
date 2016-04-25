//
//  MarketMeshCardViewController.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-23.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
import SafariServices

class MarketMeshCardViewController: UIViewController, DetailViewControllable {

	@IBOutlet weak var infoField: UITextView!
	
	@IBAction func loadGithub(sender: AnyObject) {
		let sfVC = SFSafariViewController(URL: NSURL(string: "https://github.com/jgalperin/redolent-octo-waffle")!)
		self.presentViewController(sfVC, animated: true, completion: nil)
	}
	
	@IBAction func playDemo(sender: AnyObject) {
		let path = NSBundle.mainBundle().pathForResource("marketmesh", ofType:"mov")!
		let player = AVPlayer(URL: NSURL(fileURLWithPath: path))
		let playerController = AVPlayerViewController()
		playerController.player = player
		self.presentViewController(playerController, animated: true) {
			player.play()
		}
	}
	
	override func canBecomeFirstResponder() -> Bool {
		return true
	}
	
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func additionalSetup(info: CardInfo) {
		self.becomeFirstResponder()
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
