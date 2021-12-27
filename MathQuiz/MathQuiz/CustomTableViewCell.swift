//
//  CustomTableViewCell.swift
//  MathQuiz
//
//  Created by praveena on 26/11/21.
//

import Foundation
import UIKit
class CustomTableViewCell:UITableViewCell{
    
    @IBOutlet weak var queNo: UILabel!
    @IBOutlet weak var answer: UILabel!
    
    @IBOutlet weak var status: UILabel!
    func updateText(queNo:Int?, ans: String, ansStatus: Int, score: Int?){
        if queNo != nil {
        let str = "Q\(queNo!)"
        let font:UIFont? = UIFont(name: "Helvetica", size:20)
        let fontSub:UIFont? = UIFont(name: "Helvetica", size:10)
        let attString:NSMutableAttributedString = NSMutableAttributedString(string: str, attributes: [.font:font!])
        attString.setAttributes([.font:fontSub!,.baselineOffset:-5], range: NSRange(location:1,length:str.count-1))
            self.queNo.attributedText = attString
        } else {
            self.queNo.text = "Score"
        }
        answer.text = ans
        guard score == nil else {
            status.text = "\(score!)/15"
            return
        }
        status.text = AnswerStatus(rawValue: ansStatus)?.description
    }
}
