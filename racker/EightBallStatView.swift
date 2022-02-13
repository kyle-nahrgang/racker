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
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var data : Game
    let screenSize = UIScreen.main.bounds
    
    var body: some View {
        LazyVStack {
            LazyVStack {
            if (data.winner != nil) {
                Text("\(data.players[data.winner!].name) has won!")
            }
            }.frame(height: screenSize.height / 4)
            
            LazyVStack {
                ForEach(0..<data.numPlayers, id: \.self) { idx in
                    Text("\(data.players[idx].name) Statistics:")
                    
                    LazyHStack {
                        Text("Racks won:").frame(width:screenSize.width / 3, alignment: .leading)
                        Text(String(data.players[idx].racks_won)).frame(width:screenSize.width / 3, alignment: .trailing)
                    }
                    
                    LazyHStack {
                        Text("Innings won:").frame(width:screenSize.width / 3, alignment: .leading)
                        Text(String(getPlayerInningsWon(idx: idx))).frame(width:screenSize.width / 3, alignment: .trailing)
                    }
                    
                    LazyHStack {
                        Text("Innings Per Win:").frame(width:screenSize.width / 3, alignment: .leading)
                        Text(String(format: "%.1f", getPlayerInningsPerWin(idx:idx))).frame(width:screenSize.width / 3, alignment: .trailing)
                    }
                    
                    LazyHStack {
                        Text("Time Per Inning:").frame(width:screenSize.width / 3, alignment: .leading)
                        Text(String(format: "%.1f s", getPlayerTimePerInning(idx: idx))).frame(width:screenSize.width / 3, alignment: .trailing)
                    }
                    
                }
            }.frame(height: screenSize.height / 2, alignment: .top)
            
            Button(action: {
                data.reset()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Home").frame(width: screenSize.width * 4 / 5).padding()
            }.frame(height: screenSize.height / 6, alignment: .bottom).disabled(data.numPlayers == 0)
                .buttonStyle(BorderedButtonStyle())
        }
    }
    
    func getPlayerInningsWon(idx: Int) -> Int {
        var totalInningsWon = 0
        
        if data.players[idx].racks_won == 0 {
            return 0
        }
        
        if data.numPlayers == 1 {
            return data.innings.count
        }

        for rackIdx in 0..<data.racks.count {
            if data.racks[rackIdx].winner! != idx {
                totalInningsWon += data.racks[rackIdx].innings
            }
        }
        return totalInningsWon
    }

    func getPlayerInningsPerWin(idx: Int) -> Double {
        let totalInningsWon = getPlayerInningsWon(idx: idx)
        if (totalInningsWon > 0) {
            return Double(totalInningsWon) / Double(data.players[idx].racks_won)
        } else {
            return 0
        }
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
    @State static var data = Game()
    static var previews: some View {
        EightBallStatView(data: data)
    }
}
