//
//  Info.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/2/28.
//

import Foundation

public protocol HelpProvider {
    
    func helpBanner(for command: CommandInfo) -> String
    
}

public struct Helper {
    
    private static var shared: HelpProvider?
    
    public static var current: HelpProvider {
        get { shared ?? CocoaPodsHelper() }
        set { shared = newValue }
    }
    
    public static func printBanner(for command: CommandInfo) {
        let string = current.helpBanner(for: command)
        print(string)
    }
}
