//
//  alert.swift
//  Tic Tac Toe
//
//  Created by Mashael Alharbi on 09/11/2022.
//

import SwiftUI

struct Alertitem: Identifiable {
    let id = UUID ()
    var title: Text
    var message: Text
    var buttontitle: Text
}

struct Alertcontext {
    static let Humanwin = Alertitem(title: Text("You Win!"),
                             message: Text("You are so smart you beat your own AI."),
                             buttontitle: Text("Hell Yeah!"))
                             
    static let Computerwin = Alertitem(title: Text("You Lost!"),
                             message: Text("You prgrammed a super AI!"),
                             buttontitle: Text("Rematch?"))
                                                      
    static let Draw = Alertitem(title: Text("Draw"),
                             message: Text("What a battel of wits we have here..."),
                             buttontitle: Text("Try Again?"))
}
