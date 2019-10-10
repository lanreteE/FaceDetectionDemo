//
//  NextViewController.swift
//  人脸识别两种方式
//
//  Created by 王译 on 2019/9/28.
//  Copyright © 2019 王译. All rights reserved.
//

import UIKit

class NextViewController: UIViewController {
    var imgView = UIImageView()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "结果"
        imgView.frame = self.view.frame
        self.view.addSubview(imgView)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
