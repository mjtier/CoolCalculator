//
//  ViewController.swift
//  CoolCalculator
//
//  Created by Michael Tier on 6/28/21.
//

import UIKit

class ViewController: UIViewController {
    
    private let NUMBER_HORIZONTAL_STACKVIEWS : Int = 7
    
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
    
    
    private var resultLabel: UILabel = {
        let label = UILabel()
        label.text = "0"
        label.textColor = .white
        label.textAlignment = .right
        label.font = UIFont(name: "AvenirNext-DemiBoldItalic", size: 30)
        label.layoutMargins = UIEdgeInsets(top:10,left:10,bottom:10,right:100)
        return label
    }()
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
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
    // StackView 1 contains no view elements and is left blank intentioally for spacing
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
                continue
            // Do nothing for stackview 1. Blank left for padding
            case 2:
                // Add the results text lablt display to the second stackview from the top and add padding in it
                horizontalStack.layoutMargins = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 20)
                horizontalStack.isLayoutMarginsRelativeArrangement = true
                horizontalStack.addArrangedSubview(resultLabel)
            case 3...7: // Add the buttons to all the bottom 5 rows
                addButtonsToHorizontalStack(horizontalStackView: horizontalStack, forRowAt: stackNumber)
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
        // maybe set tag ?
        return button
    }
    
    
    // maybe create function that assigns event handler based upon the button model

}

