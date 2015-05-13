//
//  ExperimentViewController.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
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
		
		//config the screenView with our javaScript message handler and our first screen
		let javaSwiftConfig = WKWebViewConfiguration()
		javaSwiftConfig.userContentController.addScriptMessageHandler(self, name: "javaSwift")
		self.screenView = ScreenView(frame: placeholderViewForWebview.bounds, configuration: javaSwiftConfig, screen: experiment.screens[indexInExperiment])
		
		//replace (cover and fill) our placeholder view with our WKWebView
		self.screenView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
		self.screenView.frame = self.placeholderViewForWebview.bounds
		self.placeholderViewForWebview.addSubview(screenView)
    }
	
	//MARK: IBActions
	
	///Presents a popup with the Notebook modually
	@IBAction func onNotebookButton(sender: UIButton) {
		let popoverViewController = NotebookViewController(nibName: "NotebookView", bundle: nil)
		popoverViewController.modalPresentationStyle = .Popover
		let popRect = sender.frame
		let popover =  UIPopoverController(contentViewController: popoverViewController)
		popover.popoverContentSize = CGSize(width: 700, height: 500)
		popover.presentPopoverFromRect(popRect, inView: view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
	}
	
	//MARK: JavaSwift
	
	///Called whenever js posts a message to 'javaSwift'
	///Explicitly whenever js runs:
	///		'window.webkit.messageHandlers.javaSwift.postMessage(<message : NSDictionary>)'
	func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
		let sentData = message.body as! NSDictionary
		if let command = sentData["command"] as? NSString {
			if command == "nextbutton" {
				onNextScreenButton()
			}
			if command == "boxtouch" {
				screenView.evaluateJavaScriptNoReturn("changeBackgroundColor('#000');")
			}
		}
	}
	
	///Progress to the next screen in the experiment if it exists
	func onNextScreenButton() {
		self.indexInExperiment++
		if indexInExperiment >= self.experiment.screens.count {
			return
		} else {
			self.screenView.loadScreen(self.experiment.screens[self.indexInExperiment])
		}
	}
	
	
}
