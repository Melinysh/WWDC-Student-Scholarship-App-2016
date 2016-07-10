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
	
	@IBOutlet weak var teamPhoto: UIImageView!
	@IBOutlet weak var demoButton: UIButton!
	@IBOutlet weak var githubButton: UIButton!
	@IBAction func loadGithub(_ sender: AnyObject) {
		let sfVC = SFSafariViewController(url: URL(string: "https://github.com/jgalperin/redolent-octo-waffle")!)
		self.present(sfVC, animated: true, completion: nil)
	}
	
	@IBAction func playDemo(_ sender: AnyObject) {
		do {
			try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
			try AVAudioSession.sharedInstance().setActive(true)
		} catch {
			print("CAUGHT ERROR: \(error)")
			
		}
		let path = Bundle.main.pathForResource("marketmesh", ofType:"mov")!
		let player = AVPlayer(url: URL(fileURLWithPath: path))
		let playerController = AVPlayerViewController()
		playerController.player = player
		self.present(playerController, animated: true) {
			player.play()
		}
	}
	
	override func canBecomeFirstResponder() -> Bool {
		return true
	}
	
	override func viewDidAppear(_ animated: Bool) {
		self.animateViews()
		self.infoField.setContentOffset(CGPoint.zero, animated: false)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
	
	func additionalSetup(_ info: CardInfo) {
		self.becomeFirstResponder()
		demoButton.setTitleColor(UIColor.white(), for: UIControlState())
		demoButton.backgroundColor = self.view.tintColor
		demoButton.layer.cornerRadius = 4.0
		demoButton.layer.masksToBounds = true
		
		githubButton.setTitleColor(UIColor.white(), for: UIControlState())
		githubButton.backgroundColor = self.view.tintColor
		githubButton.layer.cornerRadius = 4.0
		githubButton.layer.masksToBounds = true
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
