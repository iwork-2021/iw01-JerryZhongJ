//
//  ViewController.swift
//  MyCalculator
//
//  Created by nju on 2021/10/10.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var buttons: UIStackView!
    @IBOutlet weak var cac: UIButton!
    @IBOutlet weak var display: UILabel!
    let calculator = Calculator()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        displayFormat.numberStyle = .decimal
        displayFormat.usesSignificantDigits = true
        displayFormat.maximumSignificantDigits = 15
        
        displayValue = 0
        
        
                    
    }
    var inputing = false{
        didSet{
            if(inputing == false){
                hasDot = false;
                // when and only when stop inputing
                if(oldValue == true){
                    calculator.pushValue(displayValue)
                }
                
            }else{
                // “Clear” is available whenever there is a number except “”
                cac.setTitle("C", for: UIControl.State.normal)
                if(oldValue == false){
                    if(selectedBinOp == nil){
                        // no binary operator is selected, then current input should cover the previous
                        calculator.popValue()
                    }else{
                        calculator.pushOp(selectedBinOp!.titleLabel!.text!)
                        selectedBinOp = nil;
                    }
                }
            }
        }
    }
    
    var hasDot = false;
    let displayFormat = NumberFormatter();
    var displayText: String{
        get{
            return display.text!
        }
        set{
            
            switch(newValue){
            case "", "00", "-0":
                display.text = "0"
            case ".":
                display.text = "0."
            default:
                display.text = newValue;
            }
        }
    }
    var displayValue:Double{
        get{
//            print("current display text: "+displayText)
//            print(Double(displayText))
            return (Double(displayText) ?? Double.nan)
        }
        set{
            if(newValue.isNaN){
                displayText = "错误"
            }else{
                displayText = displayFormat.string(from: NSNumber(value: newValue))!
            }
        }
    }
    var selectedBinOp: UIButton?{
        didSet{
            if(oldValue != nil){
                oldValue!.configuration!.baseForegroundColor = UIColor.white
                switch(oldValue!.titleLabel!.text!){
                case "÷", "✕", "-", "+":
                    oldValue!.configuration!.background.backgroundColor = UIColor.systemOrange
                default:
                    oldValue!.configuration!.background.backgroundColor = UIColor.darkGray
                }
            }
            
            if(selectedBinOp != nil){
                
                selectedBinOp!.configuration!.background.backgroundColor = UIColor.systemGray6;
                switch(selectedBinOp!.titleLabel!.text!){
                case "÷", "✕", "-", "+":
                    selectedBinOp!.configuration!.baseForegroundColor = UIColor.systemOrange
                default:
                    selectedBinOp!.configuration!.baseForegroundColor = UIColor.black
                }
            }
        }
    }
        
    @IBAction func numberAction(_ sender: UIButton) {
        let buttonTitle = sender.titleLabel!.text!
        
        if(!inputing){  
            inputing = true
            displayText = buttonTitle
            
        }else if(buttonTitle != "." || hasDot == false){
            displayText = displayText + buttonTitle
        }
        if(buttonTitle == "."){
            hasDot = true;
        }
    }
    
    @IBAction func binOpAction(_ sender: UIButton) {
        inputing = false
        selectedBinOp = sender
        displayValue = calculator.tryPushOp(sender.titleLabel!.text!)
    }
    
    @IBAction func otherOpAction(_ sender: UIButton){
        inputing = false
        if(sender.titleLabel!.text! == "(" && selectedBinOp != nil){
            calculator.pushOp(selectedBinOp!.titleLabel!.text!)
        }
        selectedBinOp = nil
        displayValue = calculator.pushOp(sender.titleLabel!.text!)
        if(sender.titleLabel!.text! == "C"){
            cac.setTitle("AC", for: UIControl.State.normal)
        }
        
    }
    
}

