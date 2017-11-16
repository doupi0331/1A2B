//
//  Constants.swift
//  1A2B
//
//  Created by Yi-Yun Chen on 2017/11/13.
//  Copyright © 2017年 Yi-Yun Chen. All rights reserved.
//

import UIKit

func MESSAGE(title: String, message: String) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "確認", style: .default, handler: nil)
    alert.addAction(okAction)
    return alert
}

func RESTART(title: String, message: String, vc: UIViewController) -> UIAlertController {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let okAction = UIAlertAction(title: "回到主畫面", style: .default) { (alert) in
        vc.dismiss(animated: true, completion: nil)
    }
    alert.addAction(okAction)
    return alert
}
