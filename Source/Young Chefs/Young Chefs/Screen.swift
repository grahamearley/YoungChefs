//
//  Screen.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//
//  Julia Bindler
//  Graham Earley
//  Charlie Imhoff
/**

A simple class for holding an HTML screen for an experiment.

*/
//

import UIKit
import WebKit

class Screen {
	
	let htmlURL : NSURL
	var htmlPath : String? {
		return htmlURL.path
	}
	
	init(htmlURL: NSURL) {
		self.htmlURL = htmlURL
	}
	
}