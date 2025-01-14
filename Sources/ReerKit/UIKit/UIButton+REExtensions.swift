//
//  Copyright © 2020 SwifterSwift
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

#if canImport(UIKit) && !os(watchOS)
import UIKit

public extension Reer where Base: UIButton {
    /// ReerKit: Image of disabled state for button; also inspectable from Storyboard.
    var imageForDisabled: UIImage? {
        get { return base.image(for: .disabled) }
        set { base.setImage(newValue, for: .disabled) }
    }

    /// ReerKit: Image of highlighted state for button; also inspectable from Storyboard.
    var imageForHighlighted: UIImage? {
        get { return base.image(for: .highlighted) }
        set { base.setImage(newValue, for: .highlighted) }
    }

    /// ReerKit: Image of normal state for button; also inspectable from Storyboard.
    var imageForNormal: UIImage? {
        get { return base.image(for: .normal) }
        set { base.setImage(newValue, for: .normal) }
    }

    /// ReerKit: Image of selected state for button; also inspectable from Storyboard.
    var imageForSelected: UIImage? {
        get { return base.image(for: .selected) }
        set { base.setImage(newValue, for: .selected) }
    }

    /// ReerKit: Image of focused state for button; also inspectable from Storyboard.
    var imageForFocused: UIImage? {
        get { return base.image(for: .focused) }
        set { base.setImage(newValue, for: .focused) }
    }
    
    /// ReerKit: Title color of disabled state for button; also inspectable from Storyboard.
    var titleColorForDisabled: UIColor? {
        get { return base.titleColor(for: .disabled) }
        set { base.setTitleColor(newValue, for: .disabled) }
    }

    /// ReerKit: Title color of highlighted state for button; also inspectable from Storyboard.
    var titleColorForHighlighted: UIColor? {
        get { return base.titleColor(for: .highlighted) }
        set { base.setTitleColor(newValue, for: .highlighted) }
    }

    /// ReerKit: Title color of normal state for button; also inspectable from Storyboard.
    var titleColorForNormal: UIColor? {
        get { return base.titleColor(for: .normal) }
        set { base.setTitleColor(newValue, for: .normal) }
    }

    /// ReerKit: Title color of selected state for button; also inspectable from Storyboard.
    var titleColorForSelected: UIColor? {
        get { return base.titleColor(for: .selected) }
        set { base.setTitleColor(newValue, for: .selected) }
    }

    /// ReerKit: Title color of focused state for button; also inspectable from Storyboard.
    var titleColorForFocused: UIColor? {
        get { return base.titleColor(for: .focused) }
        set { base.setTitleColor(newValue, for: .focused) }
    }
    
    /// ReerKit: Title of disabled state for button; also inspectable from Storyboard.
    var titleForDisabled: String? {
        get { return base.title(for: .disabled) }
        set { base.setTitle(newValue, for: .disabled) }
    }

    /// ReerKit: Title of highlighted state for button; also inspectable from Storyboard.
    var titleForHighlighted: String? {
        get { return base.title(for: .highlighted) }
        set { base.setTitle(newValue, for: .highlighted) }
    }

    /// ReerKit: Title of normal state for button; also inspectable from Storyboard.
    var titleForNormal: String? {
        get { return base.title(for: .normal) }
        set { base.setTitle(newValue, for: .normal) }
    }

    /// ReerKit: Title of selected state for button; also inspectable from Storyboard.
    var titleForSelected: String? {
        get { return base.title(for: .selected) }
        set { base.setTitle(newValue, for: .selected) }
    }
    
    /// ReerKit: Title of focused state for button; also inspectable from Storyboard.
    var titleForFocused: String? {
        get { return base.title(for: .focused) }
        set { base.setTitle(newValue, for: .focused) }
    }
    
    /// ReerKit: Attributed title of disabled state for button.
    var attributedTitleForDisabled: NSAttributedString? {
        get { return base.attributedTitle(for: .disabled) }
        set { base.setAttributedTitle(newValue, for: .disabled) }
    }

    /// ReerKit: Attributed title of highlighted state for button.
    var attributedTitleForHighlighted: NSAttributedString? {
        get { return base.attributedTitle(for: .highlighted) }
        set { base.setAttributedTitle(newValue, for: .highlighted) }
    }

    /// ReerKit: Attributed title of normal state for button.
    var attributedTitleForNormal: NSAttributedString? {
        get { return base.attributedTitle(for: .normal) }
        set { base.setAttributedTitle(newValue, for: .normal) }
    }

    /// ReerKit: Attributed title of selected state for button.
    var attributedTitleForSelected: NSAttributedString? {
        get { return base.attributedTitle(for: .selected) }
        set { base.setAttributedTitle(newValue, for: .selected) }
    }
    
    /// ReerKit: Attributed title of focused state for button.
    var attributedTitleForFocused: NSAttributedString? {
        get { return base.attributedTitle(for: .focused) }
        set { base.setAttributedTitle(newValue, for: .focused) }
    }
    
    private var states: [UIControl.State] {
        [.normal, .selected, .highlighted, .disabled, .focused]
    }

