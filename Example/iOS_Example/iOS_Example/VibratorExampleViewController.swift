//
//  VibratorExampleViewController.swift
//  iOS_Example
//
//  Created by phoenix on 2025/7/2.
//

import UIKit
import ReerKit

@objc(VibratorExampleViewController)
class VibratorExampleViewController: UIViewController {
    
    // MARK: - UI Components
    
    private lazy var stackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 40
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Vibrator Test Demo"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Heavy Impact Button Section
    private lazy var heavyButtonSection: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var heavyLabel: UILabel = {
        let label = UILabel()
        label.text = "Heavy Impact Feedback"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var heavyButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Tap for Heavy Vibration", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor.systemBlue
        button.layer.cornerRadius = 8
        button.addTarget(self, action: #selector(heavyButtonTapped), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Selection Slider Section
    private lazy var sliderSection: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var sliderLabel: UILabel = {
        let label = UILabel()
        label.text = "Selection Feedback Slider"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var sliderValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Value: 0.5"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = .lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = 0.5
        slider.tintColor = .systemBlue
        slider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        slider.addTarget(self, action: #selector(sliderTouchBegan(_:)), for: .touchDown)
        slider.addTarget(self, action: #selector(sliderTouchEnded(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    // Additional Feedback Types Section
    private lazy var additionalSection: UIView = {
        let container = UIView()
        container.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        container.layer.cornerRadius = 12
        container.translatesAutoresizingMaskIntoConstraints = false
        return container
    }()
    
    private lazy var additionalLabel: UILabel = {
        let label = UILabel()
        label.text = "Other Feedback Types"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var feedbackButtonsStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillEqually
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private lazy var successButton: UIButton = {
        let button = createFeedbackButton(title: "Success", color: .systemGreen)
        button.addTarget(self, action: #selector(successButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var warningButton: UIButton = {
        let button = createFeedbackButton(title: "Warning", color: .systemOrange)
        button.addTarget(self, action: #selector(warningButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var errorButton: UIButton = {
        let button = createFeedbackButton(title: "Error", color: .systemRed)
        button.addTarget(self, action: #selector(errorButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Properties
    
    private var lastSliderValue: Float = 0.5
    private let selectionThreshold: Float = 0.01 // Minimum change to trigger selection feedback
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        
        // Prepare generators for better performance
        Vibrator.prepare(.heavy)
        Vibrator.prepare(.selectionChanged)
        Vibrator.prepare(.success)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Clean up generators when leaving the view
        Vibrator.end()
    }
    
    // MARK: - Setup
    
    private func setupUI() {
        view.backgroundColor = .black
        view.clipsToBounds = true
        
        // Add main container
        view.addSubview(stackView)
        
        // Add title
        stackView.addArrangedSubview(titleLabel)
        
        // Setup heavy button section
        stackView.addArrangedSubview(heavyButtonSection)
        heavyButtonSection.addSubview(heavyLabel)
        heavyButtonSection.addSubview(heavyButton)
        
        // Setup slider section
        stackView.addArrangedSubview(sliderSection)
        sliderSection.addSubview(sliderLabel)
        sliderSection.addSubview(sliderValueLabel)
        sliderSection.addSubview(slider)
        
        // Setup additional feedback section
        stackView.addArrangedSubview(additionalSection)
        additionalSection.addSubview(additionalLabel)
        additionalSection.addSubview(feedbackButtonsStack)
        
        feedbackButtonsStack.addArrangedSubview(successButton)
        feedbackButtonsStack.addArrangedSubview(warningButton)
        feedbackButtonsStack.addArrangedSubview(errorButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Main stack view
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 24),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -24),
            
            // Heavy button section
            heavyButtonSection.heightAnchor.constraint(equalToConstant: 120),
            
            heavyLabel.topAnchor.constraint(equalTo: heavyButtonSection.topAnchor, constant: 16),
            heavyLabel.leadingAnchor.constraint(equalTo: heavyButtonSection.leadingAnchor, constant: 16),
            heavyLabel.trailingAnchor.constraint(equalTo: heavyButtonSection.trailingAnchor, constant: -16),
            
            heavyButton.topAnchor.constraint(equalTo: heavyLabel.bottomAnchor, constant: 12),
            heavyButton.leadingAnchor.constraint(equalTo: heavyButtonSection.leadingAnchor, constant: 16),
            heavyButton.trailingAnchor.constraint(equalTo: heavyButtonSection.trailingAnchor, constant: -16),
            heavyButton.bottomAnchor.constraint(equalTo: heavyButtonSection.bottomAnchor, constant: -16),
            heavyButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Slider section
            sliderSection.heightAnchor.constraint(equalToConstant: 140),
            
            sliderLabel.topAnchor.constraint(equalTo: sliderSection.topAnchor, constant: 16),
            sliderLabel.leadingAnchor.constraint(equalTo: sliderSection.leadingAnchor, constant: 16),
            sliderLabel.trailingAnchor.constraint(equalTo: sliderSection.trailingAnchor, constant: -16),
            
            sliderValueLabel.topAnchor.constraint(equalTo: sliderLabel.bottomAnchor, constant: 8),
            sliderValueLabel.leadingAnchor.constraint(equalTo: sliderSection.leadingAnchor, constant: 16),
            sliderValueLabel.trailingAnchor.constraint(equalTo: sliderSection.trailingAnchor, constant: -16),
            
            slider.topAnchor.constraint(equalTo: sliderValueLabel.bottomAnchor, constant: 12),
            slider.leadingAnchor.constraint(equalTo: sliderSection.leadingAnchor, constant: 16),
            slider.trailingAnchor.constraint(equalTo: sliderSection.trailingAnchor, constant: -16),
            slider.bottomAnchor.constraint(equalTo: sliderSection.bottomAnchor, constant: -16),
            
            // Additional section
            additionalSection.heightAnchor.constraint(equalToConstant: 120),
            
            additionalLabel.topAnchor.constraint(equalTo: additionalSection.topAnchor, constant: 16),
            additionalLabel.leadingAnchor.constraint(equalTo: additionalSection.leadingAnchor, constant: 16),
            additionalLabel.trailingAnchor.constraint(equalTo: additionalSection.trailingAnchor, constant: -16),
            
            feedbackButtonsStack.topAnchor.constraint(equalTo: additionalLabel.bottomAnchor, constant: 12),
            feedbackButtonsStack.leadingAnchor.constraint(equalTo: additionalSection.leadingAnchor, constant: 16),
            feedbackButtonsStack.trailingAnchor.constraint(equalTo: additionalSection.trailingAnchor, constant: -16),
            feedbackButtonsStack.bottomAnchor.constraint(equalTo: additionalSection.bottomAnchor, constant: -16),
            feedbackButtonsStack.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
    
    private func createFeedbackButton(title: String, color: UIColor) -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle(title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.setTitleColor(.lightGray, for: .highlighted)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        button.backgroundColor = color
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }
    
    // MARK: - Actions
    
    @objc private func heavyButtonTapped() {
        print("🔨 Heavy impact feedback triggered")
        Vibrator.occur(.heavy)
        
        // Visual feedback
        UIView.animate(withDuration: 0.1, animations: {
            self.heavyButton.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                self.heavyButton.transform = .identity
            }
        }
    }
    
    @objc private func sliderValueChanged(_ sender: UISlider) {
        let currentValue = sender.value
        sliderValueLabel.text = String(format: "Value: %.2f", currentValue)
        
        // Trigger selection feedback when value changes significantly
        if abs(currentValue - lastSliderValue) >= selectionThreshold {
            print("🎯 Selection feedback triggered - Value: \(String(format: "%.2f", currentValue))")
            Vibrator.occur(.selectionChanged)
            lastSliderValue = currentValue
        }
    }
    
    @objc private func sliderTouchBegan(_ sender: UISlider) {
        print("📱 Slider touch began - Preparing selection feedback")
        Vibrator.prepare(.selectionChanged)
    }
    
    @objc private func sliderTouchEnded(_ sender: UISlider) {
        print("📱 Slider touch ended")
        // Optionally trigger one final selection feedback
        Vibrator.occur(.selectionChanged)
    }
    
    @objc private func successButtonTapped() {
        print("✅ Success feedback triggered")
        Vibrator.occur(.success)
        animateButton(successButton)
    }
    
    @objc private func warningButtonTapped() {
        print("⚠️ Warning feedback triggered")
        Vibrator.occur(.warning)
        animateButton(warningButton)
    }
    
    @objc private func errorButtonTapped() {
        print("❌ Error feedback triggered")
        Vibrator.occur(.error)
        animateButton(errorButton)
    }
    
    private func animateButton(_ button: UIButton) {
        UIView.animate(withDuration: 0.1, animations: {
            button.transform = CGAffineTransform(scaleX: 0.95, y: 0.95)
        }) { _ in
            UIView.animate(withDuration: 0.1) {
                button.transform = .identity
            }
        }
    }
}
