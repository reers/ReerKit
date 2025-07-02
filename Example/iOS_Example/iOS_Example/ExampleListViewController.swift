//
//  ExampleListViewController.swift
//  ReerKit
//
//  Created by YuYue on 2022/7/25.
//

import UIKit
import os.log
import ReerKit

struct Example {
    var title: String
    var vcName: String
}

class ExampleListViewController: UIViewController {
    
    
    let demos = [
        Example(title: "KeyboardManager", vcName: "KeyboardManagerDemoViewController"),
        Example(title: "Send Event by Responder Chain", vcName: "ResponderChainEventViewController"),
        Example(title: "Push Completion Test", vcName: "PushCompletionViewController"),
        Example(title: "Button Layout Test", vcName: "ButtonExtensionsViewController"),
        Example(title: "Use SwiftUI view in UIKit", vcName: "SwiftUITestViewController"),
        Example(title: "Blur image", vcName: "BlurImageViewController"),
        Example(title: "Gray model for UIView", vcName: "GrayModeViewController"),
        Example(title: "RETimer", vcName: "RETimerViewController"),
        Example(title: "CountdownTimer", vcName: "CountdownTimerViewController"),
        Example(title: "Squircle Rounded Corner", vcName: "SquircleCornerViewController"),
        Example(title: "Multicast Delegate Test", vcName: "MulticastDelegateExampleViewController"),
        Example(title: "Feedback generator", vcName: "VibratorExampleViewController")
    ]
    
    
    // MARK: UI Properties
    
    let tableView = UITableView()
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.title = "Examples"
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.tableView)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "user")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
   
    // MARK: Layout
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.tableView.frame = self.view.bounds
    }
    
}


// MARK: - UITableViewDataSource

extension ExampleListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return demos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "user", for: indexPath)
        let demo = demos[indexPath.row]
        cell.textLabel?.text = demo.title
        cell.detailTextLabel?.textColor = .gray
        cell.accessoryType = .disclosureIndicator
        return cell
    }
}


// MARK: - UITableViewDelegate

extension ExampleListViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath : IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        let demo = demos[indexPath.row]
        guard let clazz = NSClassFromString(demo.vcName) as? UIViewController.Type else { return }
        let viewController = clazz.init()
        os_log("push start")
        navigationController?.re.pushViewController(viewController, animated: true) {
            os_log("push completion after animation")
        }
    }
}

