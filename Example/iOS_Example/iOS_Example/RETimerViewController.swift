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
    var timeLabel2 = UILabel()
    var timeLabel3 = UILabel()
    
    var reTimer: RETimer?
    var reTimer2: RETimer?
    var reTimer3: RETimer?
    
    deinit {
        print("RETimerViewController deinit")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
       
        addTimer()
        addTimer2()
        addTimer3()
    }
    
    func addTimer() {
        
        let resumeButton = createButton(withTitle: "resume")
        resumeButton.frame = .re(0, 180, 80, 80)
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
        
        timeLabel.text = "00:00"
        timeLabel.font = .boldSystemFont(ofSize: 40)
        timeLabel.textAlignment = .left
        timeLabel.frame = .re(pauseButton.re.left, 120, view.re.width, 60)
        view.addSubview(timeLabel)
    }
    
    func addTimer2() {
        let resumeButton = createButton(withTitle: "resume")
        resumeButton.frame = .re(0, 410, 80, 80)
        resumeButton.re.centerX = view.re.centerX
        resumeButton.re.addAction(forControlEvents: .touchUpInside) { [weak self] _ in
            self?.reTimer2?.resume()
        }
        view.addSubview(resumeButton)
        
        let pauseButton = createButton(withTitle: "pause")
        pauseButton.frame = resumeButton.frame
        pauseButton.re.right = resumeButton.re.left - 40
        pauseButton.re.addAction(forControlEvents: .touchUpInside) { [weak self] _ in
            self?.reTimer2?.suspend()
        }
        view.addSubview(pauseButton)
        
        timeLabel2.text = "00:00:00.000"
        timeLabel2.font = .boldSystemFont(ofSize: 40)
        timeLabel2.textAlignment = .left
        timeLabel2.frame = .re(pauseButton.re.left, 350, view.re.width, 60)
        view.addSubview(timeLabel2)
    }
    
    func addTimer3() {
        let resumeButton = createButton(withTitle: "resume")
        resumeButton.frame = .re(0, 640, 80, 80)
        resumeButton.re.centerX = view.re.centerX
        resumeButton.re.addAction(forControlEvents: .touchUpInside) { [weak self] _ in
            self?.reTimer3?.resume()
        }
        view.addSubview(resumeButton)
        
        let pauseButton = createButton(withTitle: "pause")
        pauseButton.frame = resumeButton.frame
        pauseButton.re.right = resumeButton.re.left - 40
        pauseButton.re.addAction(forControlEvents: .touchUpInside) { [weak self] _ in
            self?.reTimer3?.suspend()
        }
        view.addSubview(pauseButton)
        
        let resetButton = createButton(withTitle: "reset")
        resetButton.frame = resumeButton.frame
        resetButton.re.left = resumeButton.re.right + 40
        resetButton.re.addAction(forControlEvents: .touchUpInside) { [weak self] _ in
            self?.timeLabel3.text = "00:00:00.000"
            self?.reTimer3?.invalidate()
            self?.reTimer3 = nil
            self?.startTimer3()
        }
        view.addSubview(resetButton)
        
        timeLabel3.text = "00:00.000"
        timeLabel3.font = .boldSystemFont(ofSize: 40)
        timeLabel3.textAlignment = .left
        timeLabel3.frame = .re(pauseButton.re.left, 580, view.re.width, 60)
        view.addSubview(timeLabel3)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startTimer()
        startTimer2()
        startTimer3()
    }
    
    func startTimer() {
        timeLabel.textColor = .blue
        reTimer = RETimer.scheduledTimerEverySecond { [weak self] timer, displaySeconds, passedDuration in
            let minutes = Int(Double(displaySeconds) / 60.0)
            let seconds = Int(Double(displaySeconds) - minutes.re.double * 60.0)
            self?.timeLabel.text = String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    func startTimer2() {
        timeLabel2.textColor = .blue
        reTimer2 = RETimer.scheduledTimer(timeInterval: 0.001) { timer in
            self.timeLabel2.text = Date().re.string(withFormat: "HH:mm:ss.SSS")
        }
    }
    
    func startTimer3() {
        timeLabel3.textColor = .blue
        reTimer3 = RETimer.scheduledTimer(timeInterval: 0.001) { timer in
            let minutes = Int(timer.totalElapsedTime / 60.0)
            let seconds = Int(timer.totalElapsedTime - minutes.re.double * 60.0)
            let minutesInMilliseconds = minutes.re.double * 60 * 1000
            let secondsInMilliseconds = seconds.re.double * 1000
            let milliseconds = Int(timer.totalElapsedTime * 1000 - minutesInMilliseconds - secondsInMilliseconds)
            self.timeLabel3.text = String(format: "%02d:%02d.%03d", minutes, seconds, milliseconds)
        }
    }
    
    func createButton(withTitle title: String) -> UIButton {
        let button = UIButton()
        button.setTitle(title, for: .normal)
        button.layer.cornerRadius = 40
        button.clipsToBounds = true
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 19)
        button.setBackgroundImage(.re(color: .orange), for: .normal)
        return button
    }
    
}
