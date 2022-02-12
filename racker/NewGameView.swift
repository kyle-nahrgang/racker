//
//  NewGameView.swift
//  racker
//
//  Created by Kyle Nahrgang on 2/11/22.
//

import SwiftUI

struct NewGameView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var data : GameData
    
    let PlayerNumbers : [Int] = [1, 2]
    let GameTypes : [String] = ["8-Ball", "9-Ball"]
    let screenSize = UIScreen.main.bounds

    var body: some View {
        LazyVStack {
            Text("New Game")
                .font(.title2).frame(height: screenSize.height/6)
            
            Section {
                Text("Number of Players")
                Picker("Number of Players", selection: $data.numPlayers)
                    {
                        ForEach(PlayerNumbers, id: \.self) { i  in
                            Text(String(i)).id(i)
                        }
                    }.id(PlayerNumbers).pickerStyle(SegmentedPickerStyle())
                
                Text("Game Type:")
                Picker(selection: $data.gameType, label: Text("Game Type"))
                {
                    ForEach(GameTypes, id: \.self) { i in
                        Text(i)
                    }
                }.id(GameTypes).pickerStyle(SegmentedPickerStyle())
            }
            
            // player settings
            LazyVStack {
                if data.numPlayers > 0 {
                    ForEach(1...data.numPlayers, id: \.self) { idx in
                        Section(header: Text("PLAYER \(idx)")) {
                            LazyHStack {
                                Text("Name")
                                TextField("Player \(idx)", text: $data.players[idx - 1].name).onAppear {
                                    data.players[idx - 1].name = "Player \(idx)"
                                }
                            }

                            LazyHStack {
                                Text("Skill Level")
                                Picker(selection: $data.players[idx - 1].sl, label: Text("Skill Level")) {
                                    ForEach(SkillLevel.allCases, id:\.self) {
                                        Text($0.description)
                                    }
                                        
                                }
                            }
                        }.frame(alignment: .top)
                    }
                }
            }.frame(height:screenSize.height / 3)
            
            Button(action: {
                initializeGame()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Start")
            }.frame(height: screenSize.height / 6, alignment: .bottom).disabled(data.numPlayers == 0)
        }
    }
    
    func initializeGame() {
        data.racks = [RackData()]
        data.innings = [InningData()]
        data.ready_to_start = true
    }
}


struct NewGameView_Previews: PreviewProvider {
    @State static var data = GameData()
    static var previews: some View {
        NewGameView(data: data)
    }
}
