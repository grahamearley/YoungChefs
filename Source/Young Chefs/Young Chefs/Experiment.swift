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
/**

This class initializes a new experiment by pulling html files from the main bundle and converting them into screens.

All resource references are eventually copied to the temp/www context, so searching is not an option.
All required resources must be defined in the Experiment's manifest .plist file.

*/
//

import UIKit
import WebKit
import Dispatch

@objc class Experiment : NSObject, NSCoding {
	
	//MARK: - Fields
	
	var name : String
	var notebook : Notebook
	var screens = [Screen]()	//synthesized
	
	/** 
    Keeps track of where the user is in the experiment.
	Stored here as aposed to in the ViewController because the progress
	in the experiment should be persistent across launches
    */
	var progressIndex : Int
	
	/// Easy access to the current Screen
	var currentScreen : Screen {
		return self.screens[progressIndex]
	}
	
	// MARK: - Mixed Init
	
	/**
    Inits an experiment with progress from a file if a progress file exists.
	Otherwise, it inits a fresh experiment via vanilla/designated init.

    In almost all cases, use this factory method to load new Experiments.
    
    :returns: An experiment object.
    */
	static func experiment(experimentName: String) -> Experiment {
		let fileName = "\(experimentName).chef"
		let directories = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.AllDomainsMask)
		if let selectedDirectory = directories[0] as? NSURL {
			if let filePath = selectedDirectory.URLByAppendingPathComponent(fileName).path {
				if let loadedExperiment = NSKeyedUnarchiver.unarchiveObjectWithFile(filePath) as? Experiment {
					return loadedExperiment
				}
			}
		}
		
		// Else: return a fresh one
		return Experiment(experimentName: experimentName)
	}
	
	//MARK: - Designated Init
	
	/**
    Initializes an Experiment with the name *without* pulling in
	data from a previous session.
    */
	private init(experimentName:String) {
		self.name = experimentName
		self.notebook = Notebook()
		self.progressIndex = 0
		super.init()
		self.loadResourcesFromManifest(manifestName: experimentName)
	}
	
	/// Loads in all resources from the given experiment manifest into the current experiment
	func loadResourcesFromManifest(#manifestName: String) {
		let manifestURL = NSBundle.mainBundle().URLForResource(manifestName, withExtension: "plist")!
		let manifest = NSDictionary(contentsOfURL: manifestURL)! as! Dictionary<String,AnyObject>
		
		// Prepare screens (copying to temp/www context is done later)
		if let screens = manifest["Screens"] as? [String] {
			for screenString in screens {
				if let url = NSBundle.mainBundle().URLForResource(screenString, withExtension: "html") {
					self.screens.append(Screen(htmlURL: url))
				}
			}
		}
		
		// Prepare additional resources (copy to temp/www context is done now)
		if let additionalResources = manifest["AdditionalResources"] as? [String] {
			var resURLs = [NSURL?]()
			for res in additionalResources {
				let fileName = res.stringByDeletingPathExtension
				let fileType = res.pathExtension
				
				let url = NSBundle.mainBundle().URLForResource(fileName, withExtension: fileType)
				resURLs.append(url)
			}
			WKWebView.copyResourcesIntoTempContext(resURLs)
		}
        
        /** 
        Load the question headers for questions that the experiment will ask.
        
            e.g. for a question that asks "What is your hypothesis?" from a
                 form with id "question_Hypothesis", this dictionary might
                 map "question_Hypothesis" to "Hypothesis"
        */
        if let questions = manifest["Questions"] as? [String: String] {
            self.notebook.questionHeaderForQuestionKey = questions
        }
	}
	
	//MARK: - Save/Load
	
	// Keys for encoders...
	private static let nameKey = "name"
	private static let notebookKey = "notebook"
	private static let progressIndexKey = "progressIndex"
	
	/// Encodes a coder with this Experiment's name, notebook, and progressIndex
	func encodeWithCoder(encoder: NSCoder) {
		encoder.encodeObject(self.name, forKey: Experiment.nameKey)
		encoder.encodeObject(self.notebook, forKey: Experiment.notebookKey)
		encoder.encodeObject(self.progressIndex, forKey: Experiment.progressIndexKey)
	}
	
	/// Decodes an Experiment with stored information, and synthesizes the [Screen] array
	required init(coder decoder: NSCoder) {
		self.name = decoder.decodeObjectForKey(Experiment.nameKey) as! String
		self.notebook = decoder.decodeObjectForKey(Experiment.notebookKey) as? Notebook ?? Notebook()	//try to grab the value from coder, else init a fresh one
		self.progressIndex = decoder.decodeObjectForKey(Experiment.progressIndexKey) as? Int ?? 0
		
		super.init()
		self.loadResourcesFromManifest(manifestName: self.name)
	}
	
	/** 
    Saves the object to a unique file inside the app Documents directory.
	Use `asyncSaveToFile` in almost all cases to preserve speed.
    */
	func saveToFile() {
		let fileName = "\(self.name).chef"
		let directories = NSFileManager.defaultManager().URLsForDirectory(NSSearchPathDirectory.DocumentDirectory, inDomains: NSSearchPathDomainMask.AllDomainsMask)
		if let selectedDirectory = directories[0] as? NSURL {
			if let filePath = selectedDirectory.URLByAppendingPathComponent(fileName).path {
				NSKeyedArchiver.archiveRootObject(self, toFile: filePath)
			}
		}
	}
	
	var currentlySavingAsync = false	// used as a blocker for multiple save calls at once
	
    /// Saves the object to a unique file inside the app Documents directory asyncronously.
	func asyncSaveToFile() {
		if self.currentlySavingAsync {
			return
		} else {
			self.currentlySavingAsync = true
			dispatch_async(dispatch_get_global_queue(QOS_CLASS_UTILITY, 0)) {
				self.saveToFile()				//do the save... (this call is synced to this task)
				self.currentlySavingAsync = false	//allow upcoming saves
			}
		}
	}
	
}