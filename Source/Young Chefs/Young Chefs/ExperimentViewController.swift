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
	
	@IBOutlet var placeholderViewForWebview : UIView!
	var webView : WKWebView!
	
	//MARK: Init
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if experiment == nil {
			fatalError("experiment must be set before this view is presented.\nUse 'prepareForSegue' to pass incoming ExperimentViewController an Experiment before storyboard presentation")
		}
		
		//config the webView with our javaScript message handler
		let webViewConfig = WKWebViewConfiguration()
		webViewConfig.userContentController.addScriptMessageHandler(self, name: "javaSwift")
		self.webView = WKWebView(frame: placeholderViewForWebview.bounds, configuration: webViewConfig)
		
		//load webView content
		if let fileURL = NSBundle.mainBundle().URLForResource("example", withExtension: "html") {
			let request = NSURLRequest(URL: fileURL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
			webView.loadRequest(request)
		}
		
		//replace (cover and fill) our placeholder view with our WKWebView
		self.webView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
		self.webView.frame = self.placeholderViewForWebview.bounds
		self.placeholderViewForWebview.addSubview(webView)
    }
	
	//MARK: IBActions
	
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
				println("next")
			}
			if command == "boxtouch" {
				self.evaluateJavaScriptNoReturn("changeBackgroundColor('#000');")
			}
		}
	}
	
	///Handy function for running javascript and not worrying about a return value.
	///Will still print the error if there was one.
	private func evaluateJavaScriptNoReturn(javascript: String) {
		self.webView.evaluateJavaScript(javascript, completionHandler: { (returnedVal:AnyObject!, error:NSError?) -> Void in
			println(error?.description ?? "")
		})
	}
	
}
