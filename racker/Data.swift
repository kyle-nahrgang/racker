//
//  Data.swift
//  racker
//
//  Created by Kyle Nahrgang on 2/11/22.
//

import Foundation
import SwiftUI

enum SkillLevel {
    case two, three, four, five, six, seven
}


struct PlayerData {
    var name: String?
    var sl: SkillLevel?
}

struct InningData {
    var player_one_begin: Date?
    var player_one_end: Date?
    var player_two_begin: Date?
    var player_two_end: Date?
    
}

struct RackData {
    var innings: [InningData?]
    var winner: PlayerData?
}

struct GameData {
    var player_one: PlayerData?
    var player_two: PlayerData?
    var racks : [RackData]?
    
}
