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
    @State var numPlayers : Int = 1

    var body: some View {
        LazyVStack {
            Text("New Game")
                .font(.title)
            Spacer(minLength: 25)
            
            LazyHStack {
                Text("Number of Players:")
                    .padding()
                Picker(selection: $numPlayers, label: Text("Number of Players"))
                {
                    Text("1").id(1)
                    Text("2").id(2)
                }
            }
            
            ForEach(1...2, id: \.self) { idx in
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
                }
                
            }
            
            Spacer(minLength: 25)
            Button(action: {
                initializeGame()
                self.presentationMode.wrappedValue.dismiss()
            }) {
                Text("Start")
            }
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
