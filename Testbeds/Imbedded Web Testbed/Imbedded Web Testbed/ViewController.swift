//
//  ViewController.swift
//  Imbedded Web Testbed
//
//  Created by Charlie Imhoff on 5/8/15.
//  Copyright (c) 2015 YoungChefs. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIWebViewDelegate {
	
	@IBOutlet var webView : UIWebView!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		webView.scalesPageToFit = true
		webView.suppressesIncrementalRendering = true
		
		if let fileURL = NSBundle.mainBundle().URLForResource("example", withExtension: "html") {
			let request = NSURLRequest(URL: fileURL, cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData, timeoutInterval: 5)
			webView.delegate = self
			webView.loadRequest(request)
		}
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func webViewDidFinishLoad(v: UIWebView) {
	}

}

