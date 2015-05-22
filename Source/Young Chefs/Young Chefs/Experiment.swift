//
//  Experiment.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//
//  Julia Bindler
//  Graham Earley
//  Charlie Imhoff
/*

This class initializes a new experiment by pulling html files from the main bundle and converting them into screens.

File references are not passed in individually, but rather all html files are named with the following convention:
        [experimentName]-[order]
        e.g. ChocolateExperiment-0.html (for the first screen in the Chocolate Experiment)
The initializer will automatically read in all the associated html files in the correct order.

*/
//

import UIKit

@objc class Experiment : NSObject, NSCoding {
	
	//MARK: - Fields
	
	var name : String
	var notebook : Notebook
	var screens : [Screen]	//synthesized
	
	///Keeps track of where the user is in the experiment,
	///stored here as aposed to in the ViewController because the progress
	///in the experiment should be persistant across launches
	var progressIndex : Int
	
	///Easy access to the current Screen
	var currentScreen : Screen {
		return self.screens[progressIndex]
	}
	
	//MARK: - Mixed Init
	
	///Inits an experiment with progress from a file if a progress file exists.
	///else inits a fresh one via vanilla/designated init.
	///
	///In almost all cases, use this factory method to load new Experiments
	static func experiment(experimentName: String) -> Experiment {
		let fileName = "\(experimentName).chef"
		let directories = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.AllDomainsMask)
		if let selectedDirectory = directories[0] as? NSURL {
			if let filePath = selectedDirectory.URLByAppendingPathComponent(fileName).path {
				if let loadedExperiment = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? Experiment {
					println("loading experiment in progress from file")
					return loadedExperiment
				}
			}
		}
		
		//else return a fresh one
		println("no progress on this experiment found, starting fresh")
		return Experiment(experimentName: experimentName)
	}
	
	//MARK: - Designated Init
	
	///Initializes an Experiment with the name *without* pulling in
	///data from a previous session.
	private init(experimentName:String) {
		self.name = experimentName
		self.notebook = Notebook()
		self.screens = Experiment.getScreensForExperimentName(self.name)
		self.progressIndex = 0
	}
	
	///Returns a list of Screens for the given experiment
	private static func getScreensForExperimentName(prefix: String) -> [Screen] {
		/*
		WARNING: Currently, this only searchs in the MainBundle, which is inconsistent. Filenames from the Library directory can be requested for init from experimentsDirectory.plist/HomeViewController
		*/
		var screens = [Screen]()
		
		var reachedEndOfScreens = false
		var screenNumber = 0
		while !reachedEndOfScreens {
			let fileName = prefix + "-" + screenNumber.description
			if let htmlURL = NSBundle.mainBundle().URLForResource(fileName, withExtension: "html") {
				let screen = Screen(htmlURL: htmlURL)
				screens.append(screen)
			} else {
				if screenNumber != 0 { //in case a non-dev starts numbering at 1 instead of 0
					reachedEndOfScreens = true
				}
			}
			screenNumber++
		}
		
		if screens.count == 0 {
			fatalError("no Screens were found from name: \(prefix), check the file names of relevant html")
		}
		
		return screens
	}
	
	//MARK: - Save/Load
	
	//Keys for encoders...
	private static let nameKey = "name"
	private static let notebookKey = "notebook"
	private static let progressIndexKey = "progressIndex"
	
	///Encodes a coder with this Experiment's name, notebook, and progressIndex
	func encodeWithCoder(encoder: NSCoder) {
		encoder.encodeObject(self.name, forKey: Experiment.nameKey)
		encoder.encodeObject(self.notebook, forKey: Experiment.notebookKey)
		encoder.encodeObject(self.progressIndex, forKey: Experiment.progressIndexKey)
	}
	
	///Unencodes an Experiment with stored information, and synthesizes the [Screen] array
	required init(coder decoder: NSCoder) {
		self.name = decoder.decodeObjectForKey(Experiment.nameKey) as! String
		self.notebook = decoder.decodeObjectForKey(Experiment.notebookKey) as! Notebook
		self.screens = Experiment.getScreensForExperimentName(self.name)
		self.progressIndex = decoder.decodeObjectForKey(Experiment.progressIndexKey) as! Int
	}
	
	///Saves the object to a unique file inside the app Documents directory.
	///Returns a Bool indicating its success.
	func saveToFile() -> Bool {
		let fileName = "\(self.name).chef"
		let directories = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.AllDomainsMask)
		if let selectedDirectory = directories[0] as? NSURL {
			if let filePath = selectedDirectory.URLByAppendingPathComponent(fileName).path {
				return NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
			}
		}
		return false
	}
	
}