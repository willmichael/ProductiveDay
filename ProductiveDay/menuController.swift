//
//  menuController.swift
//  ProductiveDay
//
//  Created by Michael Lee on 5/17/18.
//  Copyright © 2018 ProductiveMe. All rights reserved.
//

import Cocoa

class menuController: NSObject, NSUserNotificationCenterDelegate {

    @IBOutlet weak var menu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    let pom: PomodoroModel
    var timer = Timer()
    let timeModel: TimerModel
    let focusModel = FocusModel()

    override func awakeFromNib() {
        statusItem.menu = menu
        let icon = NSImage(named: NSImage.Name(rawValue: "statusIcon"))
        icon?.isTemplate = true
        statusItem.button?.image = icon
        statusItem.button?.imagePosition = .imageRight
        NSWorkspace.shared.notificationCenter.addObserver(self,
                                                          selector: #selector(appChanged),
                                                          name: NSWorkspace.didActivateApplicationNotification,
                                                          object: nil)
    }

    override init() {
        self.pom = PomodoroModel()
        self.timeModel = TimerModel(pom: self.pom)

    }

    @IBAction func quitPressed(_ sender: NSMenuItem) {

        focusModel.stopTracking()

        NSApplication.shared.terminate(self)
    }

    @IBAction func pausePressed(_ sender: Any) {
        if (self.timeModel.tstate == .running) {

            focusModel.pauseTracking()
            
            timer.invalidate()
            self.timeModel.tstate = .paused
        }
    }

    @IBAction func startPressed(_ sender: Any) {
        if (self.timeModel.tstate == .paused) {

            focusModel.startTracking()

            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            self.timeModel.tstate = .running
        }
    }

    @objc func appChanged() {
        if self.focusModel.isTracking()
        {
            print("change")
            self.focusModel.trackChange()
        }
    }

    func timerNotification() -> Void {
        let notification = NSUserNotification()
        if self.timeModel.isWorking {
            notification.title = "Time For Work"
            notification.actionButtonTitle = "Start Work"

        } else {
            notification.title = "Time For a Break"
            notification.actionButtonTitle = "Start Break"

        }
        notification.soundName = NSUserNotificationDefaultSoundName

        let extendAction = NSUserNotificationAction(identifier: "extend", title: "Extend Time Instead")
        notification.additionalActions = [extendAction]
        NSUserNotificationCenter.default.delegate = self
        NSUserNotificationCenter.default.deliver(notification)
    }

    // Always disply even if app is in forground
    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        return true
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        if let id = notification.additionalActivationAction?.identifier {
            switch id {
            case "extend":
                self.timeModel.extendTime()
                self.startPressed(self)
            default:
                break
                // should never hit here
            }
        } else {
            timeModel.updateTimeModel()

            focusModel.outputState()
            focusModel.saveState()
            focusModel.resetState()

            self.startPressed(self)
        }
    }

    @objc func updateTimer() {
        if(timeModel.timeLeft > 0) {
            timeModel.timeLeft -= 1
            self.statusItem.button?.title = timeModel.getTimeLeftString()
        } else if(timeModel.timeLeft == 0) {
            self.timeModel.tstate = .paused
            timer.invalidate()
            timerNotification()
        }
    }
}

