//
//  Calculator.swift
//  MyCalculator
//
//  Created by nju on 2021/10/11.
//

import UIKit

class Calculator: NSObject {
    private var mem = 0.0
    private var valueStack:[Double] = []
    private var operatorStacK:[Operator] = []
    
    private enum Operator{
        case UnaryOperator((Double)->Double?)
        case BinaryOperator((Double, Double)->Double?, Int)
        case End
        case LeftBracket
        case RightBracket
    }
    private let operators:[String:Operator]
    override init(){
        operators = [
            "=": Operator.End,
            "+": Operator.BinaryOperator({
                op1, op2 in return op1 + op2}, 1),
            "-":Operator.BinaryOperator({op1, op2 in return op1 - op2}, 1),
            "✕":Operator.BinaryOperator({op1, op2 in return op1 * op2}, 2),
            "÷":Operator.BinaryOperator({op1, op2 in return op1 / op2}, 2),
            "%":Operator.UnaryOperator({op in return op / 100}),
            "(":Operator.LeftBracket,
            ")":Operator.RightBracket,
            "mc":Operator.UnaryOperator({
                op in
                self.mem = 0.0
                return op
            }),
            "m+":Operator.UnaryOperator({
                op in
                self.mem += op
                return op
            }),
            "m-":Operator.UnaryOperator({
                op in
                self.mem -= op
                return op
            }),
            "x^2":Operator.UnaryOperator({op in return op * op}),
            "x^3":Operator.UnaryOperator({op in return op * op * op}),
            "e^x":Operator.UnaryOperator({op in return exp(op)}),
            "10^x":Operator.UnaryOperator({op in return pow(10, op)}),
            "x^y":Operator.BinaryOperator({
                op1, op2 in
                if(op2 < 0 && op1 == 0){
                    return nil
                }
                return pow(op1, op2)}, 3),
            "1/x":Operator.UnaryOperator({
                op in
                if(op == 0){
                    return nil
                }
                return 1 / op}),
            "2√x":Operator.UnaryOperator({
                op in
                if(op < 0){
                    return nil
                }
                return sqrt(op)}),
            "3√x":Operator.UnaryOperator({op in return cbrt(op)}),
            "y√x":Operator.BinaryOperator({
                op1, op2 in
                if(op1 < 0){
                    return nil
                }
                return pow(op1, 1 / op2)}, 3),
            "ln":Operator.UnaryOperator({
                op in
                if(op <= 0){
                    return nil
                }
                return log(M_E, op)}),
            "log10":Operator.UnaryOperator({
                op in
                if(op <= 0){
                    return nil
                }
                return log10(op)}),
            "x!":Operator.UnaryOperator({op in return})
            
        ]
    }
    private func fact(_ n: Int)->Double{
        var res = 1;
        for i in 1...n{
            res *= i
        }
        return Double(res)
    }
    func pushValue(value: Double){
        valueStack.append(value);
    }
    func pushOp(_ operator: String)->Double?{
        
    }
    func tryPushOp(_ operator: String)->Double?{
        return 0;
    }
    func popValue(){
        valueStack.popLast()
    }
    func clear(){
        
    }
}
