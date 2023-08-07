//
//  PushCompletionViewController.swift
//  iOS_Example
//
//  Created by phoenix on 2023/8/7.
//

import UIKit

@objc(PushCompletionViewController)
class PushCompletionViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let button = UIButton()
        button.setTitle("Close Self", for: .normal)
        button.backgroundColor = .red
        button.frame = .re(0, 0, 100, 100)
        button.center = view.center
        view.addSubview(button)
        button.re.addAction(forControlEvents: .touchUpInside) { [weak self] _ in
            guard let self = self else { return }
            self.re.closeSelf()
        }
    }
}
