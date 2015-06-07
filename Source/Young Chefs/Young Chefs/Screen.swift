//
//  Screen.swift
//  Young Chefs
//
//  Julia Bindler
//  Graham Earley
//  Charlie Imhoff
//

import UIKit
import WebKit


/// Screens are responsible for holding an HTML reference which point to Experiment sections.
class Screen {
	
	let htmlURL : NSURL
	var htmlPath : String? {
		return htmlURL.path
	}
	
	init(htmlURL: NSURL) {
		self.htmlURL = htmlURL
	}
	
}