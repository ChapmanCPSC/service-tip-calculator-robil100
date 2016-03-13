//
//  ViewController.swift
//  Assignment 2
//
//  Created by Robillard, Matt on 3/13/16.
//  Copyright © 2016 Robillard, Matt. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var stepperDisplayLabel: UILabel!
    
    @IBOutlet weak var ratingStepper: UIStepper!
    
    @IBAction func ratingValueChange(sender: UIStepper) {
        stepperDisplayLabel.text = Int(sender.value).description
    }
    @IBOutlet weak var subtotalTextField: UITextField!
    
    @IBOutlet weak var tipAmountLabel: UILabel!
    @IBOutlet weak var totalAmountLabel: UILabel!
    
    @IBAction func calculateButton(sender: AnyObject) {
        do{
            try calculate(subtotalTextField.text!, rating : stepperDisplayLabel.text!)
        }
        catch SubtotalError.invalidAmount
        {
            print("The subtotal amount is not valid")
        }
        catch {
            print("Error")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let err = NSError(domain: "edu.chapman", code: 0, userInfo: nil)
    enum SubtotalError : ErrorType
    {
        case invalidAmount
    }

//    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool
//    {
//        textField.delegate = self
//        let countDecimal = textField.text!.componentsSeparatedByString(".").count
//        
//        if countDecimal > 1 && string == "."
//        {
//            return false
//        }
//        return true
//    }
    
    func calculate(subtotal : String?, rating : String) throws
    {
        //will throw the error if the string is empty
        guard subtotal?.characters.count > 0 else {throw SubtotalError.invalidAmount}
        
        if subtotal!.characters.count == 1 && subtotal! == "."
        {
            throw SubtotalError.invalidAmount
        }
        
        var decimals = 0
        
        for c in subtotal!.characters
        {
            if c == "."
            {
                decimals += 1
            }
            
            if decimals > 1
            {
                throw SubtotalError.invalidAmount
            }
        }
        
        //initialize variables
        let subtotalNum = Double(subtotal!)
        var tipPercentage : Double = 0.15
        var tipAmount : Double
        
        //calculate tip percentage
        switch Int(rating)!
        {
            case 1...3:
                tipPercentage = 0.10
            case 4...5:
                tipPercentage = 0.13
            case 6...7:
                tipPercentage = 0.15
            case 8...9:
                tipPercentage = 0.20
            case 10:
                tipPercentage = 0.25
            default:
                tipPercentage = 0.15
        }
        
        //calculate the tip
        tipAmount = subtotalNum! * tipPercentage
        
        //display the tip
        tipAmountLabel.text = "Tip Amount: $\(String(format: "%.2f", tipAmount))  (\(tipPercentage * 100)%)"
        //display the total
        totalAmountLabel.text = "Total Amount: $\(String(format: "%.2f",(subtotalNum! + tipAmount)))"
        
    }
    
}

