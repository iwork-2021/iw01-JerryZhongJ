//
//  Calculator.swift
//  MyCalculator
//
//  Created by nju on 2021/10/11.
//

import UIKit

class Calculator: NSObject {
    private var mem:Double = 0.0
    private var valueStack:[Double?] = []
    private var operatorStack:[Operator] = []
    
    private enum Operator{
        case UnaryOperator((Double?)->Double?)
        case BinaryOperator((Double?, Double?)->Double?, Int)
        case End
        case LeftBracket
        case RightBracket
    }
    private var operators:[String:Operator] = [:]
    override init(){
        super.init()
        operators = [
            "=": Operator.End,
            "+": Operator.BinaryOperator({
                if let op1 = $0, let op2 = $1{
                    return op1 + op2
                }else{
                    return nil
                }}, 1),
            "-":Operator.BinaryOperator({
                if let op1 = $0, let op2 = $1{
                    return op1 - op2
                }else{
                    return nil
                }}, 1),
            "✕":Operator.BinaryOperator({if let op1 = $0, let op2 = $1{
                    return op1 * op2
                }else{
                    return nil
                }}, 2),
            "÷":Operator.BinaryOperator({
                if let op1 = $0, let op2 = $1{
                    return op1 / op2
                }else{
                    return nil
                }}, 2),
            "%":Operator.UnaryOperator({
                if let op = $0{
                return op / 100
            }else{
                return nil
            }}),
            "(":Operator.LeftBracket,
            ")":Operator.RightBracket,
            "mc":Operator.UnaryOperator({
                self.mem = 0.0
                return $0
            }),
            "m+":Operator.UnaryOperator({
                self.mem += ($0 ?? 0.0)
                return $0
            }),
            "m-":Operator.UnaryOperator({
                self.mem  -= ($0 ?? 0.0)
                return $0
            }),
            "mr":Operator.UnaryOperator({
                _ in
                return self.mem
            }),
            "x^2":Operator.UnaryOperator({
                if let op = $0{
                    return op * op
                }else{
                    return nil
                }}),
            "x^3":Operator.UnaryOperator({
                if let op = $0{
                    return op * op * op
                }else{
                    return nil
                }}),
            "e^x":Operator.UnaryOperator({
                if let op = $0{
                    return exp(op)
                }else{
                    return nil
                }}),
            "10^x":Operator.UnaryOperator({
                if let op = $0{
                    return pow(10, op)
                }else{
                    return nil
                }}),
            "x^y":Operator.BinaryOperator({
                if let op1 = $0, let op2 = $1{
                    if(op2 < 0 && op1 == 0){
                        return nil
                    }
                    return pow(op1, op2)
                }else{
                    return nil
                }}, 4),
            "1/x":Operator.UnaryOperator({
                if let op = $0{
                    if(op == 0){
                        return nil
                    }
                    return 1 / op
                }else{
                    return nil
                }}),
            "2√x":Operator.UnaryOperator({
                if let op = $0{
                    if(op < 0){
                        return nil
                    }
                    return sqrt(op)
                }else{
                    return nil
                }}),
            "3√x":Operator.UnaryOperator({
                if let op = $0{
                    return cbrt(op)
                }else{
                    return nil
                }}),
            "y√x":Operator.BinaryOperator({
                if let op1 = $0, let op2 = $1{
                    if(op1 < 0 || op2 == 0){
                        return nil
                    }
                    return pow(op1, 1 / op2)
                }else{
                    return nil
                }}, 4
                                         ),
            "ln":Operator.UnaryOperator({
                if let op = $0{
                    if(op <= 0){
                        return nil
                    }
                    return log(op)
                }else{
                    return nil
                }}),
            "log10":Operator.UnaryOperator({
                if let op = $0{
                    if(op <= 0){
                        return nil
                    }
                    return log10(op)
                }else{
                    return nil
                }}),
            "x!":Operator.UnaryOperator({
                if let op = $0{
                    let toInt = floor(op)
                    if toInt != op || toInt < 0{
                        return nil
                    }
                    return self.fact(Int(toInt))
                }else{
                    return nil
                }
            }),
            "sin":Operator.UnaryOperator({
                if let op = $0{
                    return sin(op)
                }else{
                    return nil
                }
            }),
            "cos":Operator.UnaryOperator({
                if let op = $0{
                    return cos(op)
                }else{
                    return nil
                }
            }),
            "tan":Operator.UnaryOperator({
                if let op = $0{
                    return tan(op)
                }else{
                    return nil
                }
            }),
            "e":Operator.UnaryOperator({
                _ in
                return M_E
            }),
            "EE":Operator.BinaryOperator({
                if let op1 = $0, let op2 = $1{
                    return op1 * pow(10, op2)
                }else{
                    return nil
                }
            }, 3),
            "sinh":Operator.UnaryOperator({
                if let op = $0{
                    return sinh(op)
                }else {
                    return nil
                }
            }),
            "cosh":Operator.UnaryOperator({
                if let op = $0{
                    return cosh(op)
                }else {
                    return nil
                }
            }),
            "tanh":Operator.UnaryOperator({
                if let op = $0{
                    return tanh(op)
                }else {
                    return nil
                }
            }),
            "π":Operator.UnaryOperator({
                _ in
                return Double.pi
            }),
            "Rand":Operator.UnaryOperator({
                _ in
                return Double.random(in: 0.0 ... 1.0)
            }),
            "C":Operator.UnaryOperator({
                _ in
                return 0
            }),
            "+/-":Operator.UnaryOperator({
                if let op = $0{
                    return -op
                }else{
                    return nil
                }
            })
            
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
//    func pushOp(_ operator: String)->Double?{
//
//    }
    private func pushOpInStack(_ opName:String, valueStack:inout  [Double?], operatorStack:inout [Operator])->Double?{
        // all operators should be covered, if not, add it
        
        let op = operators[opName]!
        switch(op){
        case .UnaryOperator(let uop):
            // push value before push op!
            let op = valueStack.popLast()!;
            valueStack.append(uop(op))
        case .BinaryOperator(let bop, let level):
        iterate:while(!operatorStack.isEmpty){
                let top = operatorStack.last!
                switch(top){
                case .LeftBracket:
                    // stop here
                    break iterate
                case .BinaryOperator(let topOp, let topLevel):
                    if(topLevel >= level){
                        let op1 = valueStack.popLast()!;
                        let op2 = valueStack.popLast()!;
                        valueStack.append(topOp(op1, op2));
                        operatorStack.popLast();
                    }else{
                        // for example bop == "*" and topOp == "+"
                        break iterate
                    }
                default:
                    // should not happen
                    assert(false);
                }
            }
            operatorStack.append(op)
        case .LeftBracket:
            operatorStack.append(op)
            return valueStack.last!
        case .End:
        iterate:while(!operatorStack.isEmpty){
                let top = operatorStack.last!
                switch(top){
                case .LeftBracket:
                    operatorStack.popLast();
                case .BinaryOperator(let topOp, let topLevel):
                    let op1 = valueStack.popLast()!;
                    let op2 = valueStack.popLast()!;
                    valueStack.append(topOp(op1, op2));
                    operatorStack.popLast();
                default:
                    // should not happen
                    assert(false);
                }
        }
        case .RightBracket:
        iterate:while(!operatorStack.isEmpty){
                let top = operatorStack.last!
                switch(top){
                case .LeftBracket:
                    operatorStack.popLast();
                    break iterate
                case .BinaryOperator(let topOp, let topLevel):
                    let op1 = valueStack.popLast()!;
                    let op2 = valueStack.popLast()!;
                    valueStack.append(topOp(op1, op2));
                    operatorStack.popLast();
                default:
                    // should not happen
                    assert(false);
                }
            }
        }
        
        return valueStack.last!
    }
    func tryPushOp(_ opName: String)->Double?{
        // should be called only when binary operator is pressed
        var tmpValueStack = self.valueStack
        var tmpOperatorStack = self.operatorStack
        return pushOpInStack(opName, valueStack: &tmpValueStack, operatorStack: &tmpOperatorStack)
    }
    func pushOp(_ opName:String)->Double?{
        return pushOpInStack(opName, valueStack: &self.valueStack, operatorStack: &self.operatorStack)
    }
    func popValue(){
        valueStack.popLast()
    }
    func clear(){
        
    }
}
