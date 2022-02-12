//
//  GameView.swift
//  racker
//
//  Created by Kyle Nahrgang on 2/11/22.
//

import SwiftUI

struct EightBallView: View {
    @ObservedObject var data : GameData
    @State var currentPlayer = 0
    @State var otherPlayer = 1
    @State var currentRack = 0
    @State var currentInning = 0
    
    let racks_required : [SkillLevel : [SkillLevel : Int]] = [
        SkillLevel.two : [
            SkillLevel.two : 2,
            SkillLevel.three : 2,
            SkillLevel.four : 2,
            SkillLevel.five : 2,
            SkillLevel.six : 2,
            SkillLevel.seven : 2
        ],
        SkillLevel.three : [
            SkillLevel.two : 3,
            SkillLevel.three : 2,
            SkillLevel.four : 2,
            SkillLevel.five : 2,
            SkillLevel.six : 2,
            SkillLevel.seven : 2
        ],
        SkillLevel.four : [
            SkillLevel.two : 4,
            SkillLevel.three : 3,
            SkillLevel.four : 3,
            SkillLevel.five : 3,
            SkillLevel.six : 3,
            SkillLevel.seven : 2
        ],
        SkillLevel.five : [
            SkillLevel.two : 5,
            SkillLevel.three : 4,
            SkillLevel.four : 4,
            SkillLevel.five : 4,
            SkillLevel.six : 4,
            SkillLevel.seven : 3
        ],
        SkillLevel.six : [
            SkillLevel.two : 6,
            SkillLevel.three : 5,
            SkillLevel.four : 5,
            SkillLevel.five : 5,
            SkillLevel.six : 5,
            SkillLevel.seven : 4
        ],
        SkillLevel.seven : [
            SkillLevel.two : 7,
            SkillLevel.three : 6,
            SkillLevel.four : 5,
            SkillLevel.five : 5,
            SkillLevel.six : 5,
            SkillLevel.seven : 5
        ]
    ]

    var body: some View {
        LazyVStack() {
            if (data.winner == nil) {
                Text("\(data.players[0].name) SL: \(data.players[0].sl.description)")
                if (data.players.count == 2) {
                    Text("vs")
                    Text("\(data.players[1].name) SL: \(data.players[1].sl.description)")
                }
                
                Text("Current Rack: \(data.racks.count)")
                Text("Current Inning: \(currentInning)")
                
                Button(action: {
                    endPlayerTurn()
                }) {
                    Text("End \(data.players[currentPlayer].name)'s turn")
                }
                
                Button(action: {
                    endRack()
                }) {
                    Text("\(data.players[currentPlayer].name) won rack")
                }
            }
            else {
                Text("\(data.players[data.winner.unsafelyUnwrapped].name) has won!")
            }
        }
    }
    
    func endPlayerTurn() {
        data.innings[currentInning].player[currentPlayer].end = Date.now
        if (currentPlayer == 0) {
            currentPlayer = 1
            otherPlayer = 0
        } else {
            data.racks[currentRack].innings += 1
            data.innings.append(InningData())
            currentInning += 1
            currentPlayer = 0
            otherPlayer = 1
        }
        data.innings[currentInning].player[currentPlayer].start = Date.now
    }
    
    func endRack() {
        data.racks[currentRack].winner = currentPlayer
        data.players[currentPlayer].racks_won += 1
        
        if data.players[currentPlayer].racks_won == racks_required[data.players[currentPlayer].sl].unsafelyUnwrapped[data.players[otherPlayer].sl] {
            data.winner = currentPlayer

        } else {
            data.racks.append(RackData())
            currentRack += 1
        }
    }
    
}

struct EightBallView_Previews: PreviewProvider {
    @StateObject static var data = GameData()
    static var previews: some View {
        EightBallView(data: data)
    }
}