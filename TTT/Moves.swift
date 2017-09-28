//
//  Moves.swift
//  tictactoe-VectrVentures
//
//  Created by Anna Chiu on 9/28/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//

import Foundation

class Move: NSCopying {
    
    var row: Int
    var col: Int
    var score: Int?
    
    init(row: Int, col: Int) {
        self.row = row
        self.col = col
    }
    
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Move(row: row, col: col)
        return copy
    }
    
    func updateScore(score: Int) {
        self.score = score
    }
    
}
