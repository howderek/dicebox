//
//  ViewController.swift
//  Dicebox
//
//  Created by Derek Howard on 8/1/17.
//  Copyright © 2017 Derek Howard. All rights reserved.
//

import Cocoa

func matches(for regex: String, in text: String) -> [String] {
    do {
        let regex = try NSRegularExpression(pattern: regex)
        let results = regex.matches(in: text,
                                    range: NSRange(text.startIndex..., in: text))
        return results.map {
            text.substring(with: Range($0.range, in: text)!)
        }
    } catch let error {
        print("invalid regex: \(error.localizedDescription)")
        return []
    }
}

class ViewController: NSViewController {
    @IBOutlet weak var DiceInput: NSTextField!
    @IBOutlet weak var Result: NSTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func rollClicked(_ sender: Any) {
        var diceEquation = DiceInput.stringValue
        if diceEquation.isEmpty {
            diceEquation = "0"
        }
        let matched = matches(for: "[0-9]+d[0-9]+", in: diceEquation)
        for match in matched {
            let subgroup = matches(for: "[0-9]+", in: match)
            let numberOfDice:Int! = Int(subgroup[0])
            let typeOfDice:Int! = Int(subgroup[1])
            var total:UInt32! = 0
            for _ in 0..<numberOfDice {
                total = total + UInt32(arc4random_uniform(UInt32(typeOfDice)) + 1)
            }
            diceEquation = diceEquation.replacingOccurrences(of: match, with: String(total))
        }
        let bad = matches(for: "[^0-9\\*\\+\\/\\-\\. ]", in: diceEquation)
        for match in bad {
            diceEquation = diceEquation.replacingOccurrences(of: match, with: "")
        }
        let result = NSExpression(format: "1.0 * " + diceEquation).expressionValue(with: nil, context: nil) as! Float
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        Result.stringValue = diceEquation + " = " + formatter.string(from: NSDecimalNumber(value: result))!
    }

}

