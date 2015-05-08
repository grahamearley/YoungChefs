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
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		webView = WKWebView()
		self.view.addSubview(webView)
		
		webView.setTranslatesAutoresizingMaskIntoConstraints(false)
		let viewsDictionary : [NSObject:AnyObject] = ["webView":self.webView, "top":self.topLayoutGuide, "bottom":self.bottomLayoutGuide]
		
		//constraints: middle align, top, leading, bottom margins
		let webViewHorizontalConstraints = NSLayoutConstraint.constraintsWithVisualFormat(
			"H:|-250-[webView]-250-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: viewsDictionary)
		let webViewVerticalConstraints = NSLayoutConstraint.constraintsWithVisualFormat("V:[top]-250-[webView]-250-|", options: NSLayoutFormatOptions.allZeros, metrics: nil, views: viewsDictionary)
		let webViewCenterConstraint = NSLayoutConstraint(item: webView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.view, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
		self.view.addConstraints(webViewHorizontalConstraints)
		self.view.addConstraints(webViewVerticalConstraints)
		self.view.addConstraint(webViewCenterConstraint)
		
		
		let url = NSURL(string: "http://www.google.com")
		let request = NSURLRequest(URL: url!)
		webView.loadRequest(request)
	}
	
	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}


}

