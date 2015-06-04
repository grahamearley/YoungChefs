//
//  JavaSwift.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/20/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//

import Foundation

///Constants related to the JavaSwift port and system
class JavaSwiftConstants {
	static let commandKey = "command"
}

///A enum for the easy parsing of commands sent from js using the JavaSwift port
enum JSCommand : NSString {
	
	case NextScreen = "nextButton"
	case PreviousScreen = "backButton"
	case ContentReadyNotification = "contentIsReady"
	case BindResponseKey = "bindResponseKey"
    case ResetExperiment = "resetButton"

}