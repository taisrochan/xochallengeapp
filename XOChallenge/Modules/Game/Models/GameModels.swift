//
//  GameModels.swift
//  XOChallenge
//
//  Created by Tais Rocha Nogueira on 07/11/23.
//

import Foundation
import UIKit

enum ImageIdentifier {
    case circle
    case x
    case empty
    
    var word: String {
        if self == .circle {
            return "círculo"
        } else {
            return "X"
        }
    }
}

struct ButtonInfos {
    let button: UIButton
    var imageIdentifier: ImageIdentifier
}

