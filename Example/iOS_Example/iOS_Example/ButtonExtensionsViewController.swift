//
//  ButtonExtensionsViewController.swift
//  iOS_Example
//
//  Created by phoenix on 2023/9/14.
//

import UIKit
import ReerKit

@objc(ButtonExtensionsViewController)
class ButtonExtensionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        let button1 = createButton()
        button1.frame = .init(x: 40, y: 150, width: 100, height: 70)
        button1.re.layoutContent(with: .leftImageRightText, spacing: 5)
        view.addSubview(button1)
        
        let button2 = createButton()
        button2.frame = .init(x: 40, y: 250, width: 100, height: 70)
        button2.re.layoutContent(with: .leftTextRightImage, spacing: 5)
        view.addSubview(button2)
        
        let button3 = createButton()
        button3.frame = .init(x: 40, y: 350, width: 100, height: 70)
        button3.re.layoutContent(with: .topImageBottomText, spacing: 5)
        view.addSubview(button3)
        
        let button4 = createButton()
        button4.frame = .init(x: 40, y: 450, width: 100, height: 70)
        button4.re.layoutContent(with: .topTextBottomImage, spacing: 0, offsetFromCenter: .init(dx: -20, dy: 10))
        view.addSubview(button4)
    }
    
    func createButton() -> UIButton {
        let button = UIButton()
        button.setTitle("Star", for: .normal)
        button.tintColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 19)
        button.backgroundColor = .lightGray
        button.setImage(.init(systemName: "star"), for: .normal)
        return button
    }

}
