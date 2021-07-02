//
//  ViewController.swift
//  CoolCalculator
//
//  Created by Michael Tier on 6/28/21.
//

import UIKit

class ViewController: UIViewController, NumberDisplayFormatter {
    
    private let NUMBER_HORIZONTAL_STACKVIEWS : Int = 7
    private var calculator: CalculatorModel!
    private let numberFormatter = NumberFormatter()
    
    var userIsInTheMiddleOfTyping = false
    
    var displayValue: Double {
        get {
            return Double(resultLabel.text!)!
        }
        set {
            resultLabel.text = formatDisplayNumber(number: newValue)
        }
    }
    
    // 2-D array of CalculatorButtons representing the calculator button layout
    private let buttons: [[CalculatorButtonModel]] = [
        [.ac, .plusMinus, .percent, .divide],
        [.seven, .eight, .nine, .multiply],
        [.four, .five, .six, .minus],
        [.one, .two, .three, .plus],
        [.zero, .decimal, .equals]
    ]
    
    private let verticalStack: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 1
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont(name: "AvenirNext-DemiBold", size: 40)
        label.layoutMargins = UIEdgeInsets(top:10,left:10,bottom:10,right:100)
        return label
    }()
    
    
    private let inputSequenceLabel: UILabel = {
        let label = UILabel()
        label.text = " "
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont(name: "AvenirNext-Italic", size: 24)
        label.layoutMargins = UIEdgeInsets(top:10,left:10,bottom:10,right:100)
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        calculator = CalculatorModel()
        // Set the number formatter for the calculator brain to use when
        // creating the input sequence description.
        numberFormatter.numberStyle = .decimal
        numberFormatter.usesGroupingSeparator = false
        numberFormatter.maximumFractionDigits = 6
        calculator.numberFormatter = numberFormatter
        view.backgroundColor = .black
        setupAndAddVerticalStackView()
        do {
            try setupAndAddHorizontalStackViews()
        } catch {
            print("Unexpected button layout error: \(error)")
        }
    }
    
    private func setupAndAddVerticalStackView() {
        view.addSubview(verticalStack)
        // Adds contraint of 0 to top to saftearea
        verticalStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant:0).isActive = true
        verticalStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant:0).isActive = true
        verticalStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0).isActive = true
        verticalStack.trailingAnchor.constraint(equalTo:view.safeAreaLayoutGuide.trailingAnchor, constant: 0).isActive = true
    }
    
    
    // Create 7 horiztonal stack views from the top (0 is the top stackview and 6 is the bottom)
    // StackView 1 contains a lable with the printout of the
    // StackView 2 contains the label with the result of the calculation
    // StackView 3-7 contain the buttons
    private func setupAndAddHorizontalStackViews() throws {
        // Initalize all 7 stackviews
        for stackNumber in 1...NUMBER_HORIZONTAL_STACKVIEWS {
            let horizontalStack = UIStackView()
            horizontalStack.axis = .horizontal
            horizontalStack.distribution = .fillEqually
            horizontalStack.spacing = 1
            verticalStack.addArrangedSubview(horizontalStack)
            
    
            switch stackNumber {
            case 1:
                // Add the results input sequence text label display to the second stackview from the top and add padding in it
                horizontalStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
                horizontalStack.isLayoutMarginsRelativeArrangement = true
                horizontalStack.addArrangedSubview(inputSequenceLabel)
                break
            case 2:
                // Add the results text label display to the second stackview from the top and add padding in it
                horizontalStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
                horizontalStack.isLayoutMarginsRelativeArrangement = true
                horizontalStack.addArrangedSubview(resultLabel)
                break
            case 3...7: // Add the buttons to all the bottom 5 rows
                addButtonsToHorizontalStack(horizontalStackView: horizontalStack, forRowAt: stackNumber)
                break
            default:
                throw InvalidButtonLayoutError.tooManyButtonRows
            }
            
        }
    }
    
    
    private func addButtonsToHorizontalStack(horizontalStackView: UIStackView, forRowAt: Int){
        // The forRowAt for this setup will start at horizontal stackview row 3 - 7, for a total of 5 rows of buttons
        // Horizontal stackviews to button 2-D array mapping should be
        // horizontal stackview row 3 (the topmost horizontal stackview should map to
        // row 0 in the 2-D button array
        let buttonRow = forRowAt - 3
        
        
        let rowOfButtonModels : [CalculatorButtonModel] = buttons[buttonRow]
        // if we are the last row of the stack, we need to add 2 horizontal stackviews to the existing stackview, so that we can have a double wide zero button
        if buttonRow == 4 {
            let extrawideZeroHStack = UIStackView()
            extrawideZeroHStack.axis = .horizontal
            extrawideZeroHStack.distribution = .fillEqually
            extrawideZeroHStack.isLayoutMarginsRelativeArrangement = true
            horizontalStackView.addArrangedSubview(extrawideZeroHStack)
            
            let otherButtonHStack = UIStackView()
            otherButtonHStack.distribution = .fillEqually
            otherButtonHStack.isLayoutMarginsRelativeArrangement = true
            otherButtonHStack.isLayoutMarginsRelativeArrangement = true
            horizontalStackView.addArrangedSubview(otherButtonHStack)
            
            for buttonModel in rowOfButtonModels {
                let button = createButtonFromModel(model:buttonModel)
                if buttonModel == .zero {
                    extrawideZeroHStack.addArrangedSubview(button)
                } else {
                    otherButtonHStack.addArrangedSubview(button)
                }
            }
            
        } else {
            for buttonModel in rowOfButtonModels {
                let button = createButtonFromModel(model:buttonModel)
                horizontalStackView.addArrangedSubview(button)
            }
        }
       
    }
    
    private func createButtonFromModel(model: CalculatorButtonModel) -> UIButton {
        let button = UIButton()
        button.setTitle(model.title, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = model.backgroundColor
        addButtonAction(uiButton: button, buttonModel: model)
        return button
    }
    
    
    /*
     Adds a callback to an already instatiated UI button depending on the type of button it is
     */
    private func addButtonAction(uiButton: UIButton, buttonModel: CalculatorButtonModel) {
        
        switch buttonModel {
        case .ac:
            uiButton.addTarget(self, action: #selector(handleClearButtonPressed(sender:)), for: .touchUpInside)
            break
        case .decimal:
            uiButton.addTarget(self, action: #selector(handleDecimalPressed(sender:)), for: .touchUpInside)
            break
        case .divide,
             .multiply,
             .minus,
             .plus,
             .plusMinus,
             .percent,
             .equals:
            uiButton.addTarget(self, action: #selector(performOperation(sender:)), for: .touchUpInside)
            break
        case .zero, .one, .two, .three, .four, .five, .six, .seven, .eight, .nine:
            uiButton.addTarget(self, action: #selector(handleDigitButtonPressed(sender:)), for: .touchUpInside)
            break
            
        }
    }
    
    
    @objc func handleClearButtonPressed(sender: UIButton){
        calculator.reset()
        userIsInTheMiddleOfTyping = false
        resultLabel.text = "0"
        inputSequenceLabel.text = " "
    }
    
    @objc func handleDigitButtonPressed(sender: UIButton){
        let digit = sender.currentTitle!
               if userIsInTheMiddleOfTyping {
                   let textCurrentlyInDisplay = resultLabel.text!
                   resultLabel.text = textCurrentlyInDisplay + digit
               }
               else {
                   resultLabel.text = digit
                   userIsInTheMiddleOfTyping = true
               }
    }
    
    @objc func handleDecimalPressed(sender: UIButton) {
            let decimal = "."
            if userIsInTheMiddleOfTyping {
                if !resultLabel.text!.contains(decimal) {
                    resultLabel.text = resultLabel.text! + decimal
                }
            }
            else {
                resultLabel.text = "0."
                userIsInTheMiddleOfTyping = true
            }
    }
    
    @objc func performOperation(sender: UIButton) {
            if userIsInTheMiddleOfTyping {
                calculator.setOperand(displayValue)
                userIsInTheMiddleOfTyping = false
            }

            if let mathematicalSymbol = sender.currentTitle {
                calculator.performOperation(mathematicalSymbol)
            }
            
            if let result = calculator.result.value {
                displayValue = result
            }
            
            let resultStateIndicator = calculator.resultIsPending ? "…" : "="
            inputSequenceLabel.text = "\(calculator.result.description) \(resultStateIndicator)"
        }
    
}
