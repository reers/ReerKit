//
//  Copyright © 2019 CoderMJLee
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

#if canImport(Darwin)
import Darwin

// https://github.com/CoderMJLee/Mems

public enum MemoryAlign: Int {
    case one = 1, two = 2, four = 4, eight = 8
}

public enum StringMemoryType: UInt8 {
    case text = 0xd0
    case taggedPointer = 0xe0
    case heap = 0xf0
    case unknow = 0xff
}

private let _EMPTY_PTR = UnsafeRawPointer(bitPattern: 0x1)!

/// ReerKit: Utilities for checking memory structure.
public struct Memory<T> {
    private static func string(
        _ pointer: UnsafeRawPointer,
        _ size: Int,
        _ alignment: Int
    ) -> String {
        if pointer == _EMPTY_PTR { return "" }
        
        var rawPointer = pointer
        var string = ""
        let fmt = "0x%0\(alignment << 1)lx"
        let count = size / alignment
        for i in 0..<count {
            if i > 0 {
                string.append(" ")
                rawPointer += alignment
            }
            let value: CVarArg
            switch alignment {
            case MemoryAlign.eight.rawValue:
                value = rawPointer.load(as: UInt64.self)
            case MemoryAlign.four.rawValue:
                value = rawPointer.load(as: UInt32.self)
            case MemoryAlign.two.rawValue:
                value = rawPointer.load(as: UInt16.self)
            default:
                value = rawPointer.load(as: UInt8.self)
            }
            string.append(String(format: fmt, value))
        }
        return string
    }
    
    private static func bytes(
        _ pointer: UnsafeRawPointer,
        _ size: Int
    ) -> [UInt8] {
        var array: [UInt8] = []
        if pointer == _EMPTY_PTR { return array }
        for i in 0..<size {
            array.append((pointer + i).load(as: UInt8.self))
        }
        return array
    }
    
    /// ReerKit: Get memory data for the variable in byte array format
    public static func bytes(ofVal v: inout T) -> [UInt8] {
        return bytes(pointer(ofVal: &v), MemoryLayout.stride(ofValue: v))
    }

    /// ReerKit: Get the memory data pointed to by the reference in byte array format.
    public static func bytes(ofRef v: T) -> [UInt8] {
        let p = pointer(ofRef: v)
        return bytes(p, malloc_size(p))
    }
    
    /// ReerKit: Get memory data for the variable in string format
    /// 
    /// - Parameter alignment: Represent how many bytes are grouped together
    /// - Parameter v: The value type value.
    /// - Returns: Get memory data.
    public static func string(ofVal v: inout T, alignment: MemoryAlign? = nil) -> String {
        let p = pointer(ofVal: &v)
        return string(
            p,
            MemoryLayout.stride(ofValue: v),
            alignment != nil ? alignment!.rawValue : MemoryLayout.alignment(ofValue: v)
        )
    }
    
    /// ReerKit: Get the memory data pointed to by the reference in string format
    ///
    /// - Parameter alignment: Represent how many bytes are grouped together
    /// - Parameter v: The reference type value
    /// - Returns: Get memory data.
    public static func string(ofRef v: T, alignment: MemoryAlign? = nil) -> String {
        let p = pointer(ofRef: v)
        return string(
            p,
            malloc_size(p),
            alignment != nil ? alignment!.rawValue : MemoryLayout.alignment(ofValue: v)
        )
    }
    
    /// ReerKit: Get the memory address of the variable
    public static func pointer(ofVal v: inout T) -> UnsafeRawPointer {
        return MemoryLayout.size(ofValue: v) == 0 ? _EMPTY_PTR : withUnsafePointer(to: &v) {
            UnsafeRawPointer($0)
        }
    }
    
    /// ReerKit: Get the address of the memory pointed to by the reference
    public static func pointer(ofRef v: T) -> UnsafeRawPointer {
        if v is Array<Any>
            || Swift.type(of: v) is AnyClass
            || v is AnyClass {
            return UnsafeRawPointer(bitPattern: unsafeBitCast(v, to: UInt.self))!
        } else if v is String {
            var mstr = v as! String
            if mstr.re.memoryType() != .heap {
                return _EMPTY_PTR
            }
            return UnsafeRawPointer(bitPattern: unsafeBitCast(v, to: (UInt, UInt).self).1)!
        } else {
            return _EMPTY_PTR
        }
    }
    
    /// ReerKit: Get the memory size occupied by the variable
    public static func size(ofVal v: inout T) -> Int {
        return MemoryLayout.size(ofValue: v) > 0 ? MemoryLayout.stride(ofValue: v) : 0
    }
    
    /// ReerKit: Get the size of the memory pointed to by the reference
    public static func size(ofRef v: T) -> Int {
        return malloc_size(pointer(ofRef: v))
    }
}

public extension ReerReference where Base == String {
    mutating func memoryType() -> StringMemoryType {
        let pointer = Memory.pointer(ofVal: &base)
        return StringMemoryType(rawValue: (pointer + 15).load(as: UInt8.self) & 0xf0)
            ?? StringMemoryType(rawValue: (pointer + 7).load(as: UInt8.self) & 0xf0)
            ?? .unknow
    }
}

#endif
