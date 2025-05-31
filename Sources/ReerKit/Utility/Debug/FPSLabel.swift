//
//  Copyright © 2019 ibireme
//  Copyright © 2022 reers.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

#if canImport(UIKit)
import UIKit

open class FPSLabel: UILabel {
    private static let labelSize = CGSize(width: 55, height: 20)
    
    private var link: CADisplayLink?
    private var count: UInt = 0
    private var lastTime: TimeInterval = 0
    private let _font: UIFont
    
    override init(frame: CGRect) {
        var adjustedFrame = frame
        if adjustedFrame.size.width == 0 && adjustedFrame.size.height == 0 {
            adjustedFrame.size = Self.labelSize
        }
        
        if let menloFont = UIFont(name: "Menlo", size: 14) {
            _font = menloFont
        } else {
            _font = UIFont(name: "Courier", size: 14) ?? UIFont.systemFont(ofSize: 14)
        }
        
        super.init(frame: adjustedFrame)
        
        setupUI()
        setupDisplayLink()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        link?.invalidate()
    }
    
    private func setupUI() {
        font = _font
        layer.cornerRadius = 5
        clipsToBounds = true
        textAlignment = .center
        isUserInteractionEnabled = false
        backgroundColor = UIColor(white: 0.0, alpha: 0.7)
    }
    
    private func setupDisplayLink() {
        link = CADisplayLink(
            target: WeakProxy(target: self),
            selector: #selector(tick(_:))
        )
        link?.add(to: .main, forMode: .common)
    }
    
    open override func sizeThatFits(_ size: CGSize) -> CGSize {
        return Self.labelSize
    }
    
    @objc
    private func tick(_ link: CADisplayLink) {
        if lastTime == 0 {
            lastTime = link.timestamp
            return
        }
        
        count += 1
        let delta = link.timestamp - lastTime
        if delta < 1 { return }
        
        lastTime = link.timestamp
        let fps = Float(count) / Float(delta)
        count = 0
        
        let progress = CGFloat(fps) / 60.0
        let color = UIColor(
            hue: 0.27 * (progress - 0.2),
            saturation: 1,
            brightness: 0.9,
            alpha: 1
        )
        
        let text = NSMutableAttributedString(string: "\(Int(fps.rounded())) FPS")
        text.addAttribute(
            .foregroundColor,
            value: color,
            range: NSRange(location: 0, length: text.length)
        )
        
        attributedText = text
    }
}
#endif
