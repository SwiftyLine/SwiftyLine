//
//  CocoaPodsHelper.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/14.
//

import Foundation

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

public struct CocoaPodsHelper: HelpProvider {
    
    struct Table {
        
        struct Row {
            var cols: [String]
            var key: String {
                get { cols.first! }
                set { cols[0] = newValue }
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
        
        mutating func append(key: String, value: String? = nil) {
            self.append(row: Row(cols: [key, value ?? ""]))
        }
    }
    
    let title = OperationString.Builder(style: [.underline])
    let green = OperationString.Builder(style: [.green])
    let blue = OperationString.Builder(style: [.blue])
    
    func usage(for command: CommandInfo) -> String {
        let keyPath = command.keyPath.joined(separator: " ")
        
        var string = ""
        string.appendln(title.build("Usage:"))
        string.appendln()
        string.appendln("    $ \(green.build(keyPath))")
        if let help = command.help {
            string.appendln()
            string.appendln("    \(help)")
        }
        return string
    }
    
    func commands(for command: CommandInfo) -> String {
        var string = ""
        if command.subcommands.count > 0 {
            string.appendln(title.build("Commands:"))
            string.appendln()
            var table = Table()
            for subcmd in command.subcommands {
                table.append(key: subcmd.key)
            }
            table.rows.forEach { (row) in
                var key = row.key
                key.append(count: table.maxCount)
                let value = row.value
                string.appendln("    \(green.build("+ " + key))   \(value)")
            }
        }
        return string
    }
    
    func require(for command: CommandInfo) -> String {
        var string = ""
        let requires = command.arguments.filter { (argument) -> Bool in
            return argument.optional == false
        }
        
        if requires.count != 0 {
            string.appendln(title.build("Require:"))
            string.appendln()
            var containsAbbr = false
            var table = Table()
            for arg in requires {
                var key = ""
                if let abbr = arg.abbr {
                    containsAbbr = true
                    key.append("-\(abbr)|")
                } else {
                    key.append("   ")
                }
                key.append("--\(arg.key)")
                table.append(key: key, value: arg.help)
            }
            table.rows.forEach { (row) in
                var key = row.key
                key.append(count: table.maxCount)
                string.appendln(" \(containsAbbr ? "   " : "")\(blue.build(key))   \(row.value)")
            }
        }
        
        return string
    }
    
    func options(for command: CommandInfo) -> String {
        var string = ""
        let optionals = command.arguments.filter { (argument) -> Bool in
            return argument.optional
        }
        
        string.appendln(title.build("Options:"))
        
        if optionals.count + command.flags.count > 0 {
            var containsAbbr = false
            var table = Table()
            
            string.appendln()
            for arg in optionals {
                var key = ""
                if let abbr = arg.abbr {
                    containsAbbr = true
                    key.append("-\(abbr)|")
                } else {
                    key.append("   ")
                }
                key.append("--\(arg.key)")
                table.append(key: key, value: arg.help)
            }
            for flag in command.flags {
                var key = ""
                if let abbr = flag.abbr {
                    containsAbbr = true
                    key.append("-\(abbr)|")
                } else {
                    key.append("   ")
                }
                key.append("--\(flag.key)")
                table.append(key: key, value: flag.help)
            }
            table.rows.forEach { (row) in
                var key = row.key
                key.append(count: table.maxCount)
                string.appendln(" \(containsAbbr ? "   " : "")\(blue.build(key))   \(row.value)")
            }
        }
        
        return string
    }
    
    func defaultFlags(for command: CommandInfo) -> String {
        var string = ""
        var table = Table()
        for flag in FlagInfo.defaultFlags {
            let key = "--\(flag.key)"
            table.append(key: key, value: flag.help)
        }
        table.rows.forEach { (row) in
            var key = row.key
            key.append(count: table.maxCount)
            string.appendln("    \(blue.build(key))   \(row.value)")
        }
        return string
    }
    
    public func helpBanner(for command: CommandInfo) -> String {
        
        var sections = [String]()
        
        // Usage:
        sections.append(usage(for: command))
        
        // Commands:
        sections.append(commands(for: command))
        
        // Require:
        sections.append(require(for: command))
        
        // Options
        sections.append(options(for: command))
        
        // Default Flags
        sections.append(defaultFlags(for: command))
        
        return sections.filter({ $0.count > 0 }).joined(separator: "\n")
    }
    
}
