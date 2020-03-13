//
//  LPNetdiag.swift
//  LPNetdiag
//
//  Created by pengli on 2019/11/26.
//  Copyright © 2019 pengli. All rights reserved.
//

import Foundation

public class LPNetdiag {
    public static let shared = { return LPNetdiag() }()
    
    /// 网络信息管理
    public private(set) lazy var netInfo = LPNetInfo()
    
    
    
}
