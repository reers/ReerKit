//
//  CountdownTimerViewController.swift
//  iOS_Example
//
//  Created by phoenix on 2023/12/29.
//

import UIKit
import ReerKit
import os.log

@objc(CountdownTimerViewController)
class CountdownTimerViewController: UIViewController {
    
    var timeLabel = UILabel()
    
    var countdownTimer: CountdownTimer?
    
    deinit {
        print("CountdownTimerViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        timeLabel.text = "01:00"
        timeLabel.font = .boldSystemFont(ofSize: 40)
        timeLabel.textAlignment = .center
        timeLabel.frame = .re(0, 150, view.re.width, 60)
        view.addSubview(timeLabel)
        
        
        let resumeButton = createButton(withTitle: "resume")
        resumeButton.frame = .re(0, 250, 80, 80)
        resumeButton.re.centerX = view.re.centerX
        resumeButton.re.addAction(forControlEvents: .touchUpInside) { [weak self] _ in
            self?.countdownTimer?.resume()
        }
        view.addSubview(resumeButton)
        
        let pauseButton = createButton(withTitle: "pause")
        pauseButton.frame = resumeButton.frame
        pauseButton.re.right = resumeButton.re.left - 40
        pauseButton.re.addAction(forControlEvents: .touchUpInside) { [weak self] _ in
            self?.countdownTimer?.suspend()
        }
        view.addSubview(pauseButton)
        
        let resetButton = createButton(withTitle: "reset")
        resetButton.frame = resumeButton.frame
        resetButton.re.left = resumeButton.re.right + 40
        resetButton.re.addAction(forControlEvents: .touchUpInside) { [weak self] _ in
            self?.timeLabel.text = "01:00"
            self?.countdownTimer?.reset()
            self?.countdownTimer?.fire()
        }
        view.addSubview(resetButton)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
    }
    
    func startTimer() {
        timeLabel.textColor = .red
        
        countdownTimer = CountdownTimer.scheduledTimer(withTotalSeconds: 60) {
            [weak self] displaySeconds, leftDuration, passedDuration in
            
            let minutes = Int(Double(displaySeconds) / 60.0)
            let seconds = Int(Double(displaySeconds) - minutes.re.double * 60.0)
            self?.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
        }
        
        // or customize a countdownTimer by yourself
        
//        countdownTimer = CountdownTimer(interval: 0.1, times: 600) { [weak self] timer in
//            let leftSeconds = timer.leftDuration.rounded(.up)
//            let minutes = Int(leftSeconds / 60.0)
//            let seconds = Int(leftSeconds - minutes.re.double * 60.0)
//            self?.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
//            print("countdownTimer left duration: \(timer.leftDuration)")
//        }
//        countdownTimer?.fire()
       
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
