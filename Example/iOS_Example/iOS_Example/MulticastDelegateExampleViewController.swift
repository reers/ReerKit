//
//  MulticastDelegateExampleViewController.swift
//
//
//  Created by phoenix on 2024/7/19.
//

import UIKit
import ReerKit

protocol CounterDelegate {
    func counterDidUpdate(_ counter: Counter, to newValue: Int)
}

class Counter {
    static let shared: Counter = .init()
    var count: Int = 0 {
        didSet {
            multicastDelegate.invoke { $0.counterDidUpdate(self, to: count) }
        }
    }
    lazy var timer = RETimer(timeInterval: 1, callbackImmediatelyWhenFired: true) { [weak self] _ in
        self?.count += 1
    }
    private init() {
        timer.schedule()
    }
    
    var multicastDelegate: MulticastDelegate<CounterDelegate> = .init()
}

@objc(MulticastDelegateExampleViewController)
class MulticastDelegateExampleViewController: UIViewController, CounterDelegate {
    
    deinit {
        print("MulticastDelegateExampleViewController deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(countLabel)
        countLabel.frame = .init(x: 0, y: 200, width: view.bounds.width, height: 80)
        
        Counter.shared.multicastDelegate.add(self)
    }

    func counterDidUpdate(_ counter: Counter, to newValue: Int) {
        print("counterDidUpdate newValue: \(newValue)")
        countLabel.text = "\(newValue)"
    }
    
    private lazy var countLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textAlignment = .center
        label.textColor = .red
        label.font = .boldSystemFont(ofSize: 60)
        return label
    }()
}
