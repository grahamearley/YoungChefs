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
	var responsesForQuestionKey : [String: String]
    var questionTextForQuestionKey : [String: String]
    var keysForQuestionsAnswered : [String]
	
	override init() {
		scribbleImages = [UIImage]()
		responsesForQuestionKey = [String: String]()
        questionTextForQuestionKey = [String: String]()
        keysForQuestionsAnswered = [String]()
		super.init()
	}
	
	//MARK: - Save/Load
	
	private static let imagesKey = "images"
	private static let responsesKey = "responses"
    private static let questionTextKey = "questions"
    private static let keysForQuestionsAnsweredKey = "keys"
	
	func encodeWithCoder(encoder: NSCoder) {
		encoder.encodeObject(self.scribbleImages, forKey: Notebook.imagesKey)
		encoder.encodeObject(self.responsesForQuestionKey, forKey: Notebook.responsesKey)
        encoder.encodeObject(self.questionTextForQuestionKey, forKey: Notebook.questionTextKey)
        encoder.encodeObject(self.keysForQuestionsAnswered, forKey: Notebook.keysForQuestionsAnsweredKey)
	}
	
	required init(coder decoder: NSCoder) {
		self.scribbleImages = decoder.decodeObjectForKey(Notebook.imagesKey) as! [UIImage]
		self.responsesForQuestionKey = decoder.decodeObjectForKey(Notebook.responsesKey) as! [String: String]
        self.questionTextForQuestionKey = decoder.decodeObjectForKey(Notebook.questionTextKey) as! [String: String]
        self.keysForQuestionsAnswered = decoder.decodeObjectForKey(Notebook.keysForQuestionsAnsweredKey) as! [String]
	}
	
}