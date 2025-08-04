//
//  ConvertSecondsToMinutes.swift
//  CoachGG
//
//  Created by Gabriel on 01/08/25.
//

import Foundation

func convertSecondsToMinutes(_ seconds: Int) -> String {
    let minutes = seconds / 60
    let remainingSeconds = seconds % 60
    return String(format: "%02d:%02d", minutes, remainingSeconds)
}
