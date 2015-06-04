//
//  JavaSwift.swift
//  Young Chefs
//
//  Julia Bindler
//  Graham Earley
//  Charlie Imhoff
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