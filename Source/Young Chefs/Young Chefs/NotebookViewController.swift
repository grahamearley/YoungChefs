//
//  NotebookViewController.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//

import UIKit

class NotebookViewController: UIViewController {

	@IBOutlet weak var editText : UITextView!

	override func viewDidLoad() {
		super.viewDidLoad()

		editText.text = "Add in your notes here!"
	}
	
}
