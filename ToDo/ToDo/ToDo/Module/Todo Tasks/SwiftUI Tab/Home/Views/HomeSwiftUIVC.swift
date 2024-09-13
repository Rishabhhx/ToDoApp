//
//  HomeSwiftUIVC.swift
//  ToDo
//
//  Created by Rishabh Sharma on 13/09/24.
//

import UIKit
import SwiftUI

class HomeSwiftUIVC: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create a SwiftUI view
        let swiftUIView = HomeView()
        
        // Create a UIHostingController
        let hostingController = UIHostingController(rootView: swiftUIView)
        
        // Add the hosting controller's view as a subview
        addChild(hostingController)
        view.addSubview(hostingController.view)
        
        // Set the hosting controller's frame to fill the parent view
        hostingController.view.frame = view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        // Notify the hosting controller
        hostingController.didMove(toParent: self)
    }
    
}
