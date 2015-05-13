//
//  Experiment.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/13/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//

import UIKit

class Experiment {
	
	var screens = [Screen]()
	
	static func testExperiment() -> Experiment {
		let e = Experiment()
		e.screens.append(Screen(htmlFileName: "example"))
		e.screens.append(Screen(htmlFileName: "example"))
		return e
	}
	
}