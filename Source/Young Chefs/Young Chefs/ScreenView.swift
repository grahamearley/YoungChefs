//
//  ScreenView.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//

import WebKit
import UIKit

///Subclass of WKWebView for rendering and interacting with Screens
class ScreenView : WKWebView {
	
	private(set) var currentScreen : Screen		//read-only
	
	init(frame: CGRect, configuration: WKWebViewConfiguration, firstScreen: Screen) {
		self.currentScreen = firstScreen
		super.init(frame: frame, configuration: configuration)
		self.loadScreen(self.currentScreen)
	}
	
	///Loads a new screen into this view
	func loadScreen(newScreen: Screen) {
		let request = NSURLRequest(URL: newScreen.htmlURL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
		self.loadRequest(request)
		self.currentScreen = newScreen
	}
	
	///Shorthand for evaluating a JavaScript string with no return value.
	///Prints errors to console.
	func evaluateJavaScriptNoReturn(javascript: String) {
		self.evaluateJavaScript(javascript, completionHandler: { (returnedVal:AnyObject!, error:NSError?) -> Void in
			println(error?.description ?? "")
		})
	}
	
}