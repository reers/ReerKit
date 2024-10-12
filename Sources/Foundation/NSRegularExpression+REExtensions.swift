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

#if canImport(Foundation)
import Foundation

public extension Reer where Base: NSRegularExpression {
    /// ReerKit: Enumerates the string allowing the Block to handle each regular expression match.
    ///
    /// - Parameters:
    ///   - string: The string.
    ///   - options: The matching options to report. See `NSRegularExpression.MatchingOptions` for the supported values.
    ///   - range: The range of the string to test.
    ///   - block: The Block enumerates the matches of the regular expression in the string.
    ///     The block takes three arguments and returns `Void`:
    ///   - result:
    ///     An `NSTextCheckingResult` specifying the match. This result gives the overall matched range via its `range` property, and the range of each individual capture group via its `range(at:)` method. The range {NSNotFound, 0} is returned if one of the capture groups did not participate in this particular match.
    ///   - flags:
    ///     The current state of the matching progress. See `NSRegularExpression.MatchingFlags` for the possible values.
    ///   - stop:
    ///     A reference to a Boolean value. The Block can set the value to true to stop further processing of the array. The stop argument is an out-only argument. You should only ever set this Boolean to true within the Block.
    func enumerateMatches(
        in string: String,
        options: NSRegularExpression.MatchingOptions = [],
        range: Range<String.Index>,
        using block: (_ result: NSTextCheckingResult?, _ flags: NSRegularExpression.MatchingFlags, _ stop: inout Bool) -> Void
    ) {
        base.enumerateMatches(
            in: string,
            options: options,
            range: NSRange(range, in: string)
        ) { result, flags, stop in
            var shouldStop = false
            block(result, flags, &shouldStop)
            if shouldStop {
                stop.pointee = true
            }
        }
    }

    /// ReerKit: Returns an array containing all the matches of the regular expression in the string.
    ///
    /// - Parameters:
    ///   - string: The string to search.
    ///   - options: The matching options to use. See NSRegularExpression.MatchingOptions for possible values.
    ///   - range: The range of the string to search.
    /// - Returns: An array of `NSTextCheckingResult` objects. Each result gives the overall matched range via its `range` property, and the range of each individual capture group via its `range(at:)` method. The range {NSNotFound, 0} is returned if one of the capture groups did not participate in this particular match.
    func matches(
        in string: String,
        options: NSRegularExpression.MatchingOptions = [],
        range: Range<String.Index>
    ) -> [NSTextCheckingResult] {
        return base.matches(
            in: string,
            options: options,
            range: NSRange(range, in: string)
        )
    }

    /// ReerKit: Returns the number of matches of the regular expression within the specified range of the string.
    ///
    /// - Parameters:
    ///   - string: The string to search.
    ///   - options: The matching options to use. See NSRegularExpression.MatchingOptions for possible values.
    ///   - range: The range of the string to search.
    /// - Returns: The number of matches of the regular expression.
    func numberOfMatches(
        in string: String,
        options: NSRegularExpression.MatchingOptions = [],
        range: Range<String.Index>
    ) -> Int {
        return base.numberOfMatches(
            in: string,
            options: options,
            range: NSRange(range, in: string)
        )
    }

    /// ReerKit: Returns the first match of the regular expression within the specified range of the string.
    ///
    /// - Parameters:
    ///   - string: The string to search.
    ///   - options: The matching options to use. See `NSRegularExpression.MatchingOptions` for possible values.
    ///   - range: The range of the string to search.
    /// - Returns: An `NSTextCheckingResult` object. This result gives the overall matched range via its `range` property, and the range of each individual capture group via its `range(at:)` method. The range {NSNotFound, 0} is returned if one of the capture groups did not participate in this particular match.
    func firstMatch(
        in string: String,
        options: NSRegularExpression.MatchingOptions = [],
        range: Range<String.Index>
    ) -> NSTextCheckingResult? {
        return base.firstMatch(
            in: string,
            options: options,
            range: NSRange(range, in: string)
        )
    }

    /// ReerKit: Returns the range of the first match of the regular expression within the specified range of the string.
    ///
    /// - Parameters:
    ///   - string: The string to search.
    ///   - options: The matching options to use. See `NSRegularExpression.MatchingOptions` for possible values.
    ///   - range: The range of the string to search.
    /// - Returns: The range of the first match. Returns `nil` if no match is found.
    func rangeOfFirstMatch(
        in string: String,
        options: NSRegularExpression.MatchingOptions = [],
        range: Range<String.Index>
    ) -> Range<String.Index>? {
        return Range(base.rangeOfFirstMatch(in: string, options: options, range: NSRange(range, in: string)), in: string)
    }

    /// ReerKit: Returns a new string containing matching regular expressions replaced with the template string.
    ///
    /// - Parameters:
    ///   - string: The string to search for values within.
    ///   - options: The matching options to use. See `NSRegularExpression.MatchingOptions` for possible values.
    ///   - range: The range of the string to search.
    ///   - templ: The substitution template used when replacing matching instances.
    /// - Returns: A string with matching regular expressions replaced by the template string.
    func stringByReplacingMatches(
        in string: String,
        options: NSRegularExpression.MatchingOptions = [],
        range: Range<String.Index>,
        withTemplate templ: String
    ) -> String {
        return base.stringByReplacingMatches(
            in: string,
            options: options,
            range: NSRange(range, in: string),
            withTemplate: templ
        )
    }

    /// ReerKit: Replaces regular expression matches within the mutable string using the template string.
    ///
    /// - Parameters:
    ///   - string: The mutable string to search and replace values within.
    ///   - options: The matching options to use. See `NSRegularExpression.MatchingOptions` for possible values.
    ///   - range: The range of the string to search.
    ///   - templ: The substitution template used when replacing matching instances.
    /// - Returns: The number of matches.
    @discardableResult
    func replaceMatches(
        in string: inout String,
        options: NSRegularExpression.MatchingOptions = [],
        range: Range<String.Index>,
        withTemplate templ: String
    ) -> Int {
        let mutableString = NSMutableString(string: string)
        let matches = base.replaceMatches(
            in: mutableString,
            options: options,
            range: NSRange(range, in: string),
            withTemplate: templ)
        string = mutableString.copy() as! String
        return matches
    }
}

#endif
