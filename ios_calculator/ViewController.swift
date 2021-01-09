//
//  ViewController.swift
//  ios_calculator
//
//  Created by Konstantin Smirnov on 07.01.2021.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var displayScreen: UILabel!
    @IBOutlet var buttonsGray: [UIButton]!
    @IBOutlet var buttonsOrange: [UIButton]!
    
    @IBAction func pressedButton(sender: UIButton) {
        calculate(input: sender.currentTitle!)
        
        // Change button opacity and return it back in a while
        sender.alpha = 0.9
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            sender.alpha = 1.0
        }
        
        // Play click sound
        audioPlayer = try! AVAudioPlayer(contentsOf: clickSound)
        audioPlayer.play()
    }
    
    var currentNumber: Float = 0.0
    var storedNumber: Float = 0.0
    var lastResult: Float = 0.0
    var memorizedAction: String = ""
    var decimalBase: Float = 0
    
    let digitsArray: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9" ]
    let mathActionsArray: [String] = ["+", "-", "×", "÷"]
    
    // Load click sound and prepare to use it
    let clickSound = URL(fileURLWithPath: Bundle.main.path(forResource: "keyboard-click", ofType: "wav")!)
    var audioPlayer = AVAudioPlayer()
    
   

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //Establish visual appearance
        for button in buttonsGray {
            button.layer.borderWidth = 0.5
            button.layer.borderColor = #colorLiteral(red: 0.585175693, green: 0.5851898789, blue: 0.5851822495, alpha: 1)
        }
        
        for button in buttonsOrange {
            button.layer.borderWidth = 0.5
            button.layer.borderColor = #colorLiteral(red: 0.585175693, green: 0.5851898789, blue: 0.5851822495, alpha: 1)
        }
        
        refreshDisplay(number: currentNumber)
    }
    
    func calculate(input: String) {
        if input == "AC" {
            resetValues()
            lastResult = 0
            refreshDisplay(number: currentNumber)
        } else if input == "," {
            decimalBase = 0.1
            refreshDisplay(number: currentNumber)
        } else if input == "±" {
            currentNumber = currentNumber * (-1)
            refreshDisplay(number: currentNumber)
        } else if input == "%" {
            currentNumber = currentNumber / 100
            decimalBase = 0.001
            refreshDisplay(number: currentNumber)
        } else if digitsArray.contains(input) {
            if displayScreen.text!.count < 10 || currentNumber == 0 {
                if decimalBase != 0 {
                    currentNumber = currentNumber + Float(input)! * decimalBase
                    decimalBase /= 10
                } else {
                    currentNumber = currentNumber * 10 + Float(input)!
                }
                refreshDisplay(number: currentNumber)
            }
        } else if mathActionsArray.contains(input) {
            if currentNumber == 0 {
                currentNumber = lastResult
            }
            math(action: memorizedAction)
            memorizedAction = input
            currentNumber = 0
        } else if input == "=" {
            math(action: memorizedAction)
            resetValues()
        }
        debug()
    }
    
    
    func math(action: String) {
        switch action {
            case "+":
                storedNumber += currentNumber
            case "-":
                storedNumber -= currentNumber
            case "×":
                storedNumber *= currentNumber
            case "÷":
                storedNumber /= currentNumber
            default:
                storedNumber = currentNumber
        }
        lastResult = storedNumber
        decimalBase = 0
        refreshDisplay(number: storedNumber)
    }
    
    func resetValues() {
        storedNumber = 0
        currentNumber = 0
        decimalBase = 0
        memorizedAction = ""
    }
    
    func refreshDisplay(number: Float) {
        //displayScreen.text = String(number)
        if decimalBase == 0.1 {
            displayScreen.text = String(format: "%.0f", number) + "."
        } else if decimalBase < 0.1 {
            displayScreen.text = String(format: "%g", number)
        } else {
            displayScreen.text = String(format: "%.0f", number)
        }
        
    }
    
    func debug() {
    //    print("Display content: \(displayContent)")
        print("Current number: \(currentNumber)")
        print("Stored number: \(storedNumber)")
        print("Memorized action: \(memorizedAction)")
        print("Decimal base:  \(decimalBase)")
    }

}
