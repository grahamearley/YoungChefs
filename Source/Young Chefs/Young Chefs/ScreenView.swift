//
//  ScreenView.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//
//  Julia Bindler
//  Graham Earley
//  Charlie Imhoff
/*

A subclass of WKWebView for rendering and interacting with Screens.

Experiment pages are stored as HTML files, and this class presents them in a subview of the experiment view (in a smaller section).

*/
//

import WebKit
import UIKit

class ScreenView : WKWebView {
	
	/// The currently displayed screen
	/// (read-only)
	private(set) var currentScreen : Screen
	
	/// Inits a new ScreenView with the specified frame, configuration, and screen
	init(frame: CGRect, configuration: WKWebViewConfiguration, screen: Screen) {
		self.currentScreen = screen
		super.init(frame: frame, configuration: configuration)
		self.loadScreen(self.currentScreen)
	}
	
	/// Loads a new screen into this view
	func loadScreen(newScreen: Screen) {
		let request = NSURLRequest(URL: newScreen.htmlURL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
		self.loadRequest(request)
		self.currentScreen = newScreen
	}
	
	///Runs through the file and calls 'fillKeyedHTMLWithValue()' for each key in the responseKeys dictionary passed into it.
	///This basically fills question boxes with previously answered values (such a situation exists on say,
	func fillKeyedHTMLWithValues(keysAndValues : [String:String]) {
		for key in keysAndValues.keys {
			if let value = keysAndValues[key] {
				println("fillKeyedHTMLWithValue(\"\(key)\",\"\(value)\");")
				self.evaluateJavaScriptNoReturn("fillKeyedHTMLWithValue('\(key)','\(value)');")
			}
		}
	}
	
	/// Shorthand for evaluating a JavaScript string with no return value.
	/// Prints errors to console.
	func evaluateJavaScriptNoReturn(javascript: String) {
		self.evaluateJavaScript(javascript, completionHandler: { (returnedVal:AnyObject!, error:NSError?) -> Void in
			if error != nil {
				println(error!.description)
			}
		})
	}
	
}