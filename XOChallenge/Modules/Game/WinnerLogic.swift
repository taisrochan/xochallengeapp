//
//  WinnerLogic.swift
//  XOChallenge
//
//  Created by Tais Rocha Nogueira on 07/11/23.
//

import Foundation

struct WinnerVerification {
    func checkWinner(with buttonsMatrix: [[ButtonInfos]]) -> ImageIdentifier? {
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
                    if count == 3 {
                        return symbol
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
                    if count == 3 {
                        return symbol
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
                    if count1 == 3 || count2 == 3 {
                        return symbol
                    }
                }
            }
        }
        return nil
    }
}
