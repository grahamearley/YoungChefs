//
//  Notebook.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//

import UIKit

///The model for storing notebook data associated with an Experiment
///
///Not to be confused with NotebookView and NotebookViewController, which handle the display
///of this object's contents.
class Notebook {
	
	var scribbleText : String?
	var scribbleImages = [UIImage]()
	
}