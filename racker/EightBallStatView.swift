//
//  EightBallStatView.swift
//  racker
//
//  Created by Kyle Nahrgang on 2/12/22.
//

import SwiftUI

struct EightBallPlayerStatistics {
    var inningsPerWin : Double = 0
    var timePerInning : TimeInterval = 0
}

struct EightBallStatView: View {
    @ObservedObject var data : GameData
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        LazyVStack {
            LazyVStack {
            if (data.winner != nil) {
                //Text("\(data.players[data.winner!].name) has won!")
            }
            }.frame(height: screenSize.height / 4)
            
            LazyVStack {
                ForEach(0..<data.numPlayers, id: \.self) { idx in
                    Text("Player \(idx) Statistics:")
                    
                    LazyHStack {
                        Text("Racks won:").frame(width:screenSize.width / 3, alignment: .leading)
                        Text(String(data.players[idx].racks_won)).frame(width:screenSize.width / 3, alignment: .trailing)
                    }
                    
                    LazyHStack {
                        Text("Innings Per Win:").frame(width:screenSize.width / 3, alignment: .leading)
                        Text(String(getPlayerInningsPerWin(idx:idx))).frame(width:screenSize.width / 3, alignment: .trailing)
                    }
                    
                    LazyHStack {
                        Text("Time Per Inning:").frame(width:screenSize.width / 3, alignment: .leading)
                        Text(String(getPlayerTimePerInning(idx: idx))).frame(width:screenSize.width / 3, alignment: .trailing)
                    }
                    
                }
            }.frame(height: screenSize.height / 2, alignment: .top)
        }
    }
    
    func getPlayerInningsPerWin(idx: Int) -> Double {
        var totalInningsWon = 0
        
        if data.players[idx].racks_won == 0 {
            return 0
        }
        
        for rackIdx in 0..<data.racks.count {
            if data.racks[rackIdx].winner! != idx {
               totalInningsWon += data.racks[rackIdx].innings
            }
        }

        return Double(totalInningsWon / data.players[idx].racks_won)
    }
    
    func getPlayerTimePerInning(idx: Int) -> Double {
        var totalSeconds : TimeInterval = 0
        
        if data.players[idx].racks_won == 0 {
            return 0
        }
        
        for inningIdx in 0..<data.innings.count {
            if ((data.innings[inningIdx].player[idx].start != nil) && (data.innings[inningIdx].player[idx].end != nil)) {
                totalSeconds += data.innings[inningIdx].player[idx].end!.timeIntervalSince( data.innings[inningIdx].player[idx].start!)
            }
        }
        
    
        return Double(totalSeconds) / Double(data.players[idx].racks_won)
    }
}

struct EightBallStatView_Previews: PreviewProvider {
    @State static var data = GameData()
    static var previews: some View {
        EightBallStatView(data: data)
    }
}
