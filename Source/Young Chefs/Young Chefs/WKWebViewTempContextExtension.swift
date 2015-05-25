//
//  WKWebViewTempContextExtension.swift
//  Young Chefs
//
//  Created by Charlie Imhoff on 5/25/15.
//  Copyright (c) 2015 Young Chefs. All rights reserved.
//

import Foundation
import WebKit

/**
This extension provides a series of functions helpful in working around the
`WKWebView` bug preventing content loading from non-server

The core principle is to copy web resources into the temporary directory, inside a `www`
folder, "tricking" `WKWebView` into thinking it is loading from a server.

Documented Radar Post:		http://www.openradar.me/18039024
Credit for Workaround:		nacho4d via StackOverflow:
							http://stackoverflow.com/a/28676439
*/
extension WKWebView {
	
	///Clears out the `temp/www` context entirely.
	static func clearTempContext() {
		let fileMgr = NSFileManager.defaultManager()
		let tempPath = NSTemporaryDirectory().stringByAppendingPathComponent("www")
		fileMgr.removeItemAtPath(tempPath, error: nil)
	}
	
	///Copies a series of files to the `temp/www` context.
	///
	///Recommended use for items related to the HTML, but not loaded directly via a Screen
	///such as CSS, JS, and image files.
	static func copyResourcesIntoTempContext(fileURLs: [NSURL?]) {
		for file in fileURLs {
			if file != nil {
				WKWebView.convertURLToBugCompatibleURL(file!)
			}
		}
	}
	
	/**
	This 'converts' a given file URL to a functional one which works around the load bug.
	
	In actuallity, it *copies* the file into a temp directory and then loads it from there,
	tricking `WKWebView` into thinking it's loading from a www server.
	
	:para: fileURL a URL in any context intended for copying to a `temp/www` context.
	:returns: the file as a URL in a `temp/www` context, loadable in a `WKWebView`
	*/
	static func convertURLToBugCompatibleURL(fileURL: NSURL) -> NSURL? {
		if let filePath = fileURL.path {
			if let convertedPath = WKWebView.convertPathToBugCompatiblePath(filePath) {
				return NSURL(fileURLWithPath: convertedPath)
			}
		}
		
		return nil
	}
	
	/**
	This 'converts' a given file path to a functional one which works around the load bug.
	
	In actuallity, it *copies* the file into a temp directory and then loads it from there,
	tricking `WKWebView` into thinking it's loading from a www server.
	
	Source cortesy of nacho4d via StackOverflow:
	http://stackoverflow.com/a/28676439
	
	:para: filePath a path in any context intended for copying to a `temp/www` context.
	:returns: the file as a path in a `temp/www` context, loadable in a `WKWebView`
	*/
	static func convertPathToBugCompatiblePath(filePath: String) -> String? {
		let fileMgr = NSFileManager.defaultManager()
		let tmpPath = NSTemporaryDirectory().stringByAppendingPathComponent("www")
		var error: NSErrorPointer = nil
		if !fileMgr.createDirectoryAtPath(tmpPath, withIntermediateDirectories: true, attributes: nil, error: error) {
			println("Couldn't create www subdirectory. \(error)")
			return nil
		}
		let dstPath = tmpPath.stringByAppendingPathComponent(filePath.lastPathComponent)
		if !fileMgr.fileExistsAtPath(dstPath) {
			if !fileMgr.copyItemAtPath(filePath, toPath: dstPath, error: error) {
				println("Couldn't copy file to /tmp/www. \(error)")
				return nil
			}
		}
		return dstPath
	}
	
}