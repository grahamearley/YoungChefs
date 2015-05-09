//
//  ViewController.swift
//  Imbedded Web Testbed
//
//  Created by Charlie Imhoff on 5/8/15.
//  Copyright (c) 2015 YoungChefs. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController, WKScriptMessageHandler {
	
	@IBOutlet var placeholderViewForWebView : UIView!
	var webView : WKWebView!
	@IBOutlet var boxTouchesLabel : UILabel!
	
	var timesBoxTouched = 0
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		//config the webView with our javaScript message handler
		let webViewConfig = WKWebViewConfiguration()
		webViewConfig.userContentController.addScriptMessageHandler(self, name: "javaSwift")
		self.webView = WKWebView(frame: placeholderViewForWebView.bounds, configuration: webViewConfig)
		
		//load webView content
		if let fileURL = NSBundle.mainBundle().URLForResource("example", withExtension: "html") {
			let request = NSURLRequest(URL: fileURL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
			webView.loadRequest(request)
		}
		
		//replace (cover) our placeholder view with our WKWebView
		self.webView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
		self.webView.frame = self.placeholderViewForWebView.bounds
		self.placeholderViewForWebView.addSubview(webView)

	}
	
	///Called whenever js posts a message to 'javaSwift'
	///Explicitly whenever js runs:
	///		'window.webkit.messageHandlers.javaSwift.postMessage(<message : NSDictionary>)'
	func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
		let sentData = message.body as! NSDictionary
		if let command = sentData["command"] as? NSString {
			if command.isEqualToString("boxtouch") {
				timesBoxTouched++
				let pluralString = timesBoxTouched == 1 ? "" : "s"
				self.boxTouchesLabel.text = "Box was Touched \(timesBoxTouched) time\(pluralString)"
			}
		}
	}

	///Called via a Swift UIButton press, calls a js method via
	///		'evaluateJavaScript(<jsCode : String>, <completionHandler : block>)'
	@IBAction func onChangeDivColorsButton(sender: AnyObject) {
		self.webView.evaluateJavaScript("changeBackgroundColor(\"#000\");", completionHandler: { (returnedVal:AnyObject!, error:NSError?) -> Void in
			println(error?.description ?? "")
		})
	}
}

