//
//  FocusModel.swift
//  ProductiveDay
//
//  Created by Michael Lee on 5/21/18.
//  Copyright © 2018 ProductiveMe. All rights reserved.
//

import Foundation
import Cocoa

class FocusModel {

    // Tracking Session Data
    var lastSessionSwitch: Date?
    var sessAppSwitchNum: Int
    var sessAppSwitched: [String]
    var sessAppTotalTime: [String:Double]

    // Bool Toggle
    private var trackSwitch: Bool

    init(sessAppSwitchNum: Int = 0, trackSwitch: Bool = false) {
        self.sessAppSwitchNum = sessAppSwitchNum
        self.trackSwitch = trackSwitch
        self.sessAppSwitched = []
        self.sessAppTotalTime = [:]
        self.lastSessionSwitch = nil
    }

    func trackChange() {
        let work = NSWorkspace.shared
        let currentApp = work.frontmostApplication

        if let prevApp = self.sessAppSwitched.last, let lastTime = self.lastSessionSwitch {
            let timeDiff = Date().timeIntervalSince(lastTime)
            // Record time spent in each app
            let oldVal = self.sessAppTotalTime[prevApp]
            self.sessAppTotalTime[prevApp] = timeDiff + (oldVal ?? 0.0)
        }

        if let curAppName = currentApp?.localizedName {
            self.sessAppSwitched.append(curAppName)
        }

        self.sessAppSwitchNum += 1
    }

    func isTracking() -> Bool {
        return self.trackSwitch
    }

    func outputState() {
        let totalTime = getTotalTime()
        for (app, time) in self.sessAppTotalTime {
            print(String(format: "App: %@ Percent: %.2f", app, time/totalTime))
        }
    }

    func getTotalTime() -> Double {
        var totalTime = 0.0
        for (_,time) in self.sessAppTotalTime {
            totalTime += time
        }
        return totalTime
    }

    func saveState() {
        // save
    }

    func resetState() {
        self.sessAppSwitchNum = 0
        self.trackSwitch = false
        self.sessAppSwitched = []
        self.sessAppTotalTime = [:]
        self.lastSessionSwitch = nil
    }

    func startTracking() {
        self.trackSwitch = true
        self.lastSessionSwitch = Date()
    }

    func pauseTracking() {
        self.trackSwitch = false
    }

    func stopTracking() {
        self.trackSwitch = false
        //save state
        //reset state
    }
}
