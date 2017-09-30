//
//  main.swift
//  TTT
//
//  Created by Anna Chiu on 9/28/17.
//  Copyright © 2017 Anna Chiu. All rights reserved.
//


// TO DO LIST //
/*
 • Must have at least 3N
 • Switch row and col to 1 - N (instead of 0-N-1)
 • When entering row and column only allow for empty spots - else reenter
 • Make replay game option
 */

import Foundation
import Darwin

var mboard = Board() //init main board

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

print("Tic Tac Toe")
print("Please enter board size: ")
let n = readLine()!

mboard.makeGrid(n: Int(n)!)

func humanInsert() {
    print("Where would you like to put your next move?")
    print("row:")
    row = Int(readLine()!)!
    print("col:")
    col = Int(readLine()!)!
}


func humanTurn() {
    humanInsert()
    while(mboard.isEmpty(row: row, col: col)){
        mboard.addMove(row: Int(row), col: Int(col), p: human)
        print(mboard.printGrid())
        }
    }

func compTurn() {
    let move = mboard.miniMax(board: mboard, player: comp)
    print("computer plays: row:\(move.row)  col:\(move.row) \n")
    mboard.addMove(row: move.row, col: move.col, p: comp)
    print(mboard.printGrid())
    
    }
 
//GAME PLAY HERE
while(!mboard.fullCount()) {
    if(mboard.checkWin(player: currentPlayer)) {
        if currentPlayer == human {
            print("You Win!!")
            exit(0)
        } else if currentPlayer == comp {
            print("Comp Win")
            exit(0)
        } else {
            print("Draw")
            exit(0)
        }
    }
    
    switchPlayer()
    
    if currentPlayer == human {
        humanTurn()
    } else {
        compTurn()
    }
}


