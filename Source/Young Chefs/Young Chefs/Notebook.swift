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
/**

The Notebook holds the information that is displayed in the notebook popover (photos, question responses, question headers).
The notebook state is stored so that the student doesn't lose notes or responses after leaving the experiment.

Not to be confused with NotebookView and NotebookViewController, which handle the display of this object's contents.

*/
//

import UIKit

@objc class Notebook : NSObject, NSCoding {
	
	var images : [UIImage]
	var responsesForQuestionKey : [String: String]
    var questionHeaderForQuestionKey : [String: String]
    var keysForQuestionsAnswered : [String]
	
	override init() {
		images = [UIImage]()
		responsesForQuestionKey = [String: String]()
        questionHeaderForQuestionKey = [String: String]()
        keysForQuestionsAnswered = [String]()
		super.init()
	}
	
	//MARK: - Save/Load
	
	private static let imagesKey = "images"
	private static let responsesKey = "responses"
    private static let questionHeaderKey = "questionHeaders"
    private static let keysForQuestionsAnsweredKey = "keys"
	
	func encodeWithCoder(encoder: NSCoder) {
		encoder.encodeObject(self.images, forKey: Notebook.imagesKey)
		encoder.encodeObject(self.responsesForQuestionKey, forKey: Notebook.responsesKey)
        encoder.encodeObject(self.questionHeaderForQuestionKey, forKey: Notebook.questionHeaderKey)
        encoder.encodeObject(self.keysForQuestionsAnswered, forKey: Notebook.keysForQuestionsAnsweredKey)
	}
	
	required init(coder decoder: NSCoder) {
		self.images = decoder.decodeObjectForKey(Notebook.imagesKey) as! [UIImage]
		self.responsesForQuestionKey = decoder.decodeObjectForKey(Notebook.responsesKey) as! [String: String]
        self.questionHeaderForQuestionKey = decoder.decodeObjectForKey(Notebook.questionHeaderKey) as! [String: String]
        self.keysForQuestionsAnswered = decoder.decodeObjectForKey(Notebook.keysForQuestionsAnsweredKey) as! [String]
	}
	
}