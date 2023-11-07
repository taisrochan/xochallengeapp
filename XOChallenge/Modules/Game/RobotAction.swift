//
//  RobotLogic.swift
//  XOChallenge
//
//  Created by Tais Rocha Nogueira on 07/11/23.
//

import Foundation

struct RobotAction {
    func getNextMove(for buttonsMatrix: [[ButtonInfos]]) -> (row: Int, col: Int) {
        let numRows = buttonsMatrix.count
        let numCols = buttonsMatrix[0].count
        let symbols = [ImageIdentifier.x, ImageIdentifier.circle]
        
        for symbol in symbols {
            // Verifica as linhas
            for i in 0..<numRows {
                for j in 0..<(numCols - 2) {
                    var count = 0
                    for k in 0..<3 {
                        if buttonsMatrix[i][j + k].imageIdentifier == symbol {
                            count += 1
                        }
                    }
                    if count == 2 {
                        if buttonsMatrix[i][j+2].imageIdentifier == .empty {
                            return (i, j+2)
                        }
                    }
                }
            }
            
            // Verifica as colunas
            for j in 0..<numCols {
                for i in 0..<(numRows - 2) {
                    var count = 0
                    for k in 0..<3 {
                        if buttonsMatrix[i + k][j].imageIdentifier == symbol {
                            count += 1
                        }
                    }
                    if count == 2 {
                        if buttonsMatrix[i+2][j].imageIdentifier == .empty {
                            return (i+2, j)
                        }
                    }
                }
            }
            
            // Verifica as diagonais
            for i in 0..<(numRows - 2) {
                for j in 0..<(numCols - 2) {
                    var count1 = 0
                    var count2 = 0
                    for k in 0..<3 {
                        if buttonsMatrix[i + k][j + k].imageIdentifier == symbol {
                            count1 += 1
                        }
                        if buttonsMatrix[i + k][j + 2 - k].imageIdentifier == symbol {
                            count2 += 1
                        }
                    }
                    if count1 == 2 {
                        if buttonsMatrix[i+2][j+2].imageIdentifier == .empty {
                            return (i+2, j+2)
                        }
                    }
                    if count2 == 2 {
//                        if buttonsMatrix[i+2][j+2].imageIdentifier == .empty {
//                            return (i+2, j+2)
//                        }
                    }
                }
            }
        }
        return returnRandomPosition(for: buttonsMatrix)
    }
    
    func returnRandomPosition(for buttonsMatrix: [[ButtonInfos]]) -> (row: Int, col: Int) {
        var row: Int = buttonsMatrix.count/2
        var column: Int = buttonsMatrix.count/2
        if buttonsMatrix[row][column].imageIdentifier == .empty {
            return (row, column)
        }
        repeat {
            let boardSize = buttonsMatrix.count
            row = Int(exactly: arc4random_uniform(UInt32(boardSize))) ?? 0
            column = Int(exactly: arc4random_uniform(UInt32(boardSize))) ?? 0
            
            if buttonsMatrix[row][column].imageIdentifier == .empty {
                return (row, column)
            }
        } while buttonsMatrix[row][column].imageIdentifier == .empty
        return (0, 0)
    }
}
