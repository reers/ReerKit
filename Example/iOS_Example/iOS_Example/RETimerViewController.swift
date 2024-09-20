//
//  RETimerViewController.swift
//  iOS_Example
//
//  Created by phoenix on 2024/9/20.
//

import UIKit
import ReerKit

@objc(RETimerViewController)
class RETimerViewController: UIViewController {
    
    var timeLabel = UILabel()
    
    var reTimer: RETimer?
    
    deinit {
        print("RETimerViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        timeLabel.text = "00:00"
        timeLabel.font = .boldSystemFont(ofSize: 40)
        timeLabel.textAlignment = .center
        timeLabel.frame = .re(0, 150, view.re.width, 60)
        view.addSubview(timeLabel)
        
        
        let resumeButton = createButton(withTitle: "resume")
        resumeButton.frame = .re(0, 250, 80, 80)
        resumeButton.re.centerX = view.re.centerX
        resumeButton.re.addAction(forControlEvents: .touchUpInside) { [weak self] _ in
            self?.reTimer?.resume()
        }
        view.addSubview(resumeButton)
        
        let pauseButton = createButton(withTitle: "pause")
        pauseButton.frame = resumeButton.frame
        pauseButton.re.right = resumeButton.re.left - 40
        pauseButton.re.addAction(forControlEvents: .touchUpInside) { [weak self] _ in
            self?.reTimer?.suspend()
        }
        view.addSubview(pauseButton)
        
        let resetButton = createButton(withTitle: "reset")
        resetButton.frame = resumeButton.frame
        resetButton.re.left = resumeButton.re.right + 40
        resetButton.re.addAction(forControlEvents: .touchUpInside) { [weak self] _ in
            self?.timeLabel.text = "00:00"
            self?.reTimer?.invalidate()
            self?.reTimer = nil
            self?.startTimer()
        }
        view.addSubview(resetButton)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    func startTimer() {
        timeLabel.textColor = .red
        reTimer = RETimer.scheduledTimerEverySecond { [weak self] timer, displaySeconds, passedDuration in
            let minutes = Int(Double(displaySeconds) / 60.0)
            let seconds = Int(Double(displaySeconds) - minutes.re.double * 60.0)
            self?.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    func createButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 40
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.setBackgroundImage(.re(color: .red), for: .normal)
        return button
    }
    
}
