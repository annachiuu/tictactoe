
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
    var empty = " "
    var currentPlayer = "X"
    
    var n: Int!
    
    var nextCompMove = Move(row: 0, col: 0)
    
    func makeGrid(n: Int) {
        self.n = n
        for _ in 1...n { //each col
            var columnArray = Array<String>()
            for _ in 1...n { //each row
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
                for _ in 1...n {
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
    
    func numberEmpty() -> Int{
        var count = 0
        for _ in 0...n-1 {
            for _ in 0...n-1 {
                if grid.isEmpty {
                    count = count + 1
                }
            }
        }
        return count
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
                if grid[row][col] == empty {
                    return false
                }
            }
        }
        return true
    }
    

    func isEmpty(row: Int, col: Int) -> Bool{
        if grid[row][col] == empty {
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
    
    //#############################################################
    
    
  
    //count the depth of the recursion so the best move takes the least moves

    func miniMax(board: Board, player: String) -> Move {
    
        var moves = [Move]()
        
        //stopping conditions
        if board.checkWin(player: p1) {
            //temp Move to pass the score back up the recursion
            let tempMove = Move(row: 0, col: 0)
            tempMove.depth = n-board.numberEmpty()
            tempMove.updateScore(score: 10)
            return tempMove
        } else if board.checkWin(player: p2) {
            let tempMove = Move(row: 0, col: 0)
            tempMove.depth = n-board.numberEmpty()
            tempMove.updateScore(score: -10)
            return tempMove
        } else if board.fullCount() {
            let move = Move(row: 0, col: 0)
            move.depth = n-board.numberEmpty()
            move.score = 0
            return move
        }
        
        
        
        //traverse through empty slots
        for row in 0...n-1 {
            for col in 0...n-1 {
                if board.isEmpty(row: row, col: col) {
                    
                    // init move and take down coords
                    var move = Move(row: row, col: col)
                    // store the depth of the board
                    move.depth = n-board.numberEmpty()
                    board.addMove(row: row, col: col, p: player)
                    
                    //recursion to get score from terminating nodes
                    if player == p1 {
                        let returnedMove = miniMax(board: board, player: p2)
                        move.score = returnedMove.score
                    } else {
                        let returnedMove = miniMax(board: board, player: p1)
                        move.score = returnedMove.score
                    }
                    
                    //reset board
                    board.addMove(row: row, col: col, p: empty)
                    
                    //append move to moves
                    moves.append(move)
                    
                }
            }
        }
        var bestMove = Move(row: 0, col: 0)
        bestMove.depth = n+1

        //chose the (best) move according to player
        if player == p1 {
            bestMove.updateScore(score: -9999)
            for move in moves {
                //choose highest score for computer
                if move.score! >= bestMove.score! {
                    //if both moves recieve same high score, choose that with the fast win
                    if move.depth! < bestMove.depth! {
                        bestMove.updateMove(move: move)
                    }
                }
            }
        } else if player == p2 {
            bestMove.updateScore(score: 9999)
            for move in moves {
                //chose lowest score for human
                if move.score! <= bestMove.score! {
                    if move.depth! < bestMove.depth! {
                        bestMove.updateMove(move: move)
                    }
                }
            }
        }
        
        //update the move with current depth of board
        return bestMove
    }
    
    func pInvalid() {
        print("Invalid Integer")
    }
}


