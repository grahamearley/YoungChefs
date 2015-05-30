//
//  Notebook.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//
//  Julia Bindler
//  Graham Earley
//  Charlie Imhoff
/*

The Notebook holds the information (notes and photos) that the student inputs through the Notebook popover.

Not to be confused with NotebookView and NotebookViewController, which handle the display of this object's contents.

*/
//

import UIKit

@objc class Notebook : NSObject, NSCoding {
	
	var scribbleImages : [UIImage]
	var responses : [String: String]
	
	override init() {
		scribbleImages = [UIImage]()
		responses = [String: String]()
		super.init()
	}
	
	//MARK: - Save/Load
	
	private static let imagesKey = "images"
	private static let responsesKey = "key"
	
	func encodeWithCoder(encoder: NSCoder) {
		encoder.encodeObject(self.scribbleImages, forKey: Notebook.imagesKey)
		encoder.encodeObject(self.responses, forKey: Notebook.responsesKey)
	}
	
	required init(coder decoder: NSCoder) {
		self.scribbleImages = decoder.decodeObjectForKey(Notebook.imagesKey) as! [UIImage]
		self.responses = decoder.decodeObjectForKey(Notebook.responsesKey) as! [String: String]
	}
	
}