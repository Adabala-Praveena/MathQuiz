//
//  ResultsViewController.swift
//  MathQuiz
//
//  Created by praveena on 26/11/21.
//

import Foundation
import UIKit
class ResultsViewController: UITableViewController{
    public var inputData: [(String,AnswerStatus)] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "CustomTableViewCell", bundle: .main), forCellReuseIdentifier: "CustomTableViewCell")
        let customView = UIView(frame: CGRect(x: 0, y: 0, width: 200, height: 50))
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        button.setTitle("Done", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 30)
        button.layer.cornerRadius = 10.0
        button.layer.borderColor = UIColor.systemGreen.cgColor
        button.layer.borderWidth = 3.0
        button.backgroundColor = UIColor.systemGreen
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        customView.addSubview(button)
        tableView.tableFooterView = customView
    }
    
    @objc func buttonAction(_ sender: UIButton!) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let qvc = mainStoryBoard.instantiateViewController(withIdentifier: "ViewController")
        let keyWindow = UIApplication.shared.connectedScenes
            .filter({$0.activationState == .foregroundActive})
            .compactMap({$0 as? UIWindowScene})
            .first?.windows
            .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController = qvc
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inputData.count + 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell else {
            return UITableViewCell()
        }
        let quesNo = indexPath.row
        if quesNo != inputData.count{
            let data = inputData[quesNo]
            cell.updateText(queNo: quesNo + 1, ans: data.0, ansStatus: data.1.rawValue, score: nil)}
        else {
            let score = inputData.filter{$0.1 == AnswerStatus.Correct}.count
            cell.updateText(queNo: nil, ans: "", ansStatus: AnswerStatus.NotAnswered.rawValue,score: score)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50
        
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 75))
        
        let label = UILabel()
        label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
        label.text = "Results"
        label.font = .systemFont(ofSize: 40)
        label.textColor = .black
        label.textAlignment = .center
        headerView.addSubview(label)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
}
