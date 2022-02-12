//
//  ContentView.swift
//  racker
//
//  Created by Kyle Nahrgang on 2/11/22.
//

import SwiftUI
import UIKit

enum SkillLevel : Int, CaseIterable {
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    
    var id : Int {
        self.rawValue
    }
    
    var description : String {
        get {
            switch self {
            case .one: return "1"
            case .two: return "2"
            case .three: return "3"
            case .four: return "4"
            case .five: return "5"
            case .six: return "6"
            case .seven: return "7"
            case .eight: return "8"
            case .nine: return "9"
            }
        }
    }

}

enum GameType : String, CaseIterable {
    case None
    case EightBall
    case NineBall
    
    var description : String {
        get {
            switch self {
            case .None: return "NONE"
            case .EightBall: return "8-Ball"
            case .NineBall: return "9-Ball"
            }
        }
    }
}
                    
struct PlayerInning {
    var start : Date?
    var end : Date?
}

struct InningData {
    var player : [PlayerInning] = [PlayerInning(), PlayerInning()]
}

struct RackData {
    var innings : Int = 0
    var winner : Int?
}

struct Player {
    var name : String = ""
    var sl : SkillLevel = SkillLevel.two
    var racks_won = 0
    var racks_needed = 06
}

class GameData : ObservableObject {
    @Published var players = [Player(), Player()]
    @Published var ready_to_start = false
    @Published var racks = [RackData]()
    @Published var innings = [InningData]()
    @Published var winner : Int?
    @Published var numPlayers : Int = 1
    @Published var gameType : GameType = GameType.None
}

struct HomeView: View {
    @State var startingNewGame = false
    @StateObject var data = GameData()
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        if (data.ready_to_start && (data.gameType == GameType.EightBall)) {
                EightBallView(data:data)

        } else {
            LazyVStack {
                Text("Racker").font(.title).frame(width: screenSize.width, height: screenSize.height / 2, alignment: Alignment.top)
                Button(action: {
                    self.startingNewGame = true
                }) {
                    Text("New Game")
                }.sheet(isPresented: $startingNewGame) {
                    NewGameView(data:data)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
