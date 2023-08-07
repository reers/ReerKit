//
//  KeyboardManagerDemoViewController.swift
//  iOS_Example
//
//  Created by phoenix on 2023/6/8.
//

import UIKit
import ReerKit

@objc(KeyboardManagerDemoViewController)
class KeyboardManagerDemoViewController: UIViewController {
    
    deinit {
        print(#function)
    }
    
    var defaultFrame: CGRect = .zero
    var textField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        KeyboardManager.shared.addObserver(self)
        
        let button = UIButton()
        button.re.size = .re(80, 40)
        button.re.centerX = view.re.centerX
        button.re.centerY = view.re.height / 3.0
        button.setTitle("Toggle", for: .normal)
        button.setTitleColor(.red, for: .normal)
        button.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        view.addSubview(button)
        
        textField = UITextField()
        textField.placeholder = "Please input text"
        textField.backgroundColor = .lightGray
        textField.re.size = .re(200, 30)
        textField.re.centerX = view.re.centerX
        textField.re.bottom = view.re.height - (UIApplication.re.keyWindow?.safeAreaInsets.bottom ?? 0)
        defaultFrame = textField.frame
        view.addSubview(textField)
        textField.becomeFirstResponder()
    }
    
    @objc
    func toggle() {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        } else {
            textField.becomeFirstResponder()
        }
    }
}

extension KeyboardManagerDemoViewController: KeyboardObserver {
    
    func keyboardChanged(with transition: KeyboardTransition) {
        print(#function)
        if transition.toVisible {
            print(KeyboardManager.shared.keyboardView as Any)
        }
        UIView.animate(withDuration: transition.animationDuration, delay: 0, options: transition.animationOption) {
            let kbFrame = KeyboardManager.shared.convertRect(transition.toFrame, toView: self.view)
            if transition.toVisible {
                var textFrame = self.textField.frame
                textFrame.origin.x = 0
                textFrame.size.width = kbFrame.size.width
                textFrame.origin.y = kbFrame.origin.y - textFrame.size.height
                self.textField.frame = textFrame
            } else {
                self.textField.frame = self.defaultFrame
            }
        } completion: { _ in
            
        }
    }
}
