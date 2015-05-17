//
//  NotebookPhotoCollectionViewCell.swift
//  Young Chefs
//
//  Created by Graham Earley on 5/16/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//
//  Julia Bindler
//  Graham Earley
//  Charlie Imhoff
/*

A collection view cell for the notebook popover view. It shows an image that the user has taken.

*/
//

import UIKit

class NotebookPhotoCollectionViewCell: UICollectionViewCell {
    
    static let REUSE_ID = "NotebookPhotoCell"

    @IBOutlet var imageView: UIImageView!
    
}
