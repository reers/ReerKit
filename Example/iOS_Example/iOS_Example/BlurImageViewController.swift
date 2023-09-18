//
//  BlurImageViewController.swift
//  iOS_Example
//
//  Created by phoenix on 2023/9/15.
//

import UIKit
import ReerKit

@objc(BlurImageViewController)
class BlurImageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let imageView = UIImageView(frame: .init(x: 20, y: 200, width: view.re.width - 40, height: 180))
        imageView.contentMode = .scaleAspectFit
        imageView.image = .init(named: "test_image")
        view.addSubview(imageView)
        
        let slider = UISlider(frame: .init(x: 20, y: 400, width: view.re.width - 40, height: 40))
        slider.minimumValue = 0
        slider.maximumValue = 35
        view.addSubview(slider)
        slider.re.addAction(forControlEvents: .valueChanged) { _ in
            imageView.image = UIImage(named: "test_image")?.re.blur(
                radius: CGFloat(slider.value),
                tintColor: UIColor.init(white: 0.2, alpha: 0.1),
                tintBlendMode: .normal,
                saturation: 1.5,
                maskImage: nil
            )
        }
    }

}
