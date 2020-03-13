//
//  LPFDSet.swift
//  LPNetdiagDemo
//
//  Created by pengli on 2019/11/28.
//  Copyright © 2019 pengli. All rights reserved.
//

import Darwin

// __DARWIN_FD_SETSIZE is number of *bits*, so divide by number bits in each element to get element count at present this is 1024 / 32 == 32
private let lp_fd_set_count = Int(__DARWIN_FD_SETSIZE) / 32
extension fd_set {
    @inline(__always)
    mutating func lp_withCArrayAccess<T>(block: (UnsafeMutablePointer<Int32>) throws -> T) rethrows -> T {
        return try withUnsafeMutablePointer(to: &fds_bits) {
            try block(UnsafeMutableRawPointer($0).assumingMemoryBound(to: Int32.self))
        }
    }
    
    @inline(__always)
    private static func lp_address(for fd: Int32) -> (Int, Int32) {
        var intOffset = Int(fd) / lp_fd_set_count
        #if _endian(big)
        if intOffset % 2 == 0 {
            intOffset += 1
        } else {
            intOffset -= 1
        }
        #endif
        let bitOffset = Int(fd) % lp_fd_set_count
        let mask = Int32(bitPattern: UInt32(1 << bitOffset))
        return (intOffset, mask)
    }
    
    /// 将fd_set归零（替换FD_ZERO宏）
    public mutating func lp_zero() {
        lp_withCArrayAccess { $0.initialize(repeating: 0, count: lp_fd_set_count) }
    }
    
    /// 在fd_set中设置一个fd（替换FD_SET宏）
    /// - Parameter fd:    要添加到fd_set的fd
    public mutating func lp_set(_ fd: Int32) {
        let (index, mask) = fd_set.lp_address(for: fd)
        lp_withCArrayAccess { $0[index] |= mask }
    }
    
    /// 从fd_set清除fd（替换FD_CLR宏）
    /// - Parameter fd:    从fd_set清除的fd
    public mutating func lp_clear(_ fd: Int32) {
        let (index, mask) = fd_set.lp_address(for: fd)
        lp_withCArrayAccess { $0[index] &= ~mask }
    }
    
    /// 检查fd_set中是否存在fd（替换FD_ISSET宏）
    public mutating func lp_isSet(_ fd: Int32) -> Bool {
        let (index, mask) = fd_set.lp_address(for: fd)
        return lp_withCArrayAccess { $0[index] & mask != 0 }
    }
}
