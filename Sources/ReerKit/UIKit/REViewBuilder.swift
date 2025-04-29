//
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

@resultBuilder
public struct REViewBuilder<V> {
    public static func buildBlock(_ components: [V]...) -> [V] {
        components.flatMap { $0 }
    }
    
    public static func buildArray(_ components: [[V]]) -> [V] {
        components.flatMap { $0 }
    }
    
    public static func buildOptional(_ component: [V]?) -> [V] {
        guard let component = component else {
            return []
        }
        return component
    }
    
    public static func buildEither(first component: [V]) -> [V] {
        component
    }
    
    public static func buildEither(second component: [V]) -> [V] {
        component
    }
    
    public static func buildExpression(_ expression: V) -> [V] {
        [expression]
    }
    
    public static func buildExpression(_ expression: V?) -> [V] {
        guard let expression = expression else {
            return []
        }
        return [expression]
    }
    
    public static func buildLimitedAvailability(_ component: [V]) -> [V] {
        component
    }
}
