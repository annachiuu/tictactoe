
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
    
    var humanPreviousMove = Move(row: 0, col: 0)
    
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
        saveCorners()
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
        for row in 0...n-1 {
            for col in 0...n-1 {
                if grid[row][col] == empty {
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
        var emptyCell = 0
        for cell in 0...n-1 {
            if grid[row][cell] == player {
                count = count + 1
            }
            if grid[row][cell] == empty {
                emptyCell = emptyCell + 1
            }
        }
        // if n-1 cells in a row is occupied by human, then emergency block needed
        if count == n-1 && numberEmpty() >= 10 && emptyCell == 1 {
            blockNeeded = true
            findBlock(origin: "rows" , num: row)
        }
        return count
    }
    
    func countCol(col: Int, player: String) -> Int {
        var count = 0
        var emptyCell = 0
        for cell in 0...n-1 {
            if grid[cell][col] == player {
                count = count + 1
            }
            if grid[cell][col] == empty {
                emptyCell = emptyCell + 1
            }
        }
        // if n-1 cells in a column is occupied by human, then emergency block needed
        if count == n-1 && numberEmpty() >= 10 && emptyCell == 1 {
            blockNeeded = true
            findBlock(origin: "cols" , num: col)
        }
        return count
    }
    
    func countDiagLR(player: String) -> Int {
        var count = 0
        for cell in 0...n-1 {
            if grid[cell][cell] == player {
                count = count + 1
            }
        }
        return count
    }
    
    func countDiagRL(player: String) -> Int {
        var count = 0
        var col = n-1
        for row in 0...n-1 {
            if grid[row][col] == player {
                count = count + 1
            }
            col = col - 1
        }
        return count
    }
    
    //#############################################################
    
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = Board()
        copy.grid = self.grid
        return copy
    }
    
    
    
    //#############################################################
    
    var corners = [Move]()
    var nextCorner = Move(row: 0, col: 0)
    
    func saveCorners() {
        let cornerTL = Move(row: 0, col: 0)
        let cornerTR = Move(row: 0, col: n-1)
        let cornerBL = Move(row: n-1, col: 0)
        let cornerBR = Move(row: n-1, col: n-1)
        
        corners.append(cornerTL)
        corners.append(cornerTR)
        corners.append(cornerBL)
        corners.append(cornerBR)
    }
    
    func isCornersEmpty() -> Bool {
        for corner in corners {
            if grid[corner.row][corner.col] == empty {
                nextCorner = corner
                return true
            }
        }
        return false
    }

    
  //#############################################################
    var blockNeeded = false
    var emergencyMove = Move(row: 0, col: 0)
    
    //When remaining cells is > 10 and human is one move away from winning - find emergency block move
    func findBlock(origin: String, num: Int) {

            switch origin {
            case "rows":
                for col in 0...n-1 {
                    if grid[num][col] == empty {
                        let nextMove = Move(row: num, col: col)
                        emergencyMove.updateMove(move: nextMove)
//                        print("Emergency move -- row: \(emergencyMove.row), col: \(emergencyMove.col)")
                        break
                    }
                }
            case "cols":
                for row in 0...n-1 {
                    if grid[row][num] == empty {
                        let nextMove = Move(row: row, col: num)
                        emergencyMove.updateMove(move: nextMove)
//                        print("Emergency move -- row: \(emergencyMove.row), col: \(emergencyMove.col)")
                        break
                    }
                }
            default:
                break
            }
    }
  //############################################################
    var layer = 0
    //Next computer move at the 4 edges of human's player - if all taken, work inwards
    func findEdgeMove(human: Move, layer: Int) -> Move{
        var top = Move(row: 0+layer, col: human.col)
        var left = Move(row: human.row, col: 0+layer)
        var right = Move(row: human.row, col: n-1-layer)
        var bottom = Move(row: n-1-layer, col: human.col)
        
        if grid[0+layer][human.col] == empty {
            return top
        } else if grid[human.row][0+layer] == empty {
            return left
        } else if grid[human.row][n-1-layer] == empty {
            return right
        } else if grid[n-1-layer][human.col] == empty {
            return bottom
        } else {
            return findEdgeMove(human: human, layer: layer + 1)
        }
        
    }
    
  //#############################################################  #############################################################
    func findBestMove(board: Board) -> Move{
        
        print("\nEmpty cells left: \(numberEmpty())\n loading...")
        
        var bestMove = Move(row: 0, col: 0)
        
        //if there are less than 10 cells left, then call miniMax
        if numberEmpty() <= 10 {
            return miniMax(board: board, player: p1)
        //if opponent has n-1 rows / cols filled, then BLOCK!
        } else if blockNeeded == true {
            blockNeeded = false
            return emergencyMove
        //if corners are empty, fill them first
        } else if isCornersEmpty() {
            return nextCorner
        } else {
            return findEdgeMove(human: humanPreviousMove, layer: layer)
            print("called findEdgeMove")
        }
    
        
        return bestMove
    }
    
    
    //miniMax function with alpha-beta pruning
    func miniMax(board: Board, player: String) -> Move {
    
        var moves = [Move]()
        
        //stopping conditions
        if board.checkWin(player: p1) {
            //temp Move to pass the score back up the recursion
            let tempMove = Move(row: 0, col: 0)
            tempMove.updateScore(score: 10)
            return tempMove
        } else if board.checkWin(player: p2) {
            let tempMove = Move(row: 0, col: 0)
            tempMove.updateScore(score: -10)
            return tempMove
        } else if board.fullCount() {
            let move = Move(row: 0, col: 0)
            move.score = 0
            return move
        }
        
        var bestMove = Move(row: 0, col: 0)
        
        //traverse through empty slots
        outerloop: for row in 0...n-1 {
            for col in 0...n-1 {
                if board.isEmpty(row: row, col: col) {
                    
                    // init move and take down coords
                    var move = Move(row: row, col: col)
                    // store the depth of the board
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
                    
                    //if p1 move.score = 10 then break
                    if move.score == 10 && player == p1 {
                        break outerloop
                    //if p2 move.score = -10 then break
                    } else if move.score == -10 && player == p2 {
                        break outerloop
                    }
                    
                }
            }
        }
        
        
        //chose the (best) move according to player
        if player == p1 {
            bestMove.updateScore(score: -9999)
            for move in moves {
                //choose highest score for computer
                if move.score! >= bestMove.score! {
                        bestMove.updateMove(move: move)
                }
            }
        } else if player == p2 {
            bestMove.updateScore(score: 9999)
            for move in moves {
                //chose lowest score for human
                if move.score! <= bestMove.score! {
                        bestMove.updateMove(move: move)
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


