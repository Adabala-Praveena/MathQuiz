//
//  ViewController.swift
//  MathQuiz
//
//  Created by praveena on 26/11/21.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBAction func startQuiz(_ sender: Any) {
        let mainStoryBoard = UIStoryboard(name: "Main", bundle: nil)
        let qvc = mainStoryBoard.instantiateViewController(withIdentifier: "QuestionsViewController")
        let keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .compactMap({$0 as? UIWindowScene})
                .first?.windows
                .filter({$0.isKeyWindow}).first
        keyWindow?.rootViewController = qvc
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.        
        startButton.layer.cornerRadius = 10.0
    }


}

