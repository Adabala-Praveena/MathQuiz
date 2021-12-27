//
//  QuestionsViewController.swift
//  MathQuiz
//
//  Created by praveena on 26/11/21.
//

import Foundation
import UIKit

enum Operation:Int {
    case Add
    case Subtract
    case Multiply
    case Divide
    
    func symbol() -> String {
        switch(self) {
        case .Add:
            return "+"
        case .Subtract:
            return "-"
        case .Multiply:
            return "*"
        case .Divide:
            return "/"
        }
    }
    
    func calculate(firstNumber: Int, secondNumber: Int) -> Int {
        switch(self) {
        case .Add:
            return firstNumber + secondNumber
        case .Subtract:
            return firstNumber - secondNumber
        case .Multiply:
            return firstNumber * secondNumber
        case .Divide:
            return firstNumber / secondNumber
        }
    }
    
    func getRandomNumbers(result:Int) -> [Int]{
        switch(self) {
        case .Add:
            return [result - 1, result + 1, result + 2]
        case .Subtract:
            return [result - 1, -result , result + 1]
        case .Multiply:
            return [result + 1, result * 2 , result - 2]
        case .Divide:
            return [1/result, result + 1 , result + 5]
        }
    }
}

enum AnswerStatus:Int{
    case NotAnswered
    case Correct
    case Wrong
    
    var description : String{
        switch self{
        case .NotAnswered:
            return "NoAnswer"
        case .Correct:
            return "Right"
        case.Wrong:
            return "Wrong"
        }
    }
}

class QuestionsViewController : UIViewController{
    
    @IBOutlet weak var question: UILabel!
    @IBOutlet weak var ans1: UIButton!
    @IBOutlet weak var ans2: UIButton!
    @IBOutlet weak var ans3: UIButton!
    @IBOutlet weak var ans4: UIButton!
    @IBOutlet weak var quesNo: UILabel!
    @IBOutlet weak var timer: UILabel!
    
    var num1 : Int = 0
    var num2 : Int = 0
    var queNo: Int = 0
    var counter = 30
    lazy  var buttonsArr = [ans1,ans2,ans3,ans4]
    var status : AnswerStatus = AnswerStatus.NotAnswered
    var answers = [(String,AnswerStatus)](repeating: ("",AnswerStatus.NotAnswered), count: 15)
    var operation: Operation = Operation.Add
    var timer30Sec:Timer?
    
    var result: Int {
        return operation.calculate(firstNumber: num1 , secondNumber: num2)
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        buttonsArr.forEach{$0?.setBackgroundColor(color: .lightGray, forState: .selected)}
        buttonsArr.forEach{$0?.layer.borderWidth = 3.0}
        buttonsArr.forEach{$0?.layer.borderColor = UIColor.black.cgColor}
        buttonsArr.forEach{$0?.layer.cornerRadius = 5.0}
        buttonsArr.forEach{$0?.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)}
        
        goToNextQuestion()
    }
    
    func getRandomOperation() {
        let randomNum = Int(arc4random_uniform(3))
        operation = Operation(rawValue: randomNum) ?? Operation.Add
    }
    
    @objc func buttonAction(sender: UIButton!) {
        let btnsendtag: Int = sender.tag
        buttonsArr[btnsendtag]?.isSelected = true
        status = getUpdatedStatus(answer: sender.titleLabel?.text)
        answers[queNo-1] = (sender.titleLabel?.text ?? "", status)
        timer30Sec?.invalidate()
        if queNo < 15 {
            DispatchQueue.global().asyncAfter(deadline: .now() + 0.5, execute: {
                DispatchQueue.main.async {
                    self.goToNextQuestion()
                }
            })
        } else {
            goToResultsView()
        }

    }
    
    func getUpdatedStatus(answer: String?) -> AnswerStatus {
        guard let ans = answer, let value = Int(ans) else { return AnswerStatus.NotAnswered}
        if result == value {
            return AnswerStatus.Correct
        }
        return AnswerStatus.Wrong
    }
    
    func goToNextQuestion(){
        status = AnswerStatus.NotAnswered
        buttonsArr.forEach{$0?.isSelected = false}
        queNo += 1
        num1 = Int(arc4random_uniform(1000))
        num2 = Int(arc4random_uniform(1000))
        getRandomOperation()
        question.text = "\(num1) \(operation.symbol()) \(num2)"
        let answerNum = Int(arc4random_uniform(3))
        let randomAns = operation.getRandomNumbers(result: result)
        startTimer()
        switch answerNum{
        case 0:
            ans1.setTitle("\(result)", for: .normal)
            ans2.setTitle("\(randomAns[0])", for: .normal)
            ans3.setTitle("\(randomAns[1])", for: .normal)
            ans4.setTitle("\(randomAns[2])", for: .normal)
        case 1:
            ans1.setTitle("\(randomAns[0])", for: .normal)
            ans2.setTitle("\(result)", for: .normal)
            ans3.setTitle("\(randomAns[1])", for: .normal)
            ans4.setTitle("\(randomAns[2])", for: .normal)
        case 2:
            ans1.setTitle("\(randomAns[0])", for: .normal)
            ans2.setTitle("\(randomAns[1])", for: .normal)
            ans3.setTitle("\(result)", for: .normal)
            ans4.setTitle("\(randomAns[2])", for: .normal)
        case 3:
            ans1.setTitle("\(randomAns[0])", for: .normal)
            ans2.setTitle("\(randomAns[1])", for: .normal)
            ans3.setTitle("\(randomAns[2])", for: .normal)
            ans4.setTitle("\(result)", for: .normal)
        default:
            break
            
        }
        quesNo.text = "Q : \(queNo)"
    }
    
    func startTimer() {
        self.counter = 30
        timer.text = "00:\(counter)"
        timer30Sec = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(QuestionsViewController.update), userInfo: nil, repeats: true)
    }
    
    @objc func update() {
            if counter > 0 {
                counter -= 1
                timer.text = "00:\(counter)"
            } else {
                answers[queNo-1] = ( "", status)
                timer30Sec?.invalidate()
                queNo < 15 ? goToNextQuestion() : goToResultsView()
            }
    }
    func goToResultsView(){
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let rvc = mainStoryBoard.instantiateViewController(withIdentifier: "ResultsViewController") as? ResultsViewController
        rvc?.inputData = answers
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController = rvc
    }
}


extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControl.State) {
        self.clipsToBounds = true
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        if let context = UIGraphicsGetCurrentContext() {
            context.setFillColor(color.cgColor)
            context.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
            let colorImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            self.setBackgroundImage(colorImage, for: forState)
        }
    }
}
