    __  __                           ________         ____
    \ \/ /___  __  ______  ____ _   / ____/ /_  ___  / __/____
     \  / __ \/ / / / __ \/ __ `/  / /   / __ \/ _ \/ /_/ ___/
     / / /_/ / /_/ / / / / /_/ /  / /___/ / / /  __/ __(__  )
    /_/\____/\__,_/_/ /_/\__, /   \____/_/ /_/\___/_/ /____/
                        /____/

This app began as a project for Carleton College's CS342 Mobile App Development course.

**The Client:** Vayu Maini Rekdal and [Young Chefs](http://youngchefsprogram.org/)

**The Team:** Julia Bindler, Charlie Imhoff, Graham Earley

This repository contains the Young Chefs iPad app, a project for Carleton College's CS 342 Mobile App Development course. Young Chefs is an after school program designed to teach students science through cooking experiments. Currently, the program is confined to the classroom. The goal of this app is to expand the program and increase the accessibility of the experiments. The app is also designed so that experiments can be loaded in easily and independent of Swift code (to do this, we utilize HTML and JavaScript). The app contains experiments written by Vayu Maini Rekdal. In the future, experiments could be pulled from the server, creating a sort of platform for science education through cooking.

Instructions for creating experiments are located in `Resources/Experiment Creation Instructions`.

## Running the source code:
Load the `Source/YoungChefs` directory in Xcode.

## For future developers:
- All the features we aimed to implement are successfully implemented and functional in the app.
- There is room in the code for server integration (pulling experiments from a server), and this is a feature that would be great to have before release. Currently, resources such as experiments are all loaded from the read-only Main Bundle, but care has been put into providing early code for reading from the Library folder as well, which is where downloaded experiments would reside.
- While the project's core functionality works on both iPad and iPhone, the app (notably the web content) is currently more visually optimized for larger sized devices.
- See this repository's Issues tracker for stretch goals / enhancements /tasks that we brainstormed but didn't finish or start. These are listed with the status of 'on hold'.
