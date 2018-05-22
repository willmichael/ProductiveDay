//
//  Timer.swift
//  ProductiveDay
//
//  Created by Michael Lee on 5/18/18.
//  Copyright © 2018 ProductiveMe. All rights reserved.
//

import Foundation

class TimerModel {

    var tstate: state = .paused
    var pom: PomodoroModel
    var timeLeft: Int
    var isWorking: Bool

    init(pom: PomodoroModel) {
        self.pom = pom
        self.isWorking = true
        self.timeLeft = pom.workTime
    }

    func getTimeLeftString() -> String {
        let minutes = self.timeLeft / 60
        let seconds = self.timeLeft % 60
        return String(format:"%02d:%02d", minutes, seconds)
    }

    func updateTimeModel() {
        self.isWorking = !self.isWorking
        if self.isWorking {
            self.timeLeft = self.pom.workTime
        } else {
            if self.pom.workStreak == 4 {
                self.timeLeft = self.pom.breakTime * 3
            } else {
                self.timeLeft = self.pom.breakTime
            }
        }
        self.pom.workStreak += 1
    }

    func extendTime() {
        self.timeLeft += pom.extendTime
    }

    enum state {
        case paused
        case running
    }
    
}
