//
//  Copyright (c) 2020 Tundaware LLC
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

#if canImport(Security)
import Security
#endif

public struct NanoID {
    
    /// Generate a new identifier
    ///
    /// - Parameters:
    ///   - alphabet: alphabet to use, exclude to use instance default
    ///   - size: size to use, exclude to use instance default
    ///   - randomizer: randomizer to use, exclude to use instance default
    public static func generate(
        alphabet: Alphabet = .default,
        size: UInt = 21,
        randomizer: Randomizer = defaultRandomizer
    ) -> String {
        return String(randomizer.getCharacters(count: size, from: alphabet))
    }
    
    #if canImport(Security)
    public static var defaultRandomizer: Randomizer = SecureRandomizer()
    #else
    public static var defaultRandomizer: Randomizer = IntRandomizer()
    #endif
}

extension NanoID {
    public struct Alphabet {
        let characters: [Character]
        
        public var size: Int {
            return characters.count
        }
        
        /// ReerKit: Initializes an alphabet given one or more strings
        /// - Parameter alphabet: Strings to build the alphabet from
        public init(_ alphabet: String...) {
            self.characters = Array(alphabet.joined())
        }
        
        /// Returns a single character from the alphabet
        ///
        /// - Parameter index: The position of the character to return
        public func character(at index: Int) -> Character {
            return self.characters[index]
        }
        
        /// Returns a single character from the alphabet given a byte
        ///
        /// - Parameter byte: The byte used to determine the character's position
        public func character(from byte: UInt8) -> Character {
            return self.characters[Int(byte) % self.characters.count]
        }
        
        public static let numbers = Self(numbersString)
        public static let lowercaseLetters = Self(lowercaseLettersString)
        public static let uppercaseLetters = Self(uppercaseLettersString)
        public static let letters = Self(lowercaseLettersString, uppercaseLettersString)
        public static let `default` = Self(lowercaseLettersString, uppercaseLettersString, "_-")
        
        private static let numbersString = "0123456789"
        private static let lowercaseLettersString = "abcdefghijklmnopqrstuvwxyz"
        private static let uppercaseLettersString = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    }
}

public protocol Randomizer {
    func getCharacters(count: UInt, from alphabet: NanoID.Alphabet) -> [Character]
}

#if canImport(Security)
public struct SecureRandomizer: Randomizer {
    public func getCharacters(count: UInt, from alphabet: NanoID.Alphabet) -> [Character] {
        var bytes = [UInt8](repeating: 0, count: Int(count))
        let status = SecRandomCopyBytes(kSecRandomDefault, Int(count), &bytes)
        return status == errSecSuccess
            ? bytes.reduce(into: [Character]()) { $0.append(alphabet.character(from: $1)) }
            : []
    }
}
#endif

public struct IntRandomizer: Randomizer {
    public func getCharacters(count: UInt, from alphabet: NanoID.Alphabet) -> [Character] {
        return (0..<count).reduce(into: [Character]()) { acc, _ in
            let character = alphabet.character(at: Int.random(in: 0..<alphabet.size))
            acc.append(character)
        }
    }
}
