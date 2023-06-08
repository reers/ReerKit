//
//  ResponderChainEventViewController.swift
//  iOS_Example
//
//  Created by phoenix on 2023/6/8.
//

import UIKit
import ReerKit

extension ResponderEventName {
    static let testViewButtonClick: ResponderEventName = "XXTestButtonClicked"
}

class TestView: UIView {
    var button: UIButton!
    
    var switchView: UISwitch!

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .lightGray
        
        switchView = UISwitch()
        addSubview(switchView)
        switchView.frame = .re(10, 10, 50, 30)
        
        let label = UILabel()
        label.text = "Stop passing event when handled"
        label.font = .systemFont(ofSize: 11)
        label.textColor = .black
        label.numberOfLines = 2
        addSubview(label)
        label.frame = .re(switchView.re.right + 10, 10, 130, 30)
        
        button = UIButton()
        addSubview(button)
        button.backgroundColor = .red
        button.setTitle("Button", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.frame = .init(x: 50, y: 50, width: 100, height: 100)
        button.re.addAction(forControlEvents: .touchUpInside) { sender in
            print("111 button clicked and will send event")
            sender.re.post(.testViewButtonClick, userInfo: ["aaaaa": "bbbbbb"])
        }
        
        re.observeResponderEvent(.testViewButtonClick) { [weak self] userInfo, toNext in
            guard let self = self else { return }
            print("222 testview get event \(String(describing: userInfo))")
            toNext = !self.switchView.isOn
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

@objc(ResponderChainEventViewController)
class ResponderChainEventViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let test = TestView(frame: .init(x: 100, y: 120, width: 200, height: 200))
        test.re.centerX = view.re.centerX
        view.addSubview(test)
        
        re.observeResponderEvent(.testViewButtonClick) { userInfo, toNext in
            print("333 viewcontroller get event \(String(describing: userInfo))")
            toNext = false
        }
    }

}
