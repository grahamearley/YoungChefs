//
//  ExperimentViewController.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//
//  Julia Bindler
//  Graham Earley
//  Charlie Imhoff
/*

This class controls the experiment view. It interacts with the experiment's webview screens and their Javascript ("javaSwift"). It also provides navigation controls by letting students move on to the next screen and by presenting the Notebook popover.

*/
//

import UIKit
import WebKit

class ExperimentViewController: UIViewController, WKScriptMessageHandler {
	
	var experiment : Experiment!	//must be set externally before the storyboard presents this view
	var indexInExperiment = 0
	
	@IBOutlet var placeholderViewForWebview : UIView!
	var screenView : ScreenView!
	
	//MARK: Init
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if experiment == nil {
			fatalError("experiment must be set before this view is presented. Use 'prepareForSegue' to pass incoming ExperimentViewController an Experiment before storyboard presentation")
		}
		
		// Configure the screenView with our javaScript message handler and our first screen
		let javaSwiftConfig = WKWebViewConfiguration()
		javaSwiftConfig.userContentController.addScriptMessageHandler(self, name: "javaSwift")
		self.screenView = ScreenView(frame: placeholderViewForWebview.bounds, configuration: javaSwiftConfig, screen: experiment.screens[indexInExperiment])
		
		// Replace (cover and fill) our placeholder view with our WKWebView
		self.screenView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
		self.screenView.frame = self.placeholderViewForWebview.bounds
		self.placeholderViewForWebview.addSubview(screenView)
    }
	
	//MARK: IBActions
	
	///defines the ratio of the screen the notebook should take up when it's displayed
	private let notebookPopoverScreenRatios = (CGFloat(0.8), CGFloat(0.75))
	/// Presents the notebook popover
	@IBAction func onNotebookButton(sender: UIButton) {
		let popoverViewController = NotebookViewController(notebook: experiment.notebook)
		popoverViewController.modalPresentationStyle = .Popover
		let popover =  UIPopoverController(contentViewController: popoverViewController)
		
		//set the size and present it
		let popWidth = self.view.frame.size.width * notebookPopoverScreenRatios.0
		let popHeight = self.view.frame.size.height * notebookPopoverScreenRatios.1
		popover.popoverContentSize = CGSize(width: popWidth, height: popHeight)
		let popRect = sender.frame
		popover.presentPopoverFromRect(popRect, inView: view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
	}
	
	//MARK: JavaSwift
	
	/// Called whenever js posts a message to 'javaSwift'
	/// Explicitly whenever js runs:
	///		'window.webkit.messageHandlers.javaSwift.postMessage(<message : NSDictionary>)'
	func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
		let sentData = message.body as! NSDictionary
		if let commandString = sentData[JavaSwiftConstants.commandKey] as? NSString {
			//parse the command value String into a JSCommand enum value
			if let command = JSCommand(rawValue: commandString) {
				switch command {
				case .NextScreen:
					onNextScreenButton()
				case .PreviousScreen:
					println("goto previous screen")
				default:
					break
				}
			} else {
				println("Err: command string '\(commandString)' not recognized.")
			}
		}
	}
	
	/// Called when the ScreenView has fully loaded the DOM asscociated with the current Screen.
	func onContentReady() {
		//fill in data from 'responseKeys' into the forms on the page
		self.screenView.fillKeyedHTMLWithValues(self.experiment.notebook.responses)
	}
	
	/// Progress to the next screen in the experiment if it exists
	func onNextScreenButton() {
		if indexInExperiment+1 >= self.experiment.screens.count {
			return
		} else {
			self.indexInExperiment++
			self.screenView.loadScreen(self.experiment.screens[self.indexInExperiment])
		}
	}
	
	func onPreviousScreenButton() {
		if indexInExperiment-1 < 0 {
			return
		} else {
			self.indexInExperiment--
			self.screenView.loadScreen(self.experiment.screens[self.indexInExperiment])
		}
	}
	
	///Binds a given response key to an associated value for use later
	func bindResponseKey(key: String, toValue value:String) {
		self.experiment.notebook.responses[key] = value
	}
	///Ease of use, given a javaSwift dictionary, parse it's contents and call 'bindResponseKey:(:)'
	func bindResponseKey(jsDict: NSDictionary) {
		if let key = jsDict["key"] as? String, let value = jsDict["value"] as? String {
			self.bindResponseKey(key, toValue: value)
		}
	}
	
}
