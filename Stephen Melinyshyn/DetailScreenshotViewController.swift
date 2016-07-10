//
//  DetailScreenshotViewController.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-24.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit

class DetailScreenshotViewController: UIViewController {

	@IBOutlet weak var navBar: UINavigationBar!
	@IBOutlet weak var imageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

	@IBAction func goBack(_ sender: AnyObject) {
		self.dismiss(animated: true, completion: nil)
	}
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
