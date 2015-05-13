//
//  NotebookViewController.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//

import UIKit

class NotebookViewController: UIViewController, UITextViewDelegate {

	var notebook: Notebook
	
	@IBOutlet weak var editText : UITextView!
	
	init(notebook: Notebook) {
		self.notebook = notebook
		super.init(nibName: "NotebookView", bundle: nil)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("the funky fresh 'init(coder:)' has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()

		editText.text = notebook.scribbleText
		editText.delegate = self
	}
	
	//MARK: UITextView Delegate
	
	func textViewDidChange(textView: UITextView) {
		self.notebook.scribbleText = editText.text
	}
}
