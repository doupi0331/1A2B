//
//  GameVC.swift
//  1A2B
//
//  Created by Yi-Yun Chen on 2017/11/13.
//  Copyright © 2017年 Yi-Yun Chen. All rights reserved.
//

import UIKit
import GameplayKit

class GameVC: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var number4Image: UIImageView!
    @IBOutlet weak var number3Image: UIImageView!
    @IBOutlet weak var number2Image: UIImageView!
    @IBOutlet weak var number1Image: UIImageView!
    @IBOutlet weak var timesLabel: UILabel!
    @IBOutlet weak var answerText: UITextField!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    
    var times = 0
    var correctAnswer: [String] = ["","","",""]
    var record: String = ""
    var keyboardHeight = CGFloat()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        answerText.delegate = self
        
        // 產生題目
        createNumbers()
        
        // scrollView 設定
        scrollView.contentSize = answersLabel.bounds.size
        scrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: NSNotification.Name.UIKeyboardWillShow,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: NSNotification.Name.UIKeyboardWillHide,
            object: nil
        )
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
            self.view.frame = CGRect(x: 0.0, y: -keyboardHeight, width: self.view.frame.width, height: self.view.frame.size.height)
            //print(keyboardHeight)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {
        self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitPressed(_ sender: Any) {
        if let answer = answerText.text {
            if answer.count == 4 {
                var a = 0
                var b = 0
                var i = 0
                times += 1
                timesLabel.text = "\(times)"
                
                // 檢查答案
                for char in answer {
                    let number = String(char)
                    if correctAnswer[i] == number {
                        // 檢查Ａ
                        a += 1
                    } else if correctAnswer.contains(number) {
                        // 檢查Ｂ
                        b += 1
                    }
                    i += 1
                }
                
                // 是否答對
                if a == 4 {
                    // 答對了,回到主畫面
                    correct()
                } else {
                    // 記錄每次的回答
                    recordAnswer(answer: answer, a: a, b: b)
                }
                
            } else {
                let alert = MESSAGE(title: "", message: "請輸入四個不同的數字")
                self.present(alert, animated: true, completion: nil)
            }
        }
        self.view.endEditing(true)
    }
    
    func createNumbers() {
        let randomDistribution = GKShuffledDistribution(lowestValue: 0, highestValue: 9)
        for i in 0...correctAnswer.count-1 {
            correctAnswer[i] = "\(randomDistribution.nextInt())"
        }
        print(correctAnswer)
    }
    
    func correct() {
        switch times {
        case 0...5:
            commentLabel.text = "Excellent"
        case 6...10:
            commentLabel.text = "Great"
        default:
            commentLabel.text = "Good"
        }
        number1Image.image = UIImage(named:correctAnswer[0])
        number2Image.image = UIImage(named:correctAnswer[1])
        number3Image.image = UIImage(named:correctAnswer[2])
        number4Image.image = UIImage(named:correctAnswer[3])
        commentView.isHidden = false
    }
    
    func recordAnswer(answer: String, a: Int, b: Int) {
        record = "\(times). \(answer) -- \(a)A\(b)B \n" + record
        answersLabel.text = record
        answerText.text = ""
    }
    
    // 數字最多只可輸入四個
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 4
    }

}
