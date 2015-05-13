//
//  Screen.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//

import UIKit
import WebKit

class Screen {
	
	let htmlURL : NSURL
	
	init(htmlFileName: String) {
		 self.htmlURL = NSBundle.mainBundle().URLForResource(htmlFileName, withExtension: "html")!
	}
	
}