//
//  Calculator.swift
//  MyCalculator
//
//  Created by nju on 2021/10/11.
//

import UIKit

class Calculator: NSObject {
    private var mem:Double = 0.0
    private var valueStack:[Double] = [0.0]
    private var operatorStack:[Operator] = []
    
    private enum Operator{
        case NullaryOperator(()->Double)
        case UnaryOperator((Double)->Double)
        case BinaryOperator((Double, Double)->Double, Int)
        case LeftBracket
        case RightBracket
        case End
        case AllClear
    }
    private var operators:[String:Operator] = [:]
    override init(){
        super.init()
        operators = [
            "=": Operator.End,
            "+": Operator.BinaryOperator({$0 + $1}, 1),
            "-":Operator.BinaryOperator({$0 - $1}, 1),
            "✕":Operator.BinaryOperator({$0 * $1}, 2),
            "÷":Operator.BinaryOperator({$0 / $1}, 2),
            "%":Operator.UnaryOperator({$0 / 100}),
            "(":Operator.LeftBracket,
            ")":Operator.RightBracket,
            "mc":Operator.UnaryOperator({ self.mem = 0.0; return $0 }),
            "m+":Operator.UnaryOperator({self.mem += $0; return $0 }),
            "m-":Operator.UnaryOperator({self.mem  -= $0; return $0}),
            "mr":Operator.NullaryOperator({self.mem}),
            "x²":Operator.UnaryOperator({$0 * $0}),
            "x³":Operator.UnaryOperator({$0 * $0 * $0}),
            "eˣ":Operator.UnaryOperator({exp($0)}),
            "10ˣ":Operator.UnaryOperator({pow(10, $0)}),
            "xʸ":Operator.BinaryOperator({pow($0, $1)}, 4),
            "1/x":Operator.UnaryOperator({1 / $0}),
            "²√x":Operator.UnaryOperator({sqrt($0)}),
            "³√x":Operator.UnaryOperator({cbrt($0)}),
            "ʸ√x":Operator.BinaryOperator({pow($0, 1 / $1)}, 4),
            "ln":Operator.UnaryOperator({log($0)}),
            "log₁₀":Operator.UnaryOperator({log10($0)}),
            "x!":Operator.UnaryOperator({
                if !$0.isNaN {
                    let toInt = floor($0)
                    if toInt != $0 || toInt < 0{
                        return Double.nan
                    }
                    return self.fact(Int(toInt))
                }else{
                    return Double.nan
                }
            }),
            "sin":Operator.UnaryOperator({sin($0)}),
            "cos":Operator.UnaryOperator({cos($0)}),
            "tan":Operator.UnaryOperator({tan($0)}),
            "e":Operator.NullaryOperator({M_E}),
            "EE":Operator.BinaryOperator({$0 * pow(10, $1)}, 3),
            "sinh":Operator.UnaryOperator({sinh($0)}),
            "cosh":Operator.UnaryOperator({cosh($0)}),
            "tanh":Operator.UnaryOperator({tanh($0)}),
            "π":Operator.NullaryOperator({Double.pi}),
            "Rand":Operator.NullaryOperator({Double.random(in: 0.0 ... 1.0)}),
            "C":Operator.NullaryOperator({0}),
            "±":Operator.UnaryOperator({-$0}),
            "AC":Operator.AllClear
            
        ]
    }
    private func fact(_ n: Int)->Double{
        var res = 1;
        for i in 1...n{
            res *= i
        }
        return Double(res)
    }
    
    func pushValue(_ value: Double){
        print("push value: "+String(value))
        valueStack.append(value);
    }

    private func performPushOp(_ opName:String, valueStack:inout  [Double], operatorStack:inout [Operator])->Double{
        // all operators should be covered, if not, add it
        
        let op = operators[opName]!
        switch(op){
        case .NullaryOperator(let nop):
            // nullary operator output a constant that covers current value
            valueStack.popLast()
            valueStack.append(nop())
            
        case .UnaryOperator(let uop):
            // push value before push op!
            let op = valueStack.popLast()
            valueStack.append(uop(op!))
            
        case .BinaryOperator(let bop, let level):
        popLoop:while(!operatorStack.isEmpty){
                let top = operatorStack.last!
                switch(top){
                case .LeftBracket:
                    // stop here
                    break popLoop
                case .BinaryOperator(let topOp, let topLevel):
                    if(topLevel >= level){
                        performBinOperation(topOp, &valueStack)
                        operatorStack.popLast();
                    }else{
                        // for example bop == "*" and topOp == "+"
                        break popLoop
                    }
                default:
                    // should not happen
                    assert(false);
                }
            }
            operatorStack.append(op)
            
        case .LeftBracket:
            operatorStack.append(op)
            valueStack.append(0.0)

        case .End:
            while(!operatorStack.isEmpty){
                let top = operatorStack.last!
                switch(top){
                case .LeftBracket:
                    // ignore left brackets
                    operatorStack.popLast();
                case .BinaryOperator(let topOp, let topLevel):
                    performBinOperation(topOp, &valueStack)
                    operatorStack.popLast();
                default:
                    // should not happen
                    assert(false);
                }
        }
            
        case .RightBracket:
        popLoop:while(!operatorStack.isEmpty){
                let top = operatorStack.last!
                switch(top){
                case .LeftBracket:
                    // stop here
                    operatorStack.popLast();
                    break popLoop
                case .BinaryOperator(let topOp, let topLevel):
                    performBinOperation(topOp, &valueStack)
                    operatorStack.popLast();
                default:
                    // should not happen
                    assert(false);
                }
            }
            
        case .AllClear:
            operatorStack.removeAll()
            valueStack.removeAll();
            valueStack.append(0.0)
        }
        print(valueStack)
        return valueStack.last!
    }
    private func performBinOperation(_ bop: (Double, Double)->Double, _ valueStack: inout [Double]){
        // the top is right operand and the top but second is left operand
        let op2 = valueStack.popLast()!;
        let op1 = valueStack.popLast()!;
        valueStack.append(bop(op1, op2));
    }
    func tryPushOp(_ opName: String)->Double{
        // should be called only when binary operator is pressed
        print("try push op: "+opName)
        var tmpValueStack = self.valueStack
        var tmpOperatorStack = self.operatorStack
        return performPushOp(opName, valueStack: &tmpValueStack, operatorStack: &tmpOperatorStack)
    }
    func pushOp(_ opName:String)->Double{
        print("push op: " + opName)
        return performPushOp(opName, valueStack: &self.valueStack, operatorStack: &self.operatorStack)
    }
    func popValue(){
        valueStack.popLast()
    }
}
