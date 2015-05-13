//
//  HomeViewController.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

	@IBOutlet var collectionView : UICollectionView!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
		layout.itemSize = CGSize(width: 90, height: 90)
		
		collectionView.collectionViewLayout = layout
		collectionView.registerNib(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: HomeCollectionViewCell.REUSE_ID)
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 15
    }

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HomeCollectionViewCell.REUSE_ID, forIndexPath: indexPath) as? HomeCollectionViewCell {
			cell.imageView.image = UIImage(named: "Cookie")
			return cell
		} else {
			fatalError("HomeCollectionViewCell failed to load from xib. Check REUSE_ID and Xib name in both code and IB.")
		}
		
    }

    // MARK: UICollectionViewDelegate
	
	func collectionView(collectionView: UICollectionView,
		didSelectItemAtIndexPath indexPath: NSIndexPath) {
			if let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as? HomeCollectionViewCell {
				self.performSegueWithIdentifier("toExperiment", sender: self)
			}
	}
	
	//We use this method to pass incoming view controllers the experiment we want to present
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let destinationExperimentViewController = segue.destinationViewController as? ExperimentViewController {
			destinationExperimentViewController.experiment = Experiment.testExperiment()
		}
	}
}
