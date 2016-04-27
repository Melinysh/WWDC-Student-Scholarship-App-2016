//
//  CardData.swift
//  Stephen Melinyshyn
//
//  Created by Stephen Melinyshyn on 2016-04-18.
//  Copyright © 2016 Stephen Melinyshyn. All rights reserved.
//

import UIKit

struct CardInfo {
	var imageName : String!
	var info : String!
	var eventName : String
	var backgroundColor : UIColor!
	var textColor : UIColor!
	var id : Int!
	var storyboard : String!
	var extraInfo : [String : AnyObject]!
	init(img: String, detail : String, name : String, bcC : UIColor, tC : UIColor, index : Int, storyboard : String?, extraInfoDict : [String : AnyObject]) {
		imageName = img
		info = detail
		eventName = name
		backgroundColor = bcC
		textColor = tC
		id = index
		self.storyboard = storyboard
		extraInfo = extraInfoDict
	}
}

class CardData: NSObject {
	
	let storyboards : [String?] = [
		"welcome", //welcome
		"me", //me
		"tapz", // tapz
		"rez", //rez
		"marketmesh", // MarketMesh
		"meshwurk", // meshwurk
		"nearbeye", // NearbEYE
		"wwdc", //this app
		"wellaware", // wellaware
		"wattpad" // wattpad
	]
	
	
	let extraStuff : [[String : AnyObject]] = [
		[String : AnyObject](), //welcome
		[String : AnyObject](), //me
		[String : AnyObject](), // tapz
		[String : AnyObject](), //rez
		[String : AnyObject](), // MarketMesh
		[String : AnyObject](), // meshwurk
		[String : AnyObject](), // NearbEYE
		[String : AnyObject](), //this app
		[String : AnyObject](), // wellaware
		[String : AnyObject]() // wattpad
	]
	
	
	
	let backgroundColors : [UIColor] = [
		color(102, g: 25, b: 17), //welcome
		color(245, g: 220, b: 98), //me
		color(168, g: 255, b: 70), // tapz
		color(127, g: 18, b: 135), //rez
		color(255, g: 109, b: 20), // MarketMesh
		color(89, g: 89, b: 89), // meshwurk
		color(65, g: 71, b: 70), // NearbEYE
		color(43, g: 88, b: 142), //this app
		color(30, g: 30, b: 30), // wellaware
		color(250, g: 156, b: 31) // wattpad
	]
	
	let textColors = [
		color(224, g: 224, b: 224), //welcome
		color(10, g: 10, b: 10), //me
		color(19, g: 19, b: 19), // tapz
		color(255, g: 255, b: 255), //rez
		color(240, g: 240, b: 240), // MarketMesh
		color(245, g: 245, b: 245), // meshwurk
		color(224, g: 224, b: 224), // NearbEYE
		color(255, g: 255, b: 255), //this app
		color(32, g: 167, b: 222), // wellaware
		color(254, g: 254, b: 254) // wattpad
	]
	
	let images = [ "me1", "me3" , "tapz", "rez", "marketmesh", "meshwurk", "codefest", "wwdc","wellaware",  /*"me2"*/ "wattpad"]
	
	let eventNames = [
		"Welcome! Tap this card to get started",
		"But first, about me",
		"My first iOS app, Tapz",
		"My first big project: Rez Reader",
		"MarketMesh: A peer-to-peer marketplace app",
		"Meshwurk: An app that connects",
		"NearbEYE: An augmented reality app for Waterloo",
		"My WWDC App",
		"WellAware: A health app",
		"What's Next: Wattpad"]
	
