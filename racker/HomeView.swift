//
//  ContentView.swift
//  racker
//
//  Created by Kyle Nahrgang on 2/11/22.
//

import SwiftUI

enum SkillLevel : Int, CaseIterable {
    case two
    case three
    case four
    case five
    case six
    case seven
    
    var id : Int {
        self.rawValue
    }
    
    var description : String {
        get {
            switch self {
            case .two: return "2"
            case .three: return "3"
            case .four: return "4"
            case .five: return "5"
            case .six: return "6"
            case .seven: return "7"
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
}

struct HomeView: View {
    @State var startingNewGame = false
    @StateObject var data = GameData()
    
    var body: some View {
        if (data.ready_to_start) {
            GameView(data:data)
        } else {
            LazyVStack {
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