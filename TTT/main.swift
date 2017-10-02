//
//  main.swift
//  TTT
//
//  Created by Anna Chiu on 9/28/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//


// TO DO LIST - branch: main-defense //
/*
 • Must have at least 3N (DONE)
 • Switch row and col to 1 - N (instead of 0-N-1) and add defensive programming (DONE)
 • When entering row and column only allow for empty spots - else reenter (DONE)
 */

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
            print(board.printGrid())
        } else {
            validMove = false
            print("Invalid move, please choose another cell")
            print(board.printGrid()) //print board again for reference
        }
    } while validMove == false
}

func compTurn() {
    let move = board.miniMax(board: board, player: comp)
    print("computer plays: row:\(move.row+1)  col:\(move.row+1) \n")
    board.addMove(row: move.row, col: move.col, p: comp)
    print(board.printGrid())
    
    }
 
//GAME PLAY HERE
while(!board.fullCount()) {
    
    if(board.checkWin(player: currentPlayer)) {
        if currentPlayer == human {
            print("You Win!!")
            exit(0)
        } else if currentPlayer == comp {
            print("Computer Wins")
            exit(0)
        }
    }
    
    
    switchPlayer()
    
    if currentPlayer == human {
        humanTurn()
    } else {
        compTurn()
    }
    
    if board.fullCount() {
        print("Draw")
        exit(0)
    }
}



