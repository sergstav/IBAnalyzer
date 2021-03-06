//
//  main.swift
//  IBAnalyzer
//
//  Created by Arkadiusz Holko on 24-12-16.
//  Copyright © 2016 Arkadiusz Holko. All rights reserved.
//

import Foundation
import AppKit

let isInUnitTests = NSClassFromString("XCTest") != nil

if !isInUnitTests {
    do {
        let args = ProcessInfo.processInfo.arguments
        guard args.count > 1 else {
            print("Please provide a project path as a first argument.")
            exit(1)
        }

        let path = args[1]
        let url = URL(fileURLWithPath: args[1], relativeTo: URL(fileURLWithPath: args[0]))

        guard FileManager.default.fileExists(atPath: url.path) else {
            print("Path \(url.path) doesn't exist.")
            exit(1)
        }

        let runner = Runner(path: url.path)
        let issues = try runner.issues(using: [ConnectionAnalyzer()])
        for issue in issues {
            print(issue)
        }
    } catch let error {
        print(error.localizedDescription)
        exit(1)
    }
} else {
    final class TestAppDelegate: NSObject, NSApplicationDelegate {
        let window = NSWindow()

        func applicationDidFinishLaunching(aNotification: NSNotification) {
            window.setFrame(CGRect(x: 0, y: 0, width: 0, height: 0), display: false)
            window.makeKeyAndOrderFront(self)
        }
    }

    // This is required for us to be able to run unit tests.
    autoreleasepool { () -> Void in
        let app = NSApplication.shared()
        let appDelegate = TestAppDelegate()
        app.delegate = appDelegate
        app.run()
    }
}
