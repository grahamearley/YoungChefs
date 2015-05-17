//
//  HomeCollectionViewCell.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//
//  Julia Bindler
//  Graham Earley
//  Charlie Imhoff
/*

A collection view cell for the homepage. It stores the collection item's title and thumbnail image.

*/
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
	
	static let REUSE_ID = "HomeCell"

	@IBOutlet var titleLabel : UILabel!
	@IBOutlet var imageView : UIImageView!
	
}
