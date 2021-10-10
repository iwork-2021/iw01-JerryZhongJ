//
//  ViewController.swift
//  MyCalculator
//
//  Created by nju on 2021/10/10.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var display: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.display.text = "0"
    }
    var inputing = false;
    var dot = false;
    @IBAction func numberAction(_ sender: UIButton) {
        //
        let buttonTitle = sender.titleLabel!.text!
        print(buttonTitle)
        if(!inputing){
            if(buttonTitle == "."){
                // we have to guarantee when inputing == false, then dot = false
                dot = true;
                display.text = "0."
                inputing = true;
            }else if(buttonTitle != "0"){
                inputing = true
                display.text = buttonTitle
            }
        }else{
            if(buttonTitle != "." || dot == false){
                display.text! = display.text! + buttonTitle
            }
        }
    }
    
    @IBAction func operatorAction(_ sender: UIButton) {
    }
    
    @IBAction func clearAction() {
    }
    
    @IBAction func calcAction() {
    }
}

