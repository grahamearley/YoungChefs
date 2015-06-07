//
//  Notebook.swift
//  Young Chefs
//
//  Julia Bindler
//  Graham Earley
//  Charlie Imhoff
//

import UIKit

/**
Notebook holds the information that is displayed in the notebook popover (photos, question responses, question headers).

Not to be confused with NotebookView and NotebookViewController, which handle the display of this object's contents.
*/
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
		// try to grab the values from coder requests, else init blank ones
		self.images = decoder.decodeObjectForKey(Notebook.imagesKey) as? [UIImage] ?? [UIImage]()
		self.responsesForQuestionKey = decoder.decodeObjectForKey(Notebook.responsesKey) as? [String: String] ?? [String: String]()
		self.questionHeaderForQuestionKey = decoder.decodeObjectForKey(Notebook.questionHeaderKey) as? [String: String] ?? [String: String]()
		self.keysForQuestionsAnswered = decoder.decodeObjectForKey(Notebook.keysForQuestionsAnsweredKey) as? [String] ?? [String]()
	}
	
}