    /// ReerKit: Set image for all states.
    ///
    /// - Parameter image: UIImage.
    func setImageForAllStates(_ image: UIImage?) {
        states.forEach { base.setImage(image, for: $0) }
    }

    /// ReerKit: Set title color for all states.
    ///
    /// - Parameter color: UIColor.
    func setTitleColorForAllStates(_ color: UIColor?) {
        states.forEach { base.setTitleColor(color, for: $0) }
    }

    /// ReerKit: Set title for all states.
    ///
    /// - Parameter title: title string.
    func setTitleForAllStates(_ title: String?) {
        states.forEach { base.setTitle(title, for: $0) }
    }

    /// ReerKit: Set attributed title for all states.
    ///
    /// - Parameter title: title string.
    func setAttributedTitleForAllStates(_ title: NSAttributedString?) {
        states.forEach { base.setAttributedTitle(title, for: $0) }
    }
    
    enum ContentLayoutType {
        case leftImageRightText
        case leftTextRightImage
        case topImageBottomText
        case topTextBottomImage
    }
    
    /// ReerKit: Layout button's image and text. Setup title, font, image before invoking this method.
    /// - Parameters:
    ///   - type: layout type.
    ///   - spacing: spacing between title text and image.
    ///   - offsetFromCenter: offset from center of button.
    func layoutContent(with type: ContentLayoutType, spacing: CGFloat = 0, offsetFromCenter: CGVector = .init(dx: 0, dy: 0)) {
        guard let imageSize = base.imageView?.image?.size,
              let text = base.titleLabel?.text,
              let font = base.titleLabel?.font
        else { return }
        
        let titleSize = text.size(withAttributes: [.font: font])
        let insetAmount = Swift.abs(spacing / 2)
        switch type {
        case .leftImageRightText:
            base.imageEdgeInsets = UIEdgeInsets(top: 0, left: -insetAmount, bottom: 0, right: insetAmount)
            base.titleEdgeInsets = UIEdgeInsets(top: 0, left: insetAmount, bottom: 0, right: -insetAmount)
        case .leftTextRightImage:
            base.imageEdgeInsets = UIEdgeInsets(
                top: 0,
                left: titleSize.width + insetAmount,
                bottom: 0,
                right: -(titleSize.width + insetAmount)
            )
            base.titleEdgeInsets = UIEdgeInsets(
                top: 0,
                left: -(imageSize.width + insetAmount),
                bottom: 0,
                right: imageSize.width + insetAmount
            )
        case .topImageBottomText:
            let centerXOffset = (titleSize.width + imageSize.width) / 2
            let centerYOffset = (titleSize.height + imageSize.height) / 2
            base.imageEdgeInsets = UIEdgeInsets(
                top: (imageSize.height / 2) - centerYOffset - insetAmount,
                left: centerXOffset - (imageSize.width / 2),
                bottom: insetAmount + centerYOffset - (imageSize.height / 2),
                right: (imageSize.width / 2) - centerXOffset
            )
            base.titleEdgeInsets = UIEdgeInsets(
                top: insetAmount + centerYOffset - (titleSize.height / 2),
                left: -centerXOffset + (titleSize.width / 2),
                bottom: (titleSize.height / 2) - centerYOffset - insetAmount,
                right: centerXOffset - (titleSize.width / 2)
            )
        case .topTextBottomImage:
            let centerXOffset = (titleSize.width + imageSize.width) / 2
            let centerYOffset = (titleSize.height + imageSize.height) / 2
            base.imageEdgeInsets = UIEdgeInsets(
                top: insetAmount + centerYOffset - (imageSize.height / 2),
                left: centerXOffset - (imageSize.width / 2),
                bottom: (imageSize.height / 2) - centerYOffset - insetAmount,
                right: (imageSize.width / 2) - centerXOffset
            )
            base.titleEdgeInsets = UIEdgeInsets(
                top: (titleSize.height / 2) - centerYOffset - insetAmount,
                left: -centerXOffset + (titleSize.width / 2),
                bottom: insetAmount + centerYOffset - (titleSize.height / 2),
                right: centerXOffset - (titleSize.width / 2)
            )
        }
        base.contentEdgeInsets = .init(
            top: offsetFromCenter.dy,
            left: offsetFromCenter.dx,
            bottom: -offsetFromCenter.dy,
            right: -offsetFromCenter.dx
        )
    }
    
    /// ReerKit: Set background color for specified state.
    /// - Parameters:
    ///   - color: The color of the image that will be set as background for the button in the given state.
    ///   - forState: set the UIControl.State for the desired color.
    func setBackgroundColor(color: UIColor?, forState: UIControl.State) {
        guard let color = color else { return }
        base.clipsToBounds = true
        
        if #available(iOS 10.0, tvOS 10.0, *) {
            let colorImage = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1)).image { context in
                color.setFill()
                context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
                base.draw(.zero)
            }
            base.setBackgroundImage(colorImage, for: forState)
            return
        }
        
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            base.setBackgroundImage(colorImage, for: forState)
        }
    }
}

#endif
