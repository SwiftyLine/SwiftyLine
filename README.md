# SwiftyLine

[![CI Status](https://img.shields.io/travis/Magic-Unique/SwiftyLine.svg?style=flat)](https://travis-ci.org/Magic-Unique/SwiftyLine)
[![Version](https://img.shields.io/cocoapods/v/SwiftyLine.svg?style=flat)](https://cocoapods.org/pods/SwiftyLine)
[![License](https://img.shields.io/cocoapods/l/SwiftyLine.svg?style=flat)](https://cocoapods.org/pods/SwiftyLine)
[![Platform](https://img.shields.io/cocoapods/p/SwiftyLine.svg?style=flat)](https://cocoapods.org/pods/SwiftyLine)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

SwiftyLine is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'SwiftyLine'
```

## Usage

### 1. Construct Command & Parse Argument

```swift
import SwiftyLine

struct MyCommand: Command {
    mutating run() throws -> Int {
        // do your job
        print("Hello SwiftyLine.\n")
        return 0
    }
}

MyCommand.main()

// In Shell:
//
// % my-command
// Hello SwiftyLine.
//
```

### 2. Subcommand

```swift
import SwiftyLine

struct MyCommand: Command {

    static configuration: CommandConfiguration {
        var configuration = CommandConfiguration()
        configuration.subcommands = [MySubcommand.self]
        return configuration
    }

    mutating run() throws -> Int {
        // do your job
        print("Hello SwiftyLine.\n")
        return 0
    }
}

struct MySubcommand: Command {
    mutating run() throws -> Int {
        print("Hello subcommand.\n")
        return 0
    }
}

MyCommand.main()

// In Shell:
//
// % my-command
// Hello SwiftyLine.
//
// % my-command my-subcommand
// Hello subcommand.
//
```

## Author

Magic-Unique, 516563564@qq.com

## License

SwiftyLine is available under the MIT license. See the LICENSE file for more info.
