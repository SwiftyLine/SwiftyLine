//
//  CocoaPodsHelper.swift
//  SwiftyLine
//
//  Created by 吴双 on 2021/3/14.
//

import Foundation

let HELP_TAB = "    "

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
    
    struct Node {
        
        var subnodes = [Node]()
        
        var content: Content
        
        var _abbr = false
        var abbr: Bool {
            set {
                if _abbr || !newValue {
                    return
                }
                _abbr = newValue
                subnodes = subnodes.map({ (node) -> Node in
                    var _node = node
                    _node.abbr = newValue
                    return node
                })
            }
            get { _abbr }
        }
        
        
        var maxLength: Int {
            var maxLength = 0
            if subnodes.count > 0 {
                maxLength = subnodes.reduce(maxLength) { (result, node) -> Int in
                    return max(result, node.maxLength)
                }
            }
            var currentLength = 0
            switch content {
            case .root:
                currentLength = 0
            case .newline:
                currentLength = 0
            case .section(_, _):
                currentLength = 0
            case .commandUsage(_):
                currentLength = 0
            case .commandDetail(_):
                currentLength = 0
            case .subcommand(let left, _):
                return left.count + 2
            case .argument(_, let keyed, _):
                if self.abbr {
                    currentLength = keyed.count + 5
                } else {
                    currentLength = keyed.count + 2
                }
            }
            return max(currentLength, maxLength)
        }
        
        enum Content {
            case root
            case newline
            case section(String, Bool)
            case commandUsage([String])
            case commandDetail(String)
            case subcommand(String, String?)
            case argument(Character?, String, String?)
        }
    }
    
    let title = OperationString.Builder(style: [.underline])
    let green = OperationString.Builder(style: [.green])
    let blue = OperationString.Builder(style: [.blue])
    
    func usage(for command: CommandInfo) -> Node {
        var usageNode = Node(content: .section("Usage", true))
        usageNode.subnodes.append(Node(content: .commandUsage(command.keyPath)))
        if let help = command.help {
            usageNode.subnodes.append(Node(content: .commandDetail(help)))
        }
        
        return usageNode
    }
    
    func commands(for command: CommandInfo) -> Node? {
        var node: Node?
        if command.subcommands.count > 0 {
            var _node = Node(content: .section("Commands:", false))
            for subcmd in command.subcommands {
                _node.subnodes.append(Node(content: .subcommand(subcmd.key, subcmd.help)))
            }
            node = _node
        }
        return node
    }
    
    func require(for command: CommandInfo) -> Node? {
        var node: Node?
        let requires = command.arguments.filter { (argument) -> Bool in
            return argument.optional == false
        }
        
        if requires.count != 0 {
            var _node = Node(content: .section("Require:", false))
            for arg in requires {
                _node.subnodes.append(Node(content: .argument(arg.abbr, arg.key, arg.help)))
            }
            node = _node
        }
        
        return node
    }
    
    func options(for command: CommandInfo) -> Node? {
        var node: Node?
        let optionals = command.arguments.filter { (argument) -> Bool in
            return argument.optional
        }
        
        if optionals.count + command.flags.count > 0 {
            var _node = Node(content: .section("Options:", false))
            for arg in optionals {
                _node.subnodes.append(Node(content: .argument(arg.abbr, arg.key, arg.help)))
            }
            for flag in command.flags {
                _node.subnodes.append(Node(content: .argument(flag.abbr, flag.key, flag.help)))
            }
            node = _node
        }
        
        return node
    }
    
    func defaultFlags(for command: CommandInfo, optionsNode: Node?) -> Node {
        var node = Node(content: .section("Options:", false))
        if let lastNode = optionsNode {
            node = lastNode
            node.subnodes.append(Node(content: .newline))
        }
        for flag in FlagInfo.defaultFlags {
            node.subnodes.append(Node(content: .argument(nil, flag.key, flag.help)))
        }
        return node
    }
    
    public func helpBanner(for command: CommandInfo) -> String {
        
        var root = Node(content: .root)
        
        // Usage:
        root.subnodes.append(usage(for: command))
        
        // Commands:
        if let commands = commands(for: command) {
            root.subnodes.append(commands)
        }
        
        // Require:
        if let require = require(for: command) {
            root.subnodes.append(require)
        }
        
        // Options
        let optionsNode: Node? = options(for: command)
        
        // Default Flags
        let options = defaultFlags(for: command, optionsNode: optionsNode)
        root.subnodes.append(options)
        
        //        return sections.filter({ $0.count > 0 }).joined(separator: "\n")
        return toString(from: root, abbr: root.abbr, maxLength: root.maxLength)
    }
    
    func toString(from root: Node, abbr: Bool, maxLength: Int) -> String {
        var string = ""
        switch root.content {
        case .root:
            let lines = root.subnodes.map { (node) -> String in
                self.toString(from: node, abbr: abbr, maxLength: maxLength)
            }
            string = lines.joined(separator: "\n\n")
        case .newline:
            string = ""
        case .section(let title, let space):
            string = self.title.build(title).description
            let lines = root.subnodes.map { (node) -> String in
                self.toString(from: node, abbr: abbr, maxLength: maxLength)
            }
            string = string + "\n\n" + lines.joined(separator: space ? "\n\n" : "\n")
        case .commandUsage(let cmd):
            string = HELP_TAB + "$ " + self.green.build(cmd.joined(separator: " ")).description
        case .commandDetail(let detail):
            string = HELP_TAB + "  " + detail
        case .subcommand(let left, let right):
            string = HELP_TAB + green.build(toMaxLength("+ " + left, length: maxLength)).description + "   " + (right ?? "")
        case .argument(let _abbr, let keyed, let help):
            let abbrStr = abbr ? ((_abbr != nil) ? "-\(_abbr!)|" : "   ") : ""
            string = HELP_TAB + blue.build(toMaxLength(abbrStr + "--" + keyed, length: maxLength)).description + "   " + (help ?? "")
        }
        return string
    }
    
    func toMaxLength(_ string: String, length: Int) -> String {
        var str = string
        while str.count < length {
            str = str + " "
        }
        return str
    }
    
}
