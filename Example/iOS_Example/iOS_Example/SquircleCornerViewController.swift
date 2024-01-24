//
//  SquircleCornerViewController.swift
//  iOS_Example
//
//  Created by phoenix on 2024/1/24.
//

import UIKit
import ReerKit

@objc(SquircleCornerViewController)
class SquircleCornerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.clipsToBounds = true
        
        let white = UIView()
        white.backgroundColor = .white
        white.frame = .re(-250, 150, 500, 500)
        white.layer.cornerRadius = 150
        view.addSubview(white)
        
        let red = UIView()
        red.backgroundColor = .red
        red.frame = .re(-250, 150, 500, 500)
        red.re.squircleRoundCorners(radius: 150)
        view.addSubview(red)
    }

}
