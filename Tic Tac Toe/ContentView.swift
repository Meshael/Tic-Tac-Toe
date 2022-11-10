//
//  ContentView.swift
//  Tic Tac Toe
//
//  Created by Mashael Alharbi on 08/11/2022.
//

import SwiftUI


struct ContentView: View {
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),]

    @State private var moves: [Move?] = Array(repeating: nil, count:9)
    @State private var isgameboarddisabled = false
    @State private var alertitem: Alertitem?
    var body: some View {
        GeometryReader { Geometry in
            VStack {
                Spacer()
                
                LazyVGrid(columns: columns) {
                    ForEach(0..<9) { i in
       // call each one of the circls i
                        ZStack {
                            Circle()
                                .foregroundColor(.blue)
                                .opacity(0.5)
                                .frame(width: Geometry.size.width/3 - 15,
                                       height: Geometry.size.width/3 - 15)
                            Image(systemName: moves[i]?.indicator ?? "")
                                .resizable()
                                .frame(width: 40, height: 40)
                                .foregroundColor(.white)
                       }
                        .onTapGesture {
                            if issquareoccupied(in: moves, forIndex: i) {return}
                            moves[i] = Move(Player: .human, boardindex: i)
                            
                            
                            // check for win
                            if chickwincondition(for: .human, in: moves) {
                                alertitem = Alertcontext.Humanwin
                                return
                        }
                            if checkfordraw(in: moves) {
                                alertitem = Alertcontext.Draw
                                return
                            }
                            isgameboarddisabled = true
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                let computerposition = determinecomputermoveposition(in: moves)
                                moves[computerposition] = Move(Player: .computer, boardindex:  computerposition)
                                isgameboarddisabled = false
                                
                                if chickwincondition(for: .computer, in: moves) {
                                    alertitem = Alertcontext.Computerwin
                                    return
                                }
                                if checkfordraw(in: moves) {
                                    alertitem = Alertcontext.Draw
                                    return
                                }
                            }
                        }
                    }
                }
                Spacer()
            }
            .disabled(isgameboarddisabled)
            .padding()
            .alert(item: $alertitem, content: {alertitem in
                Alert(title: alertitem.title, message: alertitem.message,
                dismissButton: .default(alertitem.buttontitle, action: { resetgame() }))
            })
        }
    }
    func issquareoccupied(in moves: [Move?], forIndex index: Int)-> Bool {
        return moves.contains(where: { $0?.boardindex == index})
    }
    
    func determinecomputermoveposition(in moves: [Move?]) ->Int {
        // ai win
        
        // ai can't win
        
        // if ai
        
        var moveposition = Int.random(in: 0..<9)
        
        while issquareoccupied(in: moves, forIndex: moveposition) {
            moveposition = Int.random(in: 0..<9)
        }
        return moveposition
    }
    func chickwincondition(for player: Player, in moves: [Move?]) -> Bool {
        let winpatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [0,4,8], [2,4,6]]
        
        let computermoves = moves.compactMap { $0 }.filter { $0.Player == .computer}
        let computerpositions = Set(computermoves.map { $0.boardindex })
        
        for pattern in winpatterns {
            let winpositions = pattern.subtracting(computerpositions)
            
            if winpositions.count == 1 {
                let isAvaiable = !issquareoccupied(in: moves, forIndex: winpositions.first!)
                if isAvaiable { return winpositions.first! }
            }
        }
        
        let playermoves = moves.compactMap { $0 }.filter { $0.Player == player}
        let playerpositions = Set(playermoves.map { $0.boardindex })
        
        for pattern in winpatterns where pattern.isSubset(of: playerpositions) {return true}
        
        return false
    }
    func checkfordraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
                   func resetgame() {
                moves = Array(repeating: nil, count: 9)
    }
}

enum Player {
    case human, computer
}

struct Move {
    let Player: Player
    let boardindex: Int
    
    var indicator: String {
        return Player == .human ? "xmark" : "circle"
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
