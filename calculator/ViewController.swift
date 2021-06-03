//
//  ViewController.swift
//  calculator
//
//  Created by Petar Perich on 31.05.2021.
//

import UIKit

class ViewController: UIViewController {
    var firstNum: Double = 0
    var secondNum: Double = 0
    var operationSign = ""
    var stillTyping = false
    var dotIsPlaced = false
    var minusSymbolShown = false
    var currentInput: Double{
        get{
            return Double(resultLabel.text ?? "ERROR") ?? 0
        }
        set{
            let value = "\(newValue)"
            let separatedValue = value.components(separatedBy: ".")
            if separatedValue[1] == "0"  {
                resultLabel.text = "\(separatedValue[0])"
            }else{
                resultLabel.text = "\(newValue)"
            }
            stillTyping = false
        }
    }
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var clearButtonOutlet: UIButton!
    
    func operateWithTwoNums(operation: (Double, Double) -> Double){
        currentInput = operation(firstNum, secondNum)
        stillTyping = false
        
    }
    
    func counting(){
        if stillTyping{
            secondNum = currentInput
        }
        if secondNum == 0 && operationSign ==  "÷"{
            resultLabel.text = "ERROR"
        } else{
            switch operationSign {
            case "+":
                operateWithTwoNums {$0 + $1}
            case "-":
                operateWithTwoNums {$0 - $1}
            case "×":
                operateWithTwoNums {$0 * $1}
            case  "÷":
                operateWithTwoNums {$0 / $1}
            default: break
            }
        }
    }
    //MARK:- @IBActions
    
    //MARK:- Pressing numbers (0-9)
    @IBAction func digitsPressed(_ sender: UIButton) {
        let tagButton = sender.tag
        clearButtonOutlet.setTitle("C", for: .normal)
        
        if stillTyping{
            if (resultLabel.text?.count)! < 20{
                resultLabel.text = resultLabel.text! + String(tagButton)
            }
            
        }else{
            resultLabel.text = String(tagButton)
            stillTyping = true
            
        }
    }
    
    //MARK:- Pressing all the other buttons except dot, equal mark and +/-
    @IBAction func controlButtons(_ sender: UIButton) {
        counting()
        operationSign = sender.currentTitle!
        firstNum = currentInput
        stillTyping = false
        dotIsPlaced = false
        
    }
    
    @IBAction func equalityButtonPressed(_ sender: UIButton) {
        counting()
    }
    
    @IBAction func clearButtonPressed(_ sender: UIButton) {
        if clearButtonOutlet.currentTitle == "C"{
            clearButtonOutlet.setTitle("AC", for: .normal)
        }
        
        firstNum = 0
        secondNum = 0
        currentInput = 0
        resultLabel.text = "0"
        stillTyping = false
        operationSign = ""
        dotIsPlaced = false
    }
    
    @IBAction func plusMinusButtonPressed(_ sender: UIButton) {
        
        let positives = currentInput
        let negatives = -currentInput
        var stringPositives = String(positives)
        let stringNegatives = String(negatives)
        
        
        if resultLabel.text != "0" {
            if minusSymbolShown == false {
                if stringNegatives.contains("-"){
                    
                    resultLabel.text = stringNegatives
                }else{
                    resultLabel.text = "-" + stringNegatives
                }
                
                minusSymbolShown = true
            }
            
            
            else if minusSymbolShown == true {
                if stringPositives.contains("-") {
                    stringPositives.removeFirst()
                    resultLabel.text = stringPositives
                } else{
                    resultLabel.text = stringPositives
                }
                
                minusSymbolShown = false
            }
            
        }
    }
    
    @IBAction func dotButtonPressed(_ sender: UIButton) {
        if stillTyping  && !dotIsPlaced{
            resultLabel.text  = resultLabel.text! + "."
            dotIsPlaced = true
        } else if !stillTyping  && !dotIsPlaced {
            resultLabel.text = "0."
            stillTyping = true
        }
    }
}
