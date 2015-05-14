//
//  Experiment.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//

import UIKit

class Experiment {
	
	var screens = [Screen]()
	var notebook = Notebook()
	
	///Inits a new Experiment by pulling html files from the main bundle and converting them to screens.
	///
	///Instead of passing in each file reference individually, simply name all html files of one experiment
	///in the following format:
	///		[experimentName]-[order]
	///
	///The initializer will automatically read in all the associated html files in the correct order.
	init(experimentName screensFilePrefix:String) {
		
		//WARNING: Currently, this only searchs in the MainBundle.
		//		which is inconsistant, filenames from the Library directory can be
		//		requested for init from experimentsDirectory.plist/HomeViewController
		
		var reachedEndOfScreens = false
		var screenNumber = 0
		while !reachedEndOfScreens {
			let fileName = screensFilePrefix + "-" + screenNumber.description
			if let htmlURL = NSBundle.mainBundle().URLForResource(fileName, withExtension: "html") {
				let screen = Screen(htmlURL: htmlURL)
				self.screens.append(screen)
			} else {
				if screenNumber != 0 { //in case a non-dev starts numbering at 1 instead of 0
					reachedEndOfScreens = true
				}
			}
			screenNumber++
		}
		
		if screens.count == 0 {
			fatalError("no Screens were found from name: \(screensFilePrefix), check the file names of relevant html")
		}
	}
	
}