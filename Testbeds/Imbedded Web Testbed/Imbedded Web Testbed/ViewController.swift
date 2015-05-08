//
//  ViewController.swift
//  Imbedded Web Testbed
//
//  Created by Charlie Imhoff on 5/8/15.
//  Copyright (c) 2015 YoungChefs. All rights reserved.
//

import UIKit
import WebKit

class ViewController: UIViewController {

	var webView : WKWebView!
	
	override func loadView() {
		super.loadView()
		
		webView = WKWebView()
		//constraints: middle align, top, leading, bottom margins
		
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		let url = NSURL(string: "http://www.google.com")
		let request = NSURLRequest(URL: url!)
		webView.loadRequest(request)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

