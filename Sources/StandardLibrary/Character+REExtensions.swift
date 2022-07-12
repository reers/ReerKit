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

extension Character: ReerCompatibleValue {}
public extension Reer where Base == Character {
    
    /// ReerKit: Check if character is emoji.
    ///
    ///     Character("😀").re.isEmoji -> true
    ///
    var isEmoji: Bool {
        let scalarValue = String(base).unicodeScalars.first!.value
        switch scalarValue {
        case 0x1F600...0x1F64F, // Emoticons
             0x1F300...0x1F5FF, // Misc Symbols and Pictographs
             0x1F680...0x1F6FF, // Transport and Map
             0x1F1E6...0x1F1FF, // Regional country flags
             0x2600...0x26FF, // Misc symbols
             0x2700...0x27BF, // Dingbats
             0xE0020...0xE007F, // Tags
             0xFE00...0xFE0F, // Variation Selectors
             0x1F900...0x1F9FF, // Supplemental Symbols and Pictographs
             127_000...127_600, // Various asian characters
             65024...65039, // Variation selector
             9100...9300, // Misc items
             8400...8447: // Combining Diacritical Marks for Symbols
            return true
        default:
            return false
        }
    }

    /// ReerKit: Integer from character (if applicable).
    ///
    ///     Character("1").re.int -> 1
    ///     Character("A").re.int -> nil
    ///
    var int: Int? {
        return Int(String(base))
    }

    /// ReerKit: String from character.
    ///
    ///     Character("a").re.string -> "a"
    ///
    var string: String {
        return String(base)
    }

    /// ReerKit: Return the character lowercased.
    ///
    ///     Character("A").re.lowercased -> Character("a")
    ///
    var lowercased: Character {
        return String(base).lowercased().first!
    }

    /// ReerKit: Return the character uppercased.
    ///
    ///     Character("a").re.uppercased -> Character("A")
    ///
    var uppercased: Character {
        return String(base).uppercased().first!
    }
}

// MARK: - Methods

public extension Reer where Base == Character {
    
    /// ReerKit: Random character.
    ///
    ///    Character.re.random() -> k
    ///
    /// - Returns: A random character.
    static func randomAlphanumeric() -> Character {
        return "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789".randomElement()!
    }
}
