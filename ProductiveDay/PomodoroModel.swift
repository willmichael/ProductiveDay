//
//  PomodoroModel.swift
//  ProductiveDay
//
//  Created by Michael Lee on 5/18/18.
//  Copyright © 2018 ProductiveMe. All rights reserved.
//

import Foundation

struct PomodoroModel {

    let workTime, breakTime, lookAway, standUp, extendTime: Int
    var workStreak: Int

    init(workTime: Int = 1, breakTime: Int = 0, workStreak: Int = 0, lookAway: Int = 15, standUp: Int = 60, extendTime: Int = 5) {
        self.workTime = workTime * 60
        self.breakTime = breakTime * 60
        self.workStreak = workStreak
        self.lookAway = lookAway * 60
        self.standUp = standUp * 60
        self.extendTime = extendTime * 60
    }

}
