//
//  ScreenView.swift
//  Young Chefs
//
//  Julia Bindler
//  Graham Earley
//  Charlie Imhoff
//

import WebKit
import UIKit

/**
ScreenView is a subclass of WKWebView for rendering and interacting with Screens.

Experiment pages are stored as HTML files, and this class presents them in a subview of the experiment view (in a smaller section).
*/
class ScreenView : WKWebView {
	
	//MARK: - Screen Content
	
	/// The currently displayed screen (read-only)
	private(set) var currentScreen : Screen
	
	/// Inits a new ScreenView with the specified frame, configuration, and screen
	init(frame: CGRect, configuration: WKWebViewConfiguration, screen: Screen) {
		self.currentScreen = screen
		super.init(frame: frame, configuration: configuration)
		self.loadScreen(self.currentScreen)
	}
	
	/// Loads a new screen into this view
	func loadScreen(newScreen: Screen) {
		if let fixedURL = WKWebView.convertURLToBugCompatibleURL(newScreen.htmlURL) {
			let request = NSURLRequest(URL: fixedURL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
			self.loadRequest(request)
			self.currentScreen = newScreen
		} else {
			println("failed to copy web resouce to `temp/www` directory")
		}
	}
	
	//MARK: - JavaSwift
	
	/**
    Runs through the file and calls 'fillKeyedHTMLWithValue()' for each key in the responseKeys dictionary passed into it.
	This basically fills question boxes with previously answered values.
    */
	func fillKeyedHTMLWithValues(keysAndValues : [String:String]) {
		for key in keysAndValues.keys {
			if let value = keysAndValues[key] {
				self.evaluateJavaScriptNoReturn("fillKeyedHTMLWithValue(\"\(key)\",\"\(value)\");")
			}
		}
	}
	
	/// Shorthand for evaluating a JavaScript string with no return value. Prints errors to console.
	func evaluateJavaScriptNoReturn(javascript: String) {
		self.evaluateJavaScript(javascript, completionHandler: { (returnedVal:AnyObject!, error:NSError?) -> Void in
			if error != nil {
				println(error!.description)
			}
		})
	}
	
}