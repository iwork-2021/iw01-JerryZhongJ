//
//  ViewController.swift
//  MyCalculator
//
//  Created by nju on 2021/10/10.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var cac: UIButton!
    @IBOutlet weak var display: UILabel!
    let calculator = Calculator()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.display.text = "0"
    }
    var inputing = false{
        didSet{
            if(inputing == false){
                hasDot = false;
                cac.titleLabel!.text = "AC"
            }else{
                cac.titleLabel!.text = "C"
            }
        }
    }
    var hasDot = false;
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
    var selectedBinOp: UIButton?
    @IBAction func numberAction(_ sender: UIButton) {
        //
        let buttonTitle = sender.titleLabel!.text!
        
        if(!inputing){
//            if(selectedBinOp == nil){
//                // no binary operator is selected, then current input should cover the previous
//                calculator.popValue()
//            }else{
//                calculator.pushOp(buttonTitle)
//            }
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
    }
    
    
}

