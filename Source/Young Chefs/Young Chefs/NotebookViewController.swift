//
//  NotebookViewController.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//

import UIKit

class NotebookViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource {

	var notebook: Notebook
    var imageSourceType: UIImagePickerControllerSourceType
	
    @IBOutlet weak var notebookPhotoCollectionView: UICollectionView!
	@IBOutlet weak var editText : UITextView!
	
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

		editText.text = notebook.scribbleText
		editText.delegate = self
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 2, left: 5, bottom: 2, right: 5)
        layout.itemSize = CGSize(width: 140, height: 140)
        layout.scrollDirection = .Horizontal
        layout.minimumInteritemSpacing = 0
        
        notebookPhotoCollectionView.collectionViewLayout = layout
        notebookPhotoCollectionView.registerNib(UINib(nibName: "NotebookPhotoCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: NotebookPhotoCollectionViewCell.REUSE_ID)
	}
    
    func imagePickerController(picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        let chosenImage: AnyObject? = info[UIImagePickerControllerOriginalImage]
        self.notebook.scribbleImages.append(chosenImage as! UIImage)
        notebookPhotoCollectionView.reloadData()
        
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
    
	//MARK: UITextView Delegate
	
	func textViewDidChange(textView: UITextView) {
		self.notebook.scribbleText = editText.text
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

}
