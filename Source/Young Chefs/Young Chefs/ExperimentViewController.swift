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
	
	/// Presents the notebook popover
	@IBAction func onNotebookButton(sender: UIButton) {
		let popoverViewController = NotebookViewController(notebook: experiment.notebook)
		popoverViewController.modalPresentationStyle = .Popover
		let popRect = sender.frame
		let popover =  UIPopoverController(contentViewController: popoverViewController)
		popover.popoverContentSize = CGSize(width: 700, height: 500)
		popover.presentPopoverFromRect(popRect, inView: view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
	}
	
	//MARK: JavaSwift
	
	/// Called whenever js posts a message to 'javaSwift'
	/// Explicitly whenever js runs:
	///		'window.webkit.messageHandlers.javaSwift.postMessage(<message : NSDictionary>)'
	func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
		let sentData = message.body as! NSDictionary
		if let command = sentData["command"] as? NSString {
			if command == "contentIsReady" {
				onContentReady()
			}
			if command == "nextButton" {
				onNextScreenButton()
			}
			if command == "backButton" {
				onPreviousScreenButton()
			}
			if command == "bindResponseKey" {
				self.bindResponseKey(sentData)
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
