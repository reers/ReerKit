//
//  SwiftUITestViewController.swift
//  iOS_Example
//
//  Created by phoenix on 2023/9/15.
//

import UIKit
import ReerKit
import SwiftUI

struct RedView: View {
    var body: some View {
        ZStack {
            Color.red
            Text("I am Swift UI view")
        }
    }
}

struct BlueView: View {
    var body: some View {
        ZStack {
            Color.blue
            Text("I am Swift UI view")
        }
    }
}

@objc(SwiftUITestViewController)
class SwiftUITestViewController: UIViewController {
    
    var redView = UIView()
    var blueView = UIView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        redView = view.re.addSwiftUIView(RedView())
        blueView = view.re.insertSwiftUIView(BlueView(), belowSubview: redView)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        redView.frame = .init(x: 30, y: 150, width: 100, height: 100)
        blueView.frame = .init(x: 80, y: 200, width: 100, height: 100)
    }

}
