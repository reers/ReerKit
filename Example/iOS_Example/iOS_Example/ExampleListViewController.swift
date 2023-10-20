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
        Example(title: "Blur image", vcName: "BlurImageViewController")
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
        
        testRSA()
    }
    
    func testRSA() {
        let publicKey = """
        -----BEGIN PUBLIC KEY-----
        MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCNYrDS+lx1Td4D33HqjDr+ArSe
        i/mu3dpTZQLOfUeSgq7sgYDyEgkHBUKvl+vdJj9zzwEVZ4NX74c2Fct9NuNISFFA
        LKFou6nCUPHNjMeM5xVqM969h2/H+KLmkTEjbqKuvPglLPpY4LczVNZseM2Sx75g
        463E4p8ywMUTgLpa1wIDAQAB
        -----END PUBLIC KEY-----
        """
        let privateKey = """
        -----BEGIN RSA PRIVATE KEY-----
        MIICXAIBAAKBgQCNYrDS+lx1Td4D33HqjDr+ArSei/mu3dpTZQLOfUeSgq7sgYDy
        EgkHBUKvl+vdJj9zzwEVZ4NX74c2Fct9NuNISFFALKFou6nCUPHNjMeM5xVqM969
        h2/H+KLmkTEjbqKuvPglLPpY4LczVNZseM2Sx75g463E4p8ywMUTgLpa1wIDAQAB
        AoGAaQGdVnR/atf0RmgT0SFpRvJ3dzF6tXcsCbgBx56gI55PkHP2ctMWRVKQ3p00
        nkEj6z0ZDu6cTBkoEPFK+qpjTlYkr7+prjlxuOWjWxlpGBwfFu+cWKVzZI1nS5ED
        qw8zHswzCWgKOWac5zBYk6p3CvuG6HG5jqyf3/3gqA7ZzhECQQDQz5GvgqQp8bpp
        0itmlEFpafylYDrNXYaCUzwMnR1xoPsa6jEfwVz4+vK1RXs8nSgSDM9q74FOZvJe
        a4MvRxE7AkEArVZVYXq29lfy6QwV1S6rR9vculSaDGcs31KjSiuiAEGNQ2/zNwmT
        9oNNxqU2WYiGzYpqtLjrEkwQ5HHqXPLDFQJBAJVMxML0KwLelsYRAv0uZfLEWGO6
        gXDTPVizwMzYDfRwAPsGlic5b4uKir13t5zoVX1KcYfpRdBUJVnDj6HfM38CQAjg
        /DyjCY4y0RmI6fFik5l5tKPCw6VQ/6Zs2DprY7/5m5/RszalgfPFpA1B1zfc23LZ
        3T9mnXvxc4gQIb4jHUUCQFQQf1278yh6MXbleml4brXOmIDfssNML/2aJlB4W1Si
        WkdwGY++TSEvz/gJ+WipfCcgaZBywqdDP7gjNpjJyqU=
        -----END RSA PRIVATE KEY-----
        """
        
        let encrypted = "123".re.utf8Data!.re.rsaEncrypt(withPublicKey: publicKey)
        let string = encrypted!.re.rsaDecrypt(withPrivateKey: privateKey)!.re.utf8String!
        print(string)
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

