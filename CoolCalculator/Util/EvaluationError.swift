//
//  EvaluationError.swift
//  CoolCalculator
//
//  Created by Michael Tier on 6/30/21.
//

import Foundation

public enum EvaluationError : Error {
        case DivideByZero
        case ComplexNumber
        
        /// - parameter symbol: the variable symbol that has no assigned value
        case VariableNotSet(symbol: String)
        
        /// - parameter symbol: the symbol of the operation that could not be evaluated due to missing operands
        case InsufficientOperandsForOperation(symbol: String)
    }
