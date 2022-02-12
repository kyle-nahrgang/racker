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
    
    let GameTypeArray = [GameType.EightBall, GameType.NineBall]
    let PlayerNumbers : [Int] = [1, 2]
    let EightBallSL = [SkillLevel.two, SkillLevel.three, SkillLevel.four, SkillLevel.five, SkillLevel.six, SkillLevel.seven]
    let NineBallSL = [SkillLevel.one, SkillLevel.two, SkillLevel.three, SkillLevel.four, SkillLevel.five, SkillLevel.six, SkillLevel.seven, SkillLevel.eight, SkillLevel.nine]

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
                    ForEach(GameTypeArray, id: \.self) { i in
                        Text(i.description).id(i)
                    }
                }.id(GameTypeArray)
                    .pickerStyle(SegmentedPickerStyle())
                    .onChange(of: data.gameType) { _ in
                        // just pick a default for now that is in both ranges
                        data.players[0].sl = SkillLevel.three
                        data.players[1].sl = SkillLevel.three
                    }
            }
            
            // player settings
            LazyVStack {
                if data.gameType != GameType.None {
                    ForEach(1...data.numPlayers, id: \.self) { idx in
                        Section(header: Text("PLAYER \(idx)")) {
                            LazyHStack {
                                Text("Name").frame(width: screenSize.width / 3, alignment: .leading)
                                TextField("Player \(idx)", text: $data.players[idx - 1].name)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .frame(width:screenSize.width / 3, alignment: .trailing)
                                    .onAppear {
                                        data.players[idx - 1].name = "Player \(idx)"
                                    }
                                
                            }

                            LazyHStack {
                                Text("Skill Level").frame(width: screenSize.width / 3, alignment: .leading)
                                Picker(selection: $data.players[idx - 1].sl, label: Text("Skill Level")) {
                                    ForEach(data.gameType == GameType.EightBall ? EightBallSL : NineBallSL, id:\.self) {
                                        Text($0.description)
                                    }
                                }.frame(width: screenSize.width / 3, alignment: .leading)
                            }
                        }.frame(alignment: .top)
                    }
                }
            }.frame(height:screenSize.height / 3)
            
            Button(action: {
                initializeGame()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Start").frame(width: screenSize.width * 4 / 5).padding()
            }.frame(height: screenSize.height / 6, alignment: .bottom).disabled(data.numPlayers == 0)
                .buttonStyle(BorderedButtonStyle())
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
