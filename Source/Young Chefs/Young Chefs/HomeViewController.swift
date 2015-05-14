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
	
	//We dont want to actual init all the experiments for preview, because that could be a lot of screens, notebooks, and open file ports.
	//Instead we load into memory just the names of all the possible experiments from our 'experimentsDirectory.plist' file.
	//When a user actually selects an Experiment, we init it from the name before presenting the ExperimentViewController.
	//
	///A list of the avaliable experiments stored both on disc and in bundle
	var experimentNames : [String]!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
		layout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 0, right: 0)
		layout.itemSize = CGSize(width: 200, height: 200)
		layout.minimumInteritemSpacing = 0
		
		collectionView.collectionViewLayout = layout
		collectionView.registerNib(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: HomeCollectionViewCell.REUSE_ID)
		
		//load collectionView contents
		self.experimentNames = self.loadExperimentNamesFromExperimentsDirectory()
	}
	
	///Returns all the experiment names listed in 'experimentsDirectory.plist'
	private func loadExperimentNamesFromExperimentsDirectory() -> [String] {
		let fileURL = NSBundle.mainBundle().URLForResource("experimentsDirectory", withExtension: "plist")!
		let objectiveCDictionary = NSDictionary(contentsOfURL: fileURL)!
		let swiftDictionary = objectiveCDictionary as! Dictionary<String,AnyObject>
		
		var experimentNames = [String]()
		if let experimentsInMainBundle = swiftDictionary["MainBundle"] as? [String] {
			//Preinstalled experiments
			for name in experimentsInMainBundle {
				experimentNames.append(name)
			}
		}
		if let experimentsInLibraryDirectory = swiftDictionary["LibraryDirectory"] as? [String] {
			//Currently we're not loading or storing any data in the library, but if we want to download
			//new experiments from a service or any other non-app-update source, we'll need to.
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

    // MARK: UICollectionViewDataSource
	func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }


	func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return experimentNames.count
    }

	func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
		if let cell = collectionView.dequeueReusableCellWithReuseIdentifier(HomeCollectionViewCell.REUSE_ID, forIndexPath: indexPath) as? HomeCollectionViewCell {
			cell.titleLabel.text = self.experimentNames[indexPath.row]
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
				self.performSegueWithIdentifier("toExperiment", sender: selectedCell)
			}
	}
	
	//We use this method to pass incoming view controllers the experiment we want to present
	override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
		if let destinationExperimentViewController = segue.destinationViewController as? ExperimentViewController {
			//if we're naving to an experiment...
			if let experimentPreviewSender = sender as? HomeCollectionViewCell {
				//if a HomeCollectionViewCell (a preview of an experiment) sent us...
				destinationExperimentViewController.experiment = Experiment(experimentName: experimentPreviewSender.titleLabel.text!)
				//use that cell's title as a pointer to load the correct experiment
			}
		}
	}
}