	let descriptions = [
		"Welcome to my WWDC App Submission! I'm a 19 year old Canadian with a passion for computer science. Although I've just completed my first year in Software Engineering at the University of Waterloo, my own curiosity and persistence has driven me to explore and experiment with code over the past few years. Using what I've learned over the past several years, I've taken the last 2 weeks to build this app to inform you about what exciting things I've done on Apple's platform, what I'm working on, and what I will be doing in the future. To dismiss this card, just swipe it away!",
		
		"I was born and raised in Kingston, Ontario. When I was 13, I attended an enriched studies day at Queen's University where I was first introduced to programming. I moved onto small programs and scripts that helped automate tasks in my daily routine. I didn't take any programming classes before starting university this past fall, but I was able to teach myself strong foundational skills. As time has passed, I have moved to more complex software projects that you can read about in the next cards!",
		
		"My first iOS app I developed was called Tapz and I made it in 2013. The idea behind it was simple; a game where you tap to remove bouncing balls, but avoid the bombs. The faster you can remove the balls, the better. This app developed my skills in Core Animation, Autolayout, integration with social services like Facebook and Twitter to share score and basic file I/O operations to keep track of highscores. Tapz was a hit among my friends and I and we frequently competed against eachother for the highest score. Looking back, Tapz is small enough to integrate directly into this app and you are free to play it below. Try to beat a highscore of 4 balls/second!",
		
		"In 2014, I was switching between a couple of different feed reader clients from the App Store and knew that I wasn't satisfied with any of them. It dawned on me that I could build something like this! I knew it would be quite the challenge, but I knew it could be very rewarding. After 5 months of work, Rez Reader launched in the App Store. Rez Reader was downloaded by users around the world, and, most importantly, I was proud of what I accomplished. Rez utilized numerous technologies, such as UIDynamics, Autolayout, Core Data, and social services integration to provide a superior user experience. You can get a closer look by tapping a screenshot below. Eariler this year, I decided to sunset Rez to work on more exciting things that you can read about in the next few cards...",
		
		"In August 2015, I went to my first hackathon called TechRetreat. TechRetreat was an 8 hour long hackthon for highschoolers or recent highschool graduates. At TechRetreat, my team built an iOS app that created a peer-to-peer local market place where goods and services could be sold to nearby devices. One such service I built into the app was the ability to proxy internet connections between iOS devices! This allowed for the selling of one's native data connection to others from within the app. How did we do this? I built upon Apple's Multipeer Connectivity framework to provide the proxing functionality and device communication protocol while my teammates worked on the presentation and UI. MarketMesh won first place for its technical difficulty, creativity, and usefulness. About a month later, MarketMesh was selected for Ycombinator's Office Hours. The team met with Teespring CEO and YC Fellow Evan Stites-Clayton to discuss MarketMesh's market viability. Evan saw the potential in MarketMesh and encouraged us to continue working on it and to contact him again in the future. In the next few months, we plan on filing an application for MarketMesh to my univeristy's own incubator/accelerator, Velocity, for turning it into a real product. You can watch a 50 second demo below.",
		
		"Meshwurk was created by myself and some friends at Hack The North, a 48-hour hackathon in Waterloo last September. The name \"Meshwurk\" was a clever combination of \"mesh\" and \"network\" and not just the sense of mesh metworking, but personal networking. Meshwurk allowed users to seemlessly share contact information to those nearby through a secure and efficent peer-to-peer mesh network. Common use cases of this app could invovle quickly obtaining new friends contact information, or being able to see who in your contacts was nearby. All of this could be done without an internet connection or any backend servers, a real benefit we believe. Building off my experience with Apple's Multipeer Connectivity framework from MarketMesh, I fully implemented the mesh network backend and contact exchange protocol and utlized the new Contacts framework introduced in iOS 9 while my teammates built the UI and our presentation to the judges. Although we were not winners of the hackathon, we impressed our judges and gained more experience with the latest iOS technologies.",

		"After surviving my midterm week (five midterm exams in five days), I took the weekend off with some classmates to participate in the City of Waterloo's first open data hackathon, CodeFest. We developed an elegant augmented reality app called NearbEYE. While using NearbEYE, a user can point their camera in the direction of interest and NearbEYE will beautifully display relevant open data about points of interest in that direction. To be able to do this, I devised a custom algorithm that took in compass and geolocation data and fetched relevant data from our Core Data store. We utilized Core Location and Core Motion for our algorithm, AVCapture APIs for live camera input, Core Data for storing all point of interest data, and Mapkit to provide the walking route to points of interest. The app integrated 8 unique datasets, more than double of any other team. NearbEYE won third place for its \"impressive technical feats\" and I believe pushed the boundaries of the platform for the time period we had.",
		
		"Recently, I've been looking for a new challenge. The WWDC Student Scholarship program is a fantastic opportunity to exercise and learn skills. From the start, I was driven to create a simple, playful user interface. Beautiful stacked cards that dropped down in front of the user was a key idea for me. Behind the scenes, it took a considerable amount of work, dynamically generating the cards and the angles at which they fall (if you reset the card stack, you'll see the cards fall rotated differently each time). It also works on both iPad and iPhone through the use of Autolayout, UIStackViews and smart design. In additon, UIDynamics provide the playful bounce to the cards. The app is entirely written by me; no third party code! It also borrows a few ideas I first developed in Rez Reader, but enhanced significantly. I consider this application a culmination of my best iOS programming to date.",
		
		"WellAware is a current project that I'm parterning with one other person to creare. WellAware is tool to locate and report wellwater conditions in the southern Ontario region. Based off of extensive research and data collected by my partner, we are able to determine areas at risk of water contamination. For this project, I am the sole developer of the iOS application while my partner is responsible for visual design, and data cultivation. For the app, I'm leveraging Core Data for storing all risk data and for geospatial lookups, along with MapKit for setting the lookup location and for proving directions to the nearest wellwater testing drop off location. WellAware is still under construction, but we plan to have it done by the end of the summer with interest from third parties.",
		
		"I'm excited to be working for Wattpad this summer as an iOS Developer Intern! I'll be working on new features, improving functionality, and fixing pesky bugs for the 40 million people who use Wattpad each month. And beyond that? I'll continue exploring the vast field of computer science, tinkering with software, and discovering new technologies. Thanks for taking the time to review my app and I hope you enjoyed it as much as I enjoyed developing it!"]
	
	
	func allCardInfo() -> [CardInfo] {
		var events = [CardInfo]()
		for i in 0 ..< eventNames.count {
			events.append(CardInfo(img: images[i], detail: descriptions[i], name: eventNames[i], bcC: backgroundColors[i], tC: textColors[i], index: i, storyboard: storyboards[i], extraInfoDict: extraStuff[i]))
			
		}
		return Array(events.reverse())
	}
	
}

func color(r : Int, g : Int, b: Int) -> UIColor {
	return UIColor(red: CGFloat(r)/255.0, green:  CGFloat(g)/255.0, blue: CGFloat(b)/255, alpha: 1.0)
}

