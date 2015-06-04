//
//  NotebookViewController.swift
//  Young Chefs
//
//  Julia Bindler
//  Graham Earley
//  Charlie Imhoff

import UIKit

///Protocol for Notebooks to submit callbacks to other ViewControllers on events
protocol NotebookDelegate {
	
	func notebookContentDidChange(aNotebook: Notebook)
	
	func notebookViewControllerWillDismiss(aNotebook: Notebook)
}

/**
NotebookViewController allows the user to take a picture (or load from gallery, if there is no camera),
and store responses to questions asked throughout the Experiment. NotebookViewController also presents
the student's photos in a CollectionView.

Not to be confused with Notebook, which stores the data.
*/
class NotebookViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UITableViewDelegate, UITableViewDataSource {
    
    let RESPONSE_TABLE_HEADER_HEIGHT = CGFloat(50)
    let RESPONSE_TABLE_INDENTATION_LEVEL = 2
    let QUESTION_HEADER_FONT_SIZE = CGFloat(20)

	var notebook: Notebook
    var imageSourceType: UIImagePickerControllerSourceType
	var delegate: NotebookDelegate?
    
    @IBOutlet weak var responseTable: UITableView!
    @IBOutlet weak var notebookPhotoCollectionView: UICollectionView!
    @IBOutlet weak var fullscreenImageView: UIImageView!
	@IBOutlet weak var closeButton: UIButton!
    
	init(notebook: Notebook) {
		self.notebook = notebook
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera) {
            // Users without a camera will only be able to add from their photo library.
            self.imageSourceType = .PhotoLibrary
        } else {
            self.imageSourceType = .Camera
        }
        
		super.init(nibName: "NotebookView", bundle: nil)
	}

	required init(coder aDecoder: NSCoder) {
	    fatalError("the funky fresh 'init(coder:)' has not been implemented")
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// hide the close button if we're on an iPad
		if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
			self.closeButton.removeFromSuperview()
		}
        
        // This image view will be revealed only when the student taps a picture to enlarge it:
        self.fullscreenImageView.alpha = 0.0
        let recognizer = UITapGestureRecognizer(target: self, action: Selector("hideFullScreenView:"))
        recognizer.numberOfTapsRequired = 1
        self.fullscreenImageView.addGestureRecognizer(recognizer)
        
        // Set up the notebook photos collection view:
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        let horizontalPadding = CGFloat(5)
        let verticalPadding = CGFloat(2)

        layout.sectionInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        layout.itemSize = NotebookPhotoCollectionViewCell.defaultSize
        layout.scrollDirection = .Horizontal
        
        notebookPhotoCollectionView.collectionViewLayout = layout
        notebookPhotoCollectionView.registerNib(UINib(nibName: NotebookPhotoCollectionViewCell.xibName, bundle: nil), forCellWithReuseIdentifier: NotebookPhotoCollectionViewCell.REUSE_ID)
        notebookPhotoCollectionView.delegate = self
        
        // Table view (for storing responses to questions):
        self.responseTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "responseCell")
        self.responseTable.registerClass(UITableViewCell.self, forCellReuseIdentifier: "headerCell")
        
        // Set table cells' height to auto-resize if there are long responses / lots of text:
        self.responseTable.rowHeight = UITableViewAutomaticDimension
        self.responseTable.estimatedRowHeight = 50
        
	}
	
	override func viewWillDisappear(animated: Bool) {
		self.delegate?.notebookViewControllerWillDismiss(self.notebook)
	}
	
	@IBAction func onCloseButton(sender: UIButton) {
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let chosenImage: AnyObject? = info[UIImagePickerControllerOriginalImage]
        self.notebook.images.append(chosenImage as! UIImage)
        
        notebookPhotoCollectionView.reloadData()
		self.delegate?.notebookContentDidChange(self.notebook)
        
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
        
        // This is a built-in view for picking/taking a photo
		self.presentViewController(picker, animated: true, completion: nil)
    }
    
    //MARK: - UICollectionViewDelegate:
    
    /// When a student taps an image in their notebook, expand the image.
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as? NotebookPhotoCollectionViewCell {
            let selectedImage = selectedCell.imageView.image!
            self.fullscreenImageView.image = selectedImage
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseIn, animations: {self.fullscreenImageView.alpha = 1.0}, completion: nil)
        }
    }
    
    /// Fade the fullscreen image out if it's visible.
    func hideFullScreenView(sender: AnyObject) {
        if self.fullscreenImageView.alpha == 1 {
            UIView.animateWithDuration(0.2, delay: 0, options: UIViewAnimationOptions.CurveEaseOut, animations: {self.fullscreenImageView.alpha = 0.0}, completion: nil)
        }
    }
    
    //MARK: - UICollectionViewDataSource (for images):
    
    func collectionView(collectionView: UICollectionView,
        numberOfItemsInSection section: Int) -> Int {
            return self.notebook.images.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /// Set up the image collection view cells
    func collectionView(collectionView: UICollectionView,
        cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
            if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(NotebookPhotoCollectionViewCell.REUSE_ID, forIndexPath: indexPath) as? NotebookPhotoCollectionViewCell {
                // Fill the cell with its image
                cell.imageView.image = self.notebook.images[indexPath.row]
                return cell
            } else {
                fatalError("NotebookPhotoCollectionViewCell failed to load from xib. Check REUSE_ID and Xib name in both code and IB.")
            }
    }
    
    // MARK: - UITableView
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // This table's sections correspond to a question (the header) and the response (the body text). Each question has only one response, so each section has only one row.
        return 1
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.notebook.keysForQuestionsAnswered.count
    }
    
    /// Set up the table cells
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let responseCell = self.responseTable.dequeueReusableCellWithIdentifier("responseCell") as! UITableViewCell
        
        // Get the questionKey (where the HTML form sends its data) for the current section:
        let questionKey = self.notebook.keysForQuestionsAnswered[indexPath.section]
        
        // Get the response from that questionKey:
        let responseText = self.notebook.responsesForQuestionKey[questionKey]
        
        responseCell.textLabel?.numberOfLines = 0 // No line limit
        
        responseCell.textLabel?.text = responseText
        return responseCell
    }
    
    /// Add headers to the table (headers are the questions, whereas regular cells are the responses)
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var questionHeaderCell = self.responseTable.dequeueReusableCellWithIdentifier("headerCell") as! UITableViewCell
        
        // Headers are bold, have no line limit, and adjust to fit the frame.
        questionHeaderCell.textLabel?.font = UIFont.boldSystemFontOfSize(QUESTION_HEADER_FONT_SIZE)
        questionHeaderCell.textLabel?.numberOfLines = 0
        questionHeaderCell.textLabel?.adjustsFontSizeToFitWidth = true
        
        let questionKey = self.notebook.keysForQuestionsAnswered[section]
        let questionHeader = self.notebook.questionHeaderForQuestionKey[questionKey]
        
        questionHeaderCell.textLabel?.text = questionHeader
        return questionHeaderCell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return RESPONSE_TABLE_HEADER_HEIGHT
    }
    
    func tableView(tableView: UITableView, indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        return RESPONSE_TABLE_INDENTATION_LEVEL
    }

}
