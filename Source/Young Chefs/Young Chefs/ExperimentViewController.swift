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
/**

This class controls the experiment view. It interacts with the experiment's webview screens and their Javascript ("javaSwift"). It also provides navigation controls by letting students move on to the next screen and by presenting the Notebook popover.

*/
//

import UIKit
import WebKit

class ExperimentViewController: UIViewController, WKScriptMessageHandler, NotebookDelegate {
	
	var experiment : Experiment!	//must be set externally before the storyboard presents this view
	
	@IBOutlet var placeholderViewForWebview : UIView!
	var screenView : ScreenView!
	
	//MARK: - Init
	
    /**
    When the view loads, we load a web view to display the HTML files of the experiment.
    This web view (screenView) replaces an initial placeholder view.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if experiment == nil {
			fatalError("experiment must be set before this view is presented. Use 'prepareForSegue' to pass incoming ExperimentViewController an Experiment before storyboard presentation")
		}
		
		// Ensure constant web resource files are copied into our temp context
        //  (see WKWebViewTempContextExtension.swift for more explanation)
		var constantWebRes = [NSURL?]()
		constantWebRes.append(NSBundle.mainBundle().URLForResource("styles", withExtension: "css"))
		constantWebRes.append(NSBundle.mainBundle().URLForResource("javaswift", withExtension: "js"))
		constantWebRes.append(NSBundle.mainBundle().URLForResource("jquery-2.1.4", withExtension: "js"))
		constantWebRes.append(NSBundle.mainBundle().URLForResource("fastclick", withExtension: "js"))
		WKWebView.copyResourcesIntoTempContext(constantWebRes)
		
		// Configure the screenView with our javaScript message handler and our first screen
		let javaSwiftConfig = WKWebViewConfiguration()
		javaSwiftConfig.userContentController.addScriptMessageHandler(self, name: "javaSwift")
		self.screenView = ScreenView(frame: placeholderViewForWebview.bounds, configuration: javaSwiftConfig, screen: experiment.currentScreen)
		
		// Replace (cover and fill) our placeholder view with our WKWebView
		self.screenView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
		self.screenView.frame = self.placeholderViewForWebview.bounds
		self.placeholderViewForWebview.addSubview(screenView)
    }
	
	//MARK: - IBActions
	
	/// The ratio of the space that the notebook should take up when it's displayed on screen
	private let notebookPopoverScreenRatios = (CGFloat(0.8), CGFloat(0.75))
	
    /// Present the notebook popover
	@IBAction func onNotebookButton(sender: UIButton) {
		let device = UIDevice.currentDevice().userInterfaceIdiom
		if device == .Pad {
			//device is iPad, present notebook as a popover
			let popoverViewController = NotebookViewController(notebook: experiment.notebook)
			popoverViewController.delegate = self
			popoverViewController.modalPresentationStyle = .Popover
			let popover =  UIPopoverController(contentViewController: popoverViewController)
			
			//set the size and present it
			let popWidth = self.view.frame.size.width * notebookPopoverScreenRatios.0
			let popHeight = self.view.frame.size.height * notebookPopoverScreenRatios.1
			popover.popoverContentSize = CGSize(width: popWidth, height: popHeight)
			let popRect = sender.frame
			popover.presentPopoverFromRect(popRect, inView: view, permittedArrowDirections: UIPopoverArrowDirection.Any, animated: true)
			
			//set the opacity a tad lower for some nice transparency
			popoverViewController.view.backgroundColor = UIColor(white: 1, alpha: 0.20)
			
		} else if device == .Phone {
			//device is iPhone or iPod Touch, present notebook modally
			let modalViewController = NotebookViewController(notebook: experiment.notebook)
			modalViewController.delegate = self
			modalViewController.modalPresentationStyle = .CurrentContext
			modalViewController.modalTransitionStyle = .CoverVertical
			self.presentViewController(modalViewController, animated: true, completion: nil)
			return
		}
	}
	
	//MARK: - Experiment Interaction
	
    /// Called whenever Notebook is edited, should not be used for saving to disk
	func notebookContentDidChange(aNotebook: Notebook) {
		// Do not respond
	}
	
	/// Used as a callback to save contents
	func notebookViewControllerWillDismiss(aNotebook: Notebook) {
		self.experiment.asyncSaveToFile()
	}
	
	/// Progress to the next screen in the experiment if it exists
	func nextScreen() {
		if experiment.progressIndex+1 >= self.experiment.screens.count {
			// Cannot go forward
            return
		} else {
			experiment.progressIndex++
			self.screenView.loadScreen(self.experiment.currentScreen)
		}
		experiment.asyncSaveToFile()
	}
	
	///Progress to the previous screen in the experiment if it exists
	func previousScreen() {
		if experiment.progressIndex-1 < 0 {
			// Cannot go backward
            return
		} else {
			experiment.progressIndex--
			self.screenView.loadScreen(self.experiment.currentScreen)
		}
		experiment.asyncSaveToFile()
	}
	
	/// Binds a given response key to an associated value for use later
	func bindResponseKey(key: String, toValue value:String) {
        self.experiment.notebook.responsesForQuestionKey[key] = value
        
        // If the question key hasn't already been stored AND the key has a corresponding question header (which it should, but we're covering edge cases!), record that this question has been answered
        if !contains(self.experiment.notebook.keysForQuestionsAnswered, key) && contains(self.experiment.notebook.questionHeaderForQuestionKey.keys.array, key) {
            self.experiment.notebook.keysForQuestionsAnswered.append(key)
        }
	}
	
	//MARK: - JavaSwift
	
	/** 
    Called whenever js posts a message to 'javaSwift'.
    Explicitly whenever js runs:
    'window.webkit.messageHandlers.javaSwift.postMessage(<message : NSDictionary>)'
    */
	func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
		let sentData = message.body as! NSDictionary
		if let commandString = sentData[JavaSwiftConstants.commandKey] as? NSString {
			// Parse the command value String into a JSCommand enum value
			if let command = JSCommand(rawValue: commandString) {
				switch command {
				case .NextScreen:
					nextScreen()
				case .PreviousScreen:
					previousScreen()
				case .ContentReadyNotification:
					onContentReady()
				case .BindResponseKey:
					self.bindResponseKey(sentData)
				}
			} else {
				println("Err: command string '\(commandString)' not recognized.")
			}
		}
	}
	
	/**
    Called when the ScreenView has fully loaded the DOM asscociated with the current Screen.
    This function fills in the user's data from 'responseKeys' into the forms on the page.
    */
	func onContentReady() {
		self.screenView.fillKeyedHTMLWithValues(self.experiment.notebook.responsesForQuestionKey)
	}
	
	/// Helper function: given a javaSwift dictionary, parse it's contents and call 'bindResponseKey:(:)'
	func bindResponseKey(jsDict: NSDictionary) {
		if let key = jsDict["key"] as? String, let value = jsDict["value"] as? String {
			self.bindResponseKey(key, toValue: value)
		}
	}
}
