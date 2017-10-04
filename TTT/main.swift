//
//  main.swift
//  TTT
//
//  Created by Anna Chiu on 9/28/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//


import Foundation
import Darwin

var board = Board() //init main board

let human = "O"
let comp = "X"

//for human
var row = 0
var col = 0

var currentPlayer = comp

func switchPlayer() {
    if currentPlayer == human {
        currentPlayer = comp
    } else {
        currentPlayer = human
    }
}

print("Tic Tac Toe by Anna Chiu")

var n = 0
while (n < 3 || n > 100) {
    print("Please enter board size: ")
    if let num = Int(readLine()!) {
        if (num != nil && (num >= 3 && num <= 100)) {
            n = num
            break
        } else if (num < 3 || num > 100) {
            print("Invalid Integer - Please enter a whole number between 3 - 100")
        }
    } else {
        board.pInvalid()
    }
}

board.makeGrid(n: n)

func humanInsert() {
    print("Where would you like to put your next move?")
    
    repeat {
        print("row:")
        if let num = Int(readLine()!) {
            if (num <= n && num > 0){
                row = num-1
            } else {
                row = num-1
                print("Please enter row number between 1 - \(n):")
            }
        } else {
            board.pInvalid()
        }
    } while (row > n-1 || row < 0)
    
    repeat {
        print("col:")
        if let num = Int(readLine()!) {
            if (num <= n && num > 0){
                col = num-1
            } else {
                col = num-1
                print("Please enter column number between 1 - \(n):")
            }
        } else {
            board.pInvalid()
        }
    } while (col > n-1 || col < 0)
}


func humanTurn() {
    var validMove = true
    repeat {
        humanInsert()
        if (board.isEmpty(row: row, col: col)) {
            validMove = true
            board.addMove(row: Int(row), col: Int(col), p: human)
            board.humanPreviousMove = Move(row: row, col: col)
            board.blockNeeded = false
            print(board.printGrid())
        } else {
            validMove = false
            print("Invalid move, please choose another cell")
            print(board.printGrid()) //print board again for reference
        }
    } while validMove == false
}

func compTurn() {
    let move = board.findBestMove(board: board)
    print("computer plays: row:\(move.row+1)  col:\(move.col+1) \n")
    board.addMove(row: move.row, col: move.col, p: comp)
    print(board.printGrid())
}


func evaluateCondition() {
    if board.checkWin(player: human) {
        print("You win!!")
        exit(0)
    } else if board.checkWin(player: comp) {
        print("Computer Wins")
        exit(0)
    }
}

print(board.printGrid())

//GAME PLAY HERE
while(!board.fullCount()) {
    
    evaluateCondition()
    
    switchPlayer()
    
    if currentPlayer == human {
        humanTurn()
    } else {
        compTurn()
    }
    
    evaluateCondition()
    
    if board.fullCount() {
        print("Draw")
        exit(0)
    }
}



