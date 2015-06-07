#Young Chefs
##Experiment HTML Specification

##Intro
All experiment content for **Young Chefs** is loaded dynamically.
No experiment in the app is "hardcoded" in. Creating a new experiment does not
require changes to the source code of **Young Chefs**.

This document is a living specification of the details that the app requires
from all Experiments. This includes how to create and properly package an
entire Experiment from start to finish.

##Experiment Package Overview
Experiments consist of several building blocks which you must create in order for the app to recognize your experiment (although some of these building blocks are optional).

#### HTML files for each screen/page of the experiment
These files are the bread and butter of the experiment. They contain the text, text boxes (for students to write in), photos, and all the other content of the experiment.

We recommend the following convention for naming your experiment's HTML files: for an experiment called "Example Experiment", save each HTML file as "Example Experiment-0.html", "Example Experiment-1.html", etc. The number following the hyphen indicates which page of the experiment the file contains.

Every HTML file which defines content must adhere to the following principles:

The HTML should be structured like this:
`<!DOCTYPE html>
<html lang="">
	<head>
		<meta charset="UTF-8"/>
		<meta name="viewport" content="width=device-width, initial-scale=1.0"/>
		<script src="jquery-2.1.4.js"></script>
		<script src="fastclick.js"></script>
		<script src="javaswift.js"></script>
		<link rel="stylesheet" href="styles.css"/>
	</head>

<body>
HTML CONTENT
</body>

</html>`

We recommend that you base your experiment's HTML files off the files in the included example, "The Quest for the Perfect Cookie".

#####Providing for in-app Navigation
You should include buttons for navigation to other screens.
To include these, first define a navigation block as such:
`<div class="navigationBlock"> [...] </div>`

Inside the navigationBlock div, include this for backward navigation:
`<div class="back block">Back</div>`

Inside the navigationBlock div, include this for forward navigation:
`<div class="next block">Continue</div>`

On the last page of your experiment, instead of a button for forward navigation, put a button for resetting the experiment:
`<div class="reset block">Reset Experiment</div>`

**Important:** If you include both a forward and a back button, make sure the back button comes first, or else the spacing of the buttons may become clipped.

Note that these navigation buttons will function inside the **Young Chefs** app, but not in a test browser.

#####Creating Questions
To create a question, simply include this:
`<textarea class="input" rows="4" id="[unique question identifier]"></textarea>`

_[unique question identifier]_ is a unique string of text. If this is non-unique, user responses will not save correctly.

#### Icon image (optional)
This is optional, but highly recommended. The icon image is an opportunity to give the student a taste of what the experiment will be like!

Save an image file in your experiment folder in the JPG or PNG format. If the image is in the wrong format or if there is no image, the app will use a default image as the experiment's icon.

**Note:** In order for the app to recognize your experiment's icon, you **must** name it "Example Experiment.jpg" (or .png), where "Example Experiment" is your experiment's title. This is a mandatory convention.

#### Other resources (e.g. images)
Your experiment may have some images included within its pages. Let's say you want to present an image called "Chocolate Chips.png." First, you must put this file in your experiment folder. Then, to make it appear in your HTML, insert this line:
`<img src="Chocolate Chips.png" width="100%">`

#### The Manifest
**This file is crucial for your experiment to load properly.**
You have all these files sitting in a folder, but you need to tell the app where to look for the files! To do this, you need to include a manifest file. This file will be of the filetype `.plist` and **must** be named after the experiment. That is, for an experiment called "Example Experiment", you must title the manifest file "Example Experiment.plist"

The manifest file has three main sections: Questions, Screens, and Additional Resources.

We highly recommend that you copy the manifest file in our example and alter its contents to match your experiment, using a standard text editor. Creating a .plist file from scratch can be frustrating.

##### Questions
The Questions section of the manifest lets the app know how to refer to the questions you ask in the experiment. Recall the section above, on "Creating Questions." If you include a text box that asks "What is your hypothesis?" and, in your HTML, you give it the unique identifier "question_Hypothesis", your code for the text box will look like this:
`<textarea class="input" rows="4" id="question_Hypothesis"></textarea>`

When the user answers that question, her response will show up in the Notebook part of the app. The response will show up under a header, and you need to provide the text for that header. In this example, a suitable header would be "Your Hypothesis" or simply "Hypothesis".

We refer to the question's HTML ID as the *key* and the question's header text to the *string* which is associated with this key. The manifest maps the key to this string, telling the app what to show when it reads something from the question box with the given HTML ID.

So, with this one question, our Question section of the .plist file looks like this:
`<key>Questions</key>
<dict>
  <key>question_Hypothesis</key>
  <string>Hypothesis</string>
</dict>`

Of course, you would most likely need to add more questions to this section, depending on the number of questions in your experiment.

##### Screens
In the manifest file, you must also declare your screens / pages of the experiment by providing their file names and the order they should appear in. If we follow our recommended convention, let's say our "Example Experiment" has three screens: "Example Experiment-0.html", "Example Experiment-1.html", and "Example Experiment-2.html". Then, the Screens section of the .plist file looks like this:

`<key>Screens</key>
<array>
  <string>Example Experiment-0</string>
  <string>Example Experiment-1</string>
  <string>Example Experiment-2</string>
</array>`

Note that you shouldn't include ".html" in the screen names. If you do, the experiment will not load properly.

##### Additional Resources
In this section, you need to declare any other resources you have in your experiment, particularly images. If we use one image, called "Chocolate Chips.png", our AdditionalResources section of the .plist file will look like this:
`<key>AdditionalResources</key>
<array>
  <string>Chocolate Chips.png</string>
</array>`

#### Other files (that you don't need to touch)
The experiment also utilizes CSS and Javascript files that are only meant for the app developers to edit. These files make the experiments look nice and run smoothly.

***

See the included example ("The Quest for the Perfect Cookie") for a good model on how to build an experiment for the app. Again, we highly recommend that you duplicate and modify these files in creating your own experiment. It is much quicker than creating an experiment from scratch.
