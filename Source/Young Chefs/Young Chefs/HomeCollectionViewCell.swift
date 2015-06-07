//
//  HomeCollectionViewCell.swift
//  Young Chefs
//
//  Julia Bindler
//  Graham Earley
//  Charlie Imhoff
//

import UIKit

/// HomeCollectionViewCell is collection view cell for the display of options on the app homepage.
class HomeCollectionViewCell: UICollectionViewCell {
	
	static let REUSE_ID = "HomeCell"
	static let xibName = "HomeCollectionViewCell"
	static let defaultSize = CGSize(width: 200, height: 200)

	@IBOutlet weak var titleLabel : UILabel!
	@IBOutlet weak var imageView : UIImageView!
	
}
