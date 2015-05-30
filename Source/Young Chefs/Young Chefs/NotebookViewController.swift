//
//  NotebookViewController.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//
//  Julia Bindler
//  Graham Earley
//  Charlie Imhoff
/*

This class allows the student to take notes and/or take a picture (or load from gallery, if there is no camera). It also presents the student's photos in a CollectionView.

Notebook data is stored in the Notebook class.

*/
//

import UIKit

protocol NotebookDelegate {
	
	func notebookContentDidChange(aNotebook: Notebook)
	
	func notebookViewControllerWillDismiss(aNotebook: Notebook)
}

class NotebookViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let RESPONSE_TABLE_HEADER_HEIGHT = CGFloat(50)
    let RESPONSE_TABLE_INDENTATION_LEVEL = 2

	var notebook: Notebook
    var imageSourceType: UIImagePickerControllerSourceType
	var delegate: NotebookDelegate?
    
    var keysForQuestionsAnswered : [String]
	
    @IBOutlet weak var responseTable: UITableView!
    @IBOutlet weak var notebookPhotoCollectionView: UICollectionView!
    @IBOutlet weak var fullscreenImageView: UIImageView!
    
    // TEST:
    var questionTextForQuestionKeys: [String : String] = ["question_observations":"What observations did you make?", "question_compareCookies":"How did your second cookie compare to the first? And this is a loooong question!!", "question_Hypothesis":"What hypothesis did you form about all these 🍪s?", "question_dependentVariable":"What is your dependent variable?"]
    
    var responsesForQuestionKeys: [String : String] = ["question_observations":"I observed all sorts of stuff and yay I love cookies wow", "question_compareCookies":"Cookies are comparable, and they are delicious", "question_Hypothesis":"I think cookies are good because I like them", "question_dependentVariable":"I depend on cookies to live"]
	
	init(notebook: Notebook) {
		self.notebook = notebook
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            // Users without a camera will only be able to add from their photo library.
            self.imageSourceType = .PhotoLibrary
        } else {
            self.imageSourceType = .Camera
        }
        
        keysForQuestionsAnswered = ["question_observations", "question_compareCookies", "question_dependentVariable"]
        
		super.init(nibName: "NotebookView", bundle: nil)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("the funky fresh 'init(coder:)' has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
        
        // This image view will be revealed only when the student taps a picture to enlarge it:
        self.fullscreenImageView.alpha = 0.0
        let recognizer = UITapGestureRecognizer(target: self, action: Selector("hideFullScreenView:"))
        recognizer.numberOfTapsRequired = 1
        self.fullscreenImageView.addGestureRecognizer(recognizer)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        layout.itemSize = NotebookPhotoCollectionViewCell.defaultSize
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 0
        
        notebookPhotoCollectionView.collectionViewLayout = layout
        notebookPhotoCollectionView.registerNib(UINib(nibName: NotebookPhotoCollectionViewCell.xibName, bundle: nil), forCellWithReuseIdentifier: NotebookPhotoCollectionViewCell.REUSE_ID)
        notebookPhotoCollectionView.delegate = self
        
        // Table view:
        self.responseTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.responseTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "headerCell")
        
	}
	
	override func viewWillDisappear(animated: Bool) {
		self.delegate?.notebookViewControllerWillDismiss(self.notebook)
	}
	
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let chosenImage: AnyObject? = info[UIImagePickerControllerOriginalImage]
        self.notebook.scribbleImages.append(chosenImage as! UIImage)
        notebookPhotoCollectionView.reloadData()
		self.delegate?.notebookContentDidChange(self.notebook)
        
        // TODO: Test on physical device, see how this performs with Camera as the imageSource
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
	
    @IBAction func onTakePictureButton(sender: UIButton) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = self.imageSourceType
        
		self.presentViewController(picker, animated: true, completion: nil)
    }
    
    //MARK: UICollectionViewDelegate:
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // When a student taps an image in their notebook, expand the image.
        if let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as? NotebookPhotoCollectionViewCell {
            let selectedImage = selectedCell.imageView.image!
            self.fullscreenImageView.image = selectedImage
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {self.fullscreenImageView.alpha = 1.0}, completion: nil)
        }
    }
    
    func hideFullScreenView(sender: AnyObject) {
        // Fade the fullscreen image out if it's visible.
        if self.fullscreenImageView.alpha == 1 {
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {self.fullscreenImageView.alpha = 0.0}, completion: nil)
        }
    }
    
    //MARK: UICollectionViewDataSource:
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return self.notebook.scribbleImages.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NotebookPhotoCollectionViewCell.REUSE_ID, forIndexPath: indexPath) as? NotebookPhotoCollectionViewCell {
                cell.imageView.image = self.notebook.scribbleImages[indexPath.row]
                return cell
            } else {
                fatalError("NotebookPhotoCollectionViewCell failed to load from xib. Check REUSE_ID and Xib name in both code and IB.")
            }
    }
    
    // MARK: UITableView
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // This table's sections correspond to a question (the header) and the response (the body text). Each question has only one response, so each section has only one row.
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return keysForQuestionsAnswered.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.responseTable.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        // Get the questionKey (where the HTML form sends its data) for the current section:
        let questionKey = self.keysForQuestionsAnswered[indexPath.section]
        
        // Get the response from that questionKey:
        let responseText = self.responsesForQuestionKeys[questionKey]
        
        cell.textLabel?.text = responseText
        
        return cell
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var  questionHeaderCell = self.responseTable.dequeueReusableCellWithIdentifier("headerCell") as! UITableViewCell
        
        // Headers are bold, have no line limit, and adjust to fit the frame.
        questionHeaderCell.textLabel?.font = UIFont.boldSystemFontOfSize(20)
        questionHeaderCell.textLabel?.numberOfLines = 0
        questionHeaderCell.textLabel?.adjustsFontSizeToFitWidth = true
        
        let questionKey = self.keysForQuestionsAnswered[section]
        let questionText = questionTextForQuestionKeys[questionKey]
        
        questionHeaderCell.textLabel?.text = questionText
        
        return questionHeaderCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return RESPONSE_TABLE_HEADER_HEIGHT
    }
    
    func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        return RESPONSE_TABLE_INDENTATION_LEVEL
    }


}
