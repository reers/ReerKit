//
//  GrayModeViewController.swift
//  iOS_Example
//
//  Created by phoenix on 2023/12/8.
//

import UIKit
import ReerKit

@objc(GrayModeViewController)
class GrayModeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let button = UIButton()
        button.setTitle("Click Me", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 40)
        button.setTitleColor(.yellow, for: .normal)
        button.backgroundColor = .red
        button.layer.cornerRadius = 50
        button.frame = .init(x: 80, y: 200, width: view.re.width - 160, height: 100)
        view.addSubview(button)
        
        button.addTarget(self, action: #selector(toggle(_:)), for: .touchUpInside)
    }
    
    @objc
    func toggle(_ sender: UIButton) {
        let previous = sender.re.isGrayModeEnabled
        sender.re.isGrayModeEnabled = !previous
    }
}
