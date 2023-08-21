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

// MARK: - Enums

public extension UITextField {
    /// ReerKit: UITextField text type.
    ///
    /// - emailAddress: UITextField is used to enter email addresses.
    /// - password: UITextField is used to enter passwords.
    /// - generic: UITextField is used to enter generic text.
    enum TextType {
        /// ReerKit: UITextField is used to enter email addresses.
        case emailAddress

        /// ReerKit: UITextField is used to enter passwords.
        case password

        /// ReerKit: UITextField is used to enter generic text.
        case generic
    }
}

// MARK: - Properties

public extension Reer where Base: UITextField {
    /// ReerKit: Set textField for common text types.
    var textType: UITextField.TextType {
        get {
            if base.keyboardType == .emailAddress {
                return .emailAddress
            } else if base.isSecureTextEntry {
                return .password
            }
            return .generic
        }
        set {
            switch newValue {
            case .emailAddress:
                base.keyboardType = .emailAddress
                base.autocorrectionType = .no
                base.autocapitalizationType = .none
                base.isSecureTextEntry = false
                base.placeholder = "Email Address"

            case .password:
                base.keyboardType = .asciiCapable
                base.autocorrectionType = .no
                base.autocapitalizationType = .none
                base.isSecureTextEntry = true
                base.placeholder = "Password"

            case .generic:
                base.isSecureTextEntry = false
            }
        }
    }

    /// ReerKit: Check if text field is empty.
    var isEmpty: Bool {
        return base.text?.isEmpty == true
    }

    /// ReerKit: Return text with no spaces or new lines in beginning and end.
    var trimmedText: String? {
        return base.text?.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// ReerKit: Check if textFields text is a valid email format.
    ///
    ///        textField.text = "john@doe.com"
    ///        textField.hasValidEmail -> true
    ///
    ///        textField.text = "swifterswift"
    ///        textField.hasValidEmail -> false
    ///
    var hasValidEmail: Bool {
        // http://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        return base.text!.range(of: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}",
                           options: String.CompareOptions.regularExpression,
                           range: nil, locale: nil) != nil
    }

    /// ReerKit: Left view tint color.
    var leftViewTintColor: UIColor? {
        get {
            guard let iconView = base.leftView as? UIImageView else { return nil }
            return iconView.tintColor
        }
        set {
            guard let iconView = base.leftView as? UIImageView else { return }
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = newValue
        }
    }

    /// ReerKit: Right view tint color.
    var rightViewTintColor: UIColor? {
        get {
            guard let iconView = base.rightView as? UIImageView else { return nil }
            return iconView.tintColor
        }
        set {
            guard let iconView = base.rightView as? UIImageView else { return }
            iconView.image = iconView.image?.withRenderingMode(.alwaysTemplate)
            iconView.tintColor = newValue
        }
    }
    
    /// ReerKit: Clear text.
    func clear() {
        base.text = ""
        base.attributedText = NSAttributedString(string: "")
    }

    /// ReerKit: Set placeholder text color.
    ///
    /// - Parameter color: placeholder text color.
    func setPlaceHolderTextColor(_ color: UIColor?) {
        guard let holder = base.placeholder, !holder.isEmpty else { return }
        base.attributedPlaceholder = NSAttributedString(string: holder, attributes: [.foregroundColor: color])
    }

    /// ReerKit: Add padding to the left of the textfield rect.
    ///
    /// - Parameter padding: amount of padding to apply to the left of the textfield rect.
    func addPaddingLeft(_ padding: CGFloat) {
        base.leftView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: base.frame.height))
        base.leftViewMode = .always
    }

    /// ReerKit: Add padding to the right of the textfield rect.
    ///
    /// - Parameter padding: amount of padding to apply to the right of the textfield rect.
    func addPaddingRight(_ padding: CGFloat) {
        base.rightView = UIView(frame: CGRect(x: 0, y: 0, width: padding, height: base.frame.height))
        base.rightViewMode = .always
    }

    /// ReerKit: Add padding to the left of the textfield rect.
    ///
    /// - Parameters:
    ///   - image: left image.
    ///   - padding: amount of padding between icon and the left of textfield.
    func addPaddingLeftIcon(_ image: UIImage, padding: CGFloat) {
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: image.size.width + padding, height: image.size.height))
        let imageView = UIImageView(image: image)
        imageView.frame = iconView.bounds
        imageView.contentMode = .center
        iconView.addSubview(imageView)
        base.leftView = iconView
        base.leftViewMode = .always
    }

    /// ReerKit: Add padding to the right of the textfield rect.
    ///
    /// - Parameters:
    ///   - image: right image.
    ///   - padding: amount of padding between icon and the right of textfield.
    func addPaddingRightIcon(_ image: UIImage, padding: CGFloat) {
        let iconView = UIView(frame: CGRect(x: 0, y: 0, width: image.size.width + padding, height: image.size.height))
        let imageView = UIImageView(image: image)
        imageView.frame = iconView.bounds
        imageView.contentMode = .center
        iconView.addSubview(imageView)
        base.rightView = iconView
        base.rightViewMode = .always
    }
    
    /// Add tool bars to the textfield input accessory view.
    /// - Parameters:
    ///   - items: The items to present in the toolbar.
    ///   - height: The height of the toolbar.
    #if os(iOS)
    @discardableResult
    func addToolbar(items: [UIBarButtonItem]?, height: CGFloat = 44) -> UIToolbar {
        let toolBar = UIToolbar(frame: CGRect(x: 0.0, y: 0.0, width: UIScreen.main.bounds.size.width, height: height))
        toolBar.setItems(items, animated: false)
        base.inputAccessoryView = toolBar
        return toolBar
    }
    #endif
}

#endif
