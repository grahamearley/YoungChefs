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
		
		let url = NSURL(string: "http://thacker.mathcs.carleton.edu/cs257-f14/imhoffc/noncs/homepage/lists.html")
		let request = NSURLRequest(URL: url!)
		webView.delegate = self
		webView.loadRequest(request)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}
	
	func webViewDidFinishLoad(v: UIWebView) {
	}

}

