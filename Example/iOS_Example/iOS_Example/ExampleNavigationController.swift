//
//  ExampleNavigationController.swift
//  iOS_Example
//
//  Created by phoenix on 2025/5/31.
//

import UIKit
import ReerKit

class ExampleNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let fpsLabel = FPSLabel()
        view.addSubview(fpsLabel)

        fpsLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            fpsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            fpsLabel.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20)
        ])
    }
}
