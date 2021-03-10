//
//  Mirror+SwiftyLine.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/10.
//

import Foundation

extension Mirror {
    
    func child(label: String) -> Mirror.Child? {
        let children = self.children.filter { $0.label! == "_\(label)" }
        return children.first
    }
    
    mutating func set(key: String, value: String) {
        children.forEach { (child) in
            if child.label! == "_\(key)" {
                if var arg = child.value as? arg {
                    arg.value = value
                }
            }
        }
    }
    
}
