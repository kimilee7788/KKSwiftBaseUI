//
//  ViewController.swift
//  KKSwiftBaseUI
//
//  Created by kimilee123@hotmail.com on 06/21/2021.
//  Copyright (c) 2021 kimilee123@hotmail.com. All rights reserved.
//

import UIKit
import KKSwiftBaseUI
import KKSwiftLib
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
        KMPhoto.writeText(text: "abc", name:"cba")
        
        let view = KMView.init()
        view.frame = CGRect.init(x: 50, y: 50, width: 111, height: 111)
        view.backgroundColor = UIColor.orange
        self.view.addSubview(view)
        
//        DispatchQueue.main.after(1) {
//            let a = KMWebViewController.init()
//            a.url = "http://www.google.com"
//            self.present(a, animated: true) {
//            }
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

