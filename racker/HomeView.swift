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

struct Inning {
    var player : [PlayerInning] = [PlayerInning(), PlayerInning()]
}

struct Rack {
    var innings : Int = 0
    var winner : Int?
}

struct Player {
    var name : String = ""
    var sl : SkillLevel = SkillLevel.two
    var racks_won = 0
}

class Game : ObservableObject {
    @Published var players = [Player(), Player()]
    @Published var ready_to_start = false
    @Published var racks = [Rack]()
    @Published var innings = [Inning]()
    @Published var winner : Int?
    @Published var numPlayers : Int = 1
    @Published var gameType : GameType = GameType.None
    
    func reset() {
        ready_to_start = false
        players  = [Player(), Player()]
        racks = []
        innings = []
        winner = nil
        numPlayers = 1
        gameType = GameType.None
    }
}

struct HomeView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \GameData.in_progress, ascending: true)],
            animation: .default)
        private var items: FetchedResults<GameData>
    
    @State var startingNewGame = false
    @StateObject var data = Game()
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
    
    private let itemFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
