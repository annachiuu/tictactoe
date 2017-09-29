//
//  board.swift
//  tictactoe-VectrVentures
//
//  Created by Anna Chiu on 9/27/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//

import Foundation

class Board: NSObject, NSCopying {
    
    var grid: Array<Array<String>> = []
    
    var p1 = "X"
    var p2 = "O"
    var currentPlayer = "X"
    
    var n: Int!
    
    var nextCompMove = Move(row: 0, col: 0)
    
    func makeGrid(n: Int) {
        self.n = n
        for col in 1...n {
            var columnArray = Array<String>()
            for row in 1...n {
                columnArray.append(" ")
            }
            
            grid.append(columnArray)
        }
        print(self.printGrid()) //^^^
    }
    
    func printGrid() -> String {
        
        var gridOutput = ""
        
        for row in 0...n-1 {
            for col in 0...n-1 {
                if col != n-1 {
                gridOutput = gridOutput + grid[row][col] + " | "
                }  else {
                    gridOutput = gridOutput + grid[row][col]
                }
            }
            if row != n-1 {
            gridOutput = gridOutput + "\n"
            for i in 1...n {
                gridOutput = gridOutput + " -  "
            }
            gridOutput = gridOutput + "\n"
            }
        }
        
        return gridOutput
        
    }
    
    
    func addMove(row: Int, col: Int, p: String) {
        self.grid[row][col] = p
    }
    
    
    func checkWin(player: String) -> Bool {
        //for each row, count and see if there is a full row
        for row in 0...n-1 {
            if countRow(row: row, player: player) == n {
                return true
            }
        }
        //for each column, count and see if there is a full col
        for col in 0...n-1 {
            if countCol(col: col, player: player) == n {
                return true
            }
        }
        //for each of the two diagonals, see if there is full diagonal
        if countDiagLR(player: player) == n {
            return true
        }
        if countDiagRL(player: player) == n {
            return true
        }
        return false
    }
    
    func fullCount() -> Bool {
        
        for row in 0...n-1 {
            for col in 0...n-1 {
                if grid[row][col] == " " {
                    return false
                }
            }
        }
        return true
    }
        

    func miniMax(board: Board, player: String) -> Int {
        
        //check for win/lose states (stopping conditions)
        if board.checkWin(player: "X") {
            return 10
        } else if board.checkWin(player: "O") {
            return -10
        } else if board.fullCount() {
            return 0
        }
        
        //array of available moves
        var moves = [Move]()
        

        //traverse through empty slots
        for row in 0...n-1 {
            for col in 0...n-1 {
                if board.isEmpty(row: row, col: col) {
                    print("row: \(row) col: \(col)")
                    
                   //When found empty spot - make move variable for this slot
                    let move = Move(row: row, col: col)
                    //set empty slot to this move
                    board.addMove(row: row, col: col, p: player)

                    
                    if player == "X" { //call minimax on human
                        let finalScore = miniMax(board: board, player: "O")
                        move.score = finalScore
                    } else {  //call minimax on comp
                        let finalScore = miniMax(board: board, player: "X")
                        move.score = finalScore
                    }
                    //reset and open up spot again
                    board.addMove(row: row, col: col, p: " ")
                    
                    //append move to the array
                    moves.append(move)
                    print("\(move.score)")
                }
                
            }
        }
        
        var bestMove = Move(row: 0, col: 0)
        if player == "X" {
            var bestScore = -9999
            for move in moves {
                if move.score! > bestScore {
                    bestScore = move.score!
                    bestMove = move
                }
            }
        } else {
            var bestScore = 9999
            for move in moves {
                if move.score! < bestScore {
                    bestScore = move.score!
                    bestMove = move
                }
            }
        }
        
        nextCompMove = bestMove
        
        return 0
    }
    

    func isEmpty(row: Int, col: Int) -> Bool{
        if grid[row][col] == " " {
            return true
        }
        return false
    }
    
    
    //####################functions for checkWin() ##############################
    func countRow(row: Int, player: String) -> Int {
        var count = 0
        for cell in 0...n-1 {
            if grid[row][cell] == player {
                count = count + 1
            }
        }; return count
    }
    
    func countCol(col: Int, player: String) -> Int {
        var count = 0
        for cell in 0...n-1 {
            if grid[cell][col] == player {
                count = count + 1
            }
        }; return count
    }
    
    func countDiagLR(player: String) -> Int {
        var count = 0
        for cell in 0...n-1 {
            if grid[cell][cell] == player {
                count = count + 1
            }
        }; return count
    }
    
    func countDiagRL(player: String) -> Int {
        var count = 0
        var col = n-1
        for row in 0...n-1 {
            if grid[row][col] == player {
                count = count + 1
            }
            col = col - 1
        }; return count
    }
    
    //#############################################################
    
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Board()
        copy.grid = self.grid
        return copy
    }
    
    
}

