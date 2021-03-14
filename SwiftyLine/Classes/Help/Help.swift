//
//  Info.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/2/28.
//

import Foundation

public protocol Helper {
    
    func helpBanner(for command: CommandInfo) -> String
    
}

var shared: Helper?

public struct CommandHelper {
    
    static var shared: Helper?
    
    public static var current: Helper {
        get {
            return shared ?? PodHelper()
        }
        set {
            shared = newValue
        }
    }
    
    public static func printBanner(for command: CommandInfo) {
        let string = current.helpBanner(for: command)
        print(string)
    }
}

extension String {
    
    mutating func appendln(_ string: CustomStringConvertible = "") {
        self.append("\(string)")
        self.append("\n")
    }
    
    mutating func append(character: Character = " ", count: Int) {
        while self.count < count {
            self.append(character)
        }
    }
}

public struct PodHelper: Helper {
    
    struct Table {
        
        struct Row {
            var cols: [String]
            var key: String {
                get { cols.first! }
                set {
                    cols[0] = newValue
                }
            }
            var value: String {
                get { cols.last! }
                set { cols[1] = newValue }
            }
        }
        var rows: [Row] = []
        
        var maxCount = 0
        
        mutating func append(row: Row) {
            rows.append(row)
            if let count = row.cols.first?.count {
                if count > maxCount {
                    maxCount = count
                }
            }
        }
        
        mutating func append(cols: [String]) {
            self.append(row: Row(cols: cols))
        }
        
    }
    
    public func helpBanner(for command: CommandInfo) -> String {
        let green = OperationString.Builder(style: [.green])
        let blue = OperationString.Builder(style: [.blue])
        
        let keyPath = command.keyPath.joined(separator: " ")
        
        var string = ""
        string.appendln("Usage:".underline)
        string.appendln()
        string.appendln("    $ \(green.build(keyPath))")
        string.appendln()
        if let help = command.help {
            string.appendln("    \(help)")
            string.appendln()
        }
        if command.subcommands.count > 0 {
            string.appendln("Commands:".underline)
            string.appendln()
            var table = Table()
            for subcmd in command.subcommands {
                table.append(cols: [subcmd.key, subcmd.help ?? ""])
            }
            table.rows.forEach { (row) in
                var key = row.key
                key.append(count: table.maxCount)
                let value = row.value
                string.appendln("    \(green.build("+ " + key))   \(value)")
            }
            string.appendln()
        }
        if command.arguments.count + command.flags.count > 0 {
            var args = [ArgumentInfo]()
            var opts = [ArgumentInfo]()
            let flgs = command.flags
            
            for argument in command.arguments {
                if argument.optional {
                    opts.append(argument)
                } else {
                    args.append(argument)
                }
            }
            
            if args.count != 0 {
                string.appendln("Require:".underline)
                string.appendln()
                var containsAbbr = false
                var table = Table()
                for arg in args {
                    var key = ""
                    if let abbr = arg.abbr {
                        containsAbbr = true
                        key.append("-\(abbr)|")
                    } else {
                        key.append("   ")
                    }
                    key.append("--\(arg.key)")
                    let value = arg.help ?? ""
                    table.append(cols: [key, value])
                }
                table.rows.forEach { (row) in
                    var key = row.key
                    key.append(count: table.maxCount)
                    string.appendln(" \(containsAbbr ? "   " : "")\(blue.build(key))   \(row.value)")
                }
                string.appendln()
            }
            if opts.count + flgs.count > 0 {
                string.appendln("Options:".underline)
                string.appendln()
                var containsAbbr = false
                var table = Table()
                for arg in opts {
                    var key = ""
                    if let abbr = arg.abbr {
                        containsAbbr = true
                        key.append("-\(abbr)|")
                    } else {
                        key.append("   ")
                    }
                    key.append("--\(arg.key)")
                    let value = arg.help ?? ""
                    table.append(cols: [key, value])
                }
                for flag in flgs {
                    var key = ""
                    if let abbr = flag.abbr {
                        containsAbbr = true
                        key.append("-\(abbr)|")
                    } else {
                        key.append("   ")
                    }
                    key.append("--\(flag.key)")
                    let value = flag.help ?? ""
                    table.append(cols: [key, value])
                }
                table.rows.forEach { (row) in
                    var key = row.key
                    key.append(count: table.maxCount)
                    string.appendln(" \(containsAbbr ? "   " : "")\(blue.build(key))   \(row.value)")
                }
                string.appendln()
                
            }
        }
        return string
    }
    
}
