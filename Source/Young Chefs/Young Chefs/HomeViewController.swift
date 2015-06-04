//
//  HomeViewController.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//
//  Julia Bindler
//  Graham Earley
//  Charlie Imhoff
/**  

This class controls the main homepage, which displays a collection of experiments the student can try.
It loads experiments from the disk and sends the experiment's information to the Experiment view when an experiment is selected.

*/
//

import UIKit

class HomeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

	@IBOutlet var collectionView : UICollectionView!
	
	/* 
    We dont want to actually initialize all the experiments for preview, because that could be a lot of screens, notebooks, and open file ports. Instead we load into memory just the names of all the possible experiments from our 'experimentsDirectory.plist' file. When a user actually selects an Experiment, we init it from the name before presenting the ExperimentViewController.
	*/
    
	/// A list of the avaliable experiments stored both on disc and in bundle
	var experimentNames : [String]!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Set up the collection view
		let padding : CGFloat
		let itemSize : CGSize
		switch UIDevice.currentDevice().userInterfaceIdiom {
		case .Pad:
			padding = 40
			itemSize = HomeCollectionViewCell.defaultSize
		case .Phone:
			padding = 0
			itemSize = CGSize(width: self.view.frame.size.width, height: HomeCollectionViewCell.defaultSize.height + 50)
		default:
			padding = 20
			itemSize = HomeCollectionViewCell.defaultSize
		}
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: padding, left: padding, bottom: padding, right: padding)
		layout.itemSize = itemSize
		layout.minimumInteritemSpacing = padding
        layout.minimumLineSpacing = padding
		
		collectionView.collectionViewLayout = layout
		collectionView.registerNib(UINib(nibName: HomeCollectionViewCell.xibName, bundle: nil), forCellWithReuseIdentifier: HomeCollectionViewCell.REUSE_ID)
		
		// Load collectionView contents
		self.experimentNames = self.loadExperimentNamesFromExperimentsDirectory()
	}
	
    /**
    Load the experiments from either the Main Bundle or the Library directory.
    
    :returns: an array of the experiment names listed in 'experimentsDirectory.plist'
    */
	private func loadExperimentNamesFromExperimentsDirectory() -> [String] {
		let fileURL = NSBundle.mainBundle().URLForResource("experimentsDirectory", withExtension: "plist")!
		let experimentsByFileLocation = NSDictionary(contentsOfURL: fileURL)! as! Dictionary<String,AnyObject>
		
		var experimentNames = [String]()
		if let experimentsInMainBundle = experimentsByFileLocation["MainBundle"] as? [String] {
			// Preinstalled experiments
			for name in experimentsInMainBundle {
				experimentNames.append(name)
			}
		}
		if let experimentsInLibraryDirectory = experimentsByFileLocation["LibraryDirectory"] as? [String] {
			// Currently we're not loading or storing any data in the library, but if we want to download
			// new experiments from a service or any other non-app-update source, we'll need to.
			for name in experimentsInLibraryDirectory {
				experimentNames.append(name)
			}
		}
		
		return experimentNames
	}
	
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - UICollectionViewDataSource
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // The collectionView's one section has as many items as there are in the list of experiments
        return experimentNames.count
    }

    /// Prepare a cell for the collection view
	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HomeCollectionViewCell.REUSE_ID, forIndexPath: indexPath) as? HomeCollectionViewCell {
            let experimentName = self.experimentNames[indexPath.row]
			
            cell.titleLabel.text = experimentName
			
            // The experiment's icon image must be either .jpg or .png. Otherwise, use the default image.
            cell.imageView.image = UIImage(named: experimentName + ".jpg", inBundle: nil, compatibleWithTraitCollection: nil) ?? UIImage(named: experimentName + ".png", inBundle: nil, compatibleWithTraitCollection: nil) ?? UIImage(named: "default.jpg", inBundle: nil, compatibleWithTraitCollection: nil)
            
            // Adjust text to fit experiments with larger names:
            cell.titleLabel.numberOfLines = 5
            cell.titleLabel.adjustsFontSizeToFitWidth = true
            
			return cell
		} else {
			fatalError("HomeCollectionViewCell failed to load from xib. Check REUSE_ID and Xib name in both code and IB.")
		}
    }

    // MARK: - UICollectionViewDelegate
	
	func collectionView(collectionView: UICollectionView,
		didSelectItemAtIndexPath indexPath: NSIndexPath) {
			if let selectedCell = collectionView.cellForItemAtIndexPath(indexPath) as? HomeCollectionViewCell {
				self.performSegueWithIdentifier("toExperiment", sender: selectedCell)
			}
	}
	
	/// This method passes the experiment we want to present to incoming view controllers
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let destinationExperimentViewController = segue.destinationViewController as? ExperimentViewController {
			// If we're naving to an experiment...
			if let experimentPreviewSender = sender as? HomeCollectionViewCell {
				// init and bind an Experiment to the baby
				destinationExperimentViewController.experiment = Experiment.experiment(experimentPreviewSender.titleLabel.text!)
                destinationExperimentViewController.title = experimentPreviewSender.titleLabel.text
			}
		}
	}
}
