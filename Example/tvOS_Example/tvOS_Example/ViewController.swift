//
//  ViewController.swift
//  tvOS_Example
//
//  Created by phoenix on 2024/1/11.
//

import UIKit
import ReerKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let label = UILabel()
        label.text = "aGVsbG8gd29ybGQ=".re.base64Decoded
        label.frame = .init(x: 100, y: 200, width: 300, height: 100)
        view.addSubview(label)
    }


}

