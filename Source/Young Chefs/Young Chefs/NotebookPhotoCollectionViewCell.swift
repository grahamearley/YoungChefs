//
//  NotebookPhotoCollectionViewCell.swift
//  Young Chefs
//
//  Julia Bindler
//  Graham Earley
//  Charlie Imhoff
//

import UIKit

/// NotebookPhotoCollectionViewCell is collection view cell for the display of UIImage objects within the NotebookViewController.
class NotebookPhotoCollectionViewCell: UICollectionViewCell {
    
    static let REUSE_ID = "NotebookPhotoCell"
	static let xibName = "NotebookPhotoCollectionViewCell"
	static let defaultSize = CGSize(width: 140, height: 140)

    @IBOutlet weak var imageView: UIImageView!
    
}
