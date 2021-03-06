//
//  ExperimentViewController.swift
//  Young Chefs
//
//  Julia Bindler
//  Graham Earley
//  Charlie Imhoff
//

import UIKit
import WebKit

/**
ExperimentViewController controls the experiment view. It interacts with the experiment's WKWebView Screens
and their Javascript ("javaSwift"). It also provides navigation controls by letting students move 
on to the next screen and by presenting the Notebook popover.
*/
class ExperimentViewController: UIViewController, WKScriptMessageHandler, NotebookDelegate {
	
	var experiment : Experiment!	// must be set externally before the storyboard presents this view
	
	@IBOutlet weak var placeholderViewForWebview : UIView!
	@IBOutlet weak var notebookButton : UIBarButtonItem!
	@IBOutlet weak var shareButton : UIBarButtonItem!
	
	var screenView : ScreenView!
	
	//MARK: - Init
	
    /**
    When the view loads, we load a web view to display the HTML files of the experiment.
    This web view (screenView) replaces an initial placeholder view.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
		
		if experiment == nil {
			fatalError("experiment must be set before this view is presented. Use 'prepareForSegue' to pass incoming ExperimentViewController an Experiment before storyboard presentation")
		}
		
		// Ensure constant web resource files are copied into our temp context
        //  (see WKWebViewTempContextExtension.swift for more explanation)
		var constantWebRes = [NSURL?]()
		constantWebRes.append(NSBundle.mainBundle().URLForResource("styles", withExtension: "css"))
		constantWebRes.append(NSBundle.mainBundle().URLForResource("javaswift", withExtension: "js"))
		constantWebRes.append(NSBundle.mainBundle().URLForResource("jquery-2.1.4", withExtension: "js"))
		constantWebRes.append(NSBundle.mainBundle().URLForResource("fastclick", withExtension: "js"))
		WKWebView.copyResourcesIntoTempContext(constantWebRes)
		
		// Configure the screenView with our javaScript message handler and our first screen
		let javaSwiftConfig = WKWebViewConfiguration()
		javaSwiftConfig.userContentController.addScriptMessageHandler(self, name: "javaSwift")
		self.screenView = ScreenView(frame: placeholderViewForWebview.bounds, configuration: javaSwiftConfig, screen: experiment.currentScreen)
		
		// Replace (cover and fill) our placeholder view with our WKWebView
		self.screenView.autoresizingMask = UIViewAutoresizing.FlexibleWidth | UIViewAutoresizing.FlexibleHeight
		self.screenView.frame = self.placeholderViewForWebview.bounds
		self.placeholderViewForWebview.addSubview(screenView)
    }
	
	//MARK: - IBActions
	
	@IBAction func onNotebookButton(sender: UIBarButtonItem) {
		self.presentNotebook()
	}
	
	@IBAction func onShareButton(sender: UIBarButtonItem) {
		self.presentSharesheet()
	}
	
	/// The ratio of the space that the notebook should take up when it's displayed on screen
	private let notebookPopoverScreenRatios = (CGFloat(0.8), CGFloat(0.75))
	
	/// Present the Notebook popover
	private func presentNotebook() {
		let device = UIDevice.currentDevice().userInterfaceIdiom
		if device == .Pad {
			// Device is iPad, present notebook as a popover
			let popoverViewController = NotebookViewController(notebook: experiment.notebook)
			popoverViewController.delegate = self
			popoverViewController.modalPresentationStyle = .Popover
			let popover =  UIPopoverController(contentViewController: popoverViewController)
			
			// Set the size and present it
			let popWidth = self.view.frame.size.width * notebookPopoverScreenRatios.0
			let popHeight = self.view.frame.size.height * notebookPopoverScreenRatios.1
			popover.popoverContentSize = CGSize(width: popWidth, height: popHeight)
			let popRect = (notebookButton.valueForKey("view") as! UIView).frame
			popover.presentPopoverFromBarButtonItem(self.notebookButton, permittedArrowDirections: UIPopoverArrowDirection.Down, animated: true)
			
			// Set the opacity a tad lower for some nice transparency
			popoverViewController.view.backgroundColor = UIColor(white: 1, alpha: 0.20)
			
		} else if device == .Phone {
			// Device is iPhone or iPod Touch, present notebook modally
			let modalViewController = NotebookViewController(notebook: experiment.notebook)
			modalViewController.delegate = self
			modalViewController.modalPresentationStyle = .CurrentContext
			modalViewController.modalTransitionStyle = .CoverVertical
			self.presentViewController(modalViewController, animated: true, completion: nil)
			return
		}
	}
	
	/// Presents a share sheet for sharing the experiment
	private func presentSharesheet() {
		var sharingItems = [AnyObject]()
		
		//set our default share text
		let text = "'\(self.experiment.name)' via Young Chefs"
		sharingItems.append(text)
		
		//Get an image representation of the current Screen ---
		//start an image capture of the screen at the device resolution
		UIGraphicsBeginImageContextWithOptions(self.screenView.frame.size, true, 0.0)
		
		//render the screenView into the capture buffer
		screenView.layer.renderInContext(UIGraphicsGetCurrentContext())
		
		//save the capture buffer and add it to the share
		let image = UIGraphicsGetImageFromCurrentImageContext()
		sharingItems.append(image)
		
		//close the context
		UIGraphicsEndImageContext()
		//---
		
		//present the share
		let activityViewController = UIActivityViewController(activityItems: sharingItems, applicationActivities: nil)
		activityViewController.popoverPresentationController?.barButtonItem = self.shareButton
		activityViewController.excludedActivityTypes = [UIActivityTypeAssignToContact, UIActivityTypeAirDrop]
		self.presentViewController(activityViewController, animated: true, completion: nil)
	}
	
	//MARK: - Experiment Interaction
	
    /// Called whenever Notebook is edited, should not be used for saving to disk
	func notebookContentDidChange(aNotebook: Notebook) {
		// Do not respond. This may get called a lot of times and very quickly.
	}
	
	/// Used as a callback to save contents
	func notebookViewControllerWillDismiss(aNotebook: Notebook) {
		self.experiment.asyncSaveToFile()
	}
	
	/// Progress to the next screen in the experiment if it exists
	func nextScreen() {
		if experiment.progressIndex+1 >= self.experiment.screens.count {
			// Cannot go forward
            return
		} else {
			experiment.progressIndex++
			self.screenView.loadScreen(self.experiment.currentScreen)
		}
		experiment.asyncSaveToFile()
	}
	
	/// Progress to the previous screen in the experiment if it exists
	func previousScreen() {
		if experiment.progressIndex-1 < 0 {
			// Cannot go backward
            return
		} else {
			experiment.progressIndex--
			self.screenView.loadScreen(self.experiment.currentScreen)
		}
		experiment.asyncSaveToFile()
	}
    
    /// Reset the experiment's stored data (user responses, photos, etc), and go back to the first screen.
    func resetExperiment() {
        let alertController = UIAlertController(title: "Are you sure", message: "Resetting will erase your responses and photos within this experiment. Do you want to continue?", preferredStyle: .Alert)
        
        let yesAction = UIAlertAction(title: "Reset", style: .Destructive) { (action) in
            self.experiment.notebook.images = [UIImage]()
            self.experiment.notebook.keysForQuestionsAnswered = [String]()
            self.experiment.notebook.responsesForQuestionKey = [String: String]()
            self.experiment.progressIndex = 0
            
            // Save the reset changes:
            self.experiment.asyncSaveToFile()
            
            // Now reload the screen (to go to the first page):
            self.screenView.loadScreen(self.experiment.currentScreen)
        }
        alertController.addAction(yesAction)
        
        let noAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            // If the user cancels, don't do anything!
        }
        alertController.addAction(noAction)
        
        self.presentViewController(alertController, animated: true, completion: nil)
    }
	
	/// Binds a given response key to an associated value for use later
	func bindResponseKey(key: String, toValue value:String) {
        self.experiment.notebook.responsesForQuestionKey[key] = value
        
        // If the question key hasn't already been stored AND the key has a corresponding question header (which it should, but we're covering edge cases!), record that this question has been answered
        if !contains(self.experiment.notebook.keysForQuestionsAnswered, key) && contains(self.experiment.notebook.questionHeaderForQuestionKey.keys.array, key) {
            self.experiment.notebook.keysForQuestionsAnswered.append(key)
        }
	}
	
	//MARK: - JavaSwift
	
	/** 
    Parse a command from the HTML/Javascript, and execute a corresponding command in Swift.
    
    Called whenever js posts a message to 'javaSwift'.
    Explicitly whenever js runs:
    'window.webkit.messageHandlers.javaSwift.postMessage(<message : NSDictionary>)'
    */
	func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
		let sentData = message.body as! NSDictionary
		if let commandString = sentData[JavaSwiftConstants.commandKey] as? NSString {
			// Parse the command value String into a JSCommand enum value
			if let command = JSCommand(rawValue: commandString) {
				switch command {
				case .NextScreen:
					nextScreen()
				case .PreviousScreen:
					previousScreen()
				case .ContentReadyNotification:
					onContentReady()
				case .BindResponseKey:
					self.bindResponseKey(sentData)
                case .ResetExperiment:
                    self.resetExperiment()
				}
			} else {
				println("Err: command string '\(commandString)' not recognized.")
			}
		}
	}
	
	/**
    Called when the ScreenView has fully loaded the DOM asscociated with the current Screen.
    This function fills in the user's data from 'responseKeys' into the forms on the page.
    */
	func onContentReady() {
		self.screenView.fillKeyedHTMLWithValues(self.experiment.notebook.responsesForQuestionKey)
	}
	
	/// Helper function: given a javaSwift dictionary, parse it's contents and call 'bindResponseKey:(:)'
	func bindResponseKey(jsDict: NSDictionary) {
		if let key = jsDict["key"] as? String, let value = jsDict["value"] as? String {
			self.bindResponseKey(key, toValue: value)
		}
	}
}
