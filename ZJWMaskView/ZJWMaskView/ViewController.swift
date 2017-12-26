//
//  ViewController.swift
//  ZJWMaskView
//
//  Created by 赵建卫 on 2017/12/26.
//  Copyright © 2017年 赵建卫. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let maskView = SingleMaskView()
        maskView.addTransparentOvalRect(rect: CGRect(x: 100, y: 100, width: 50, height: 50))
        maskView.addTransparentOvalRect(rect: CGRect(x: 100, y: 200, width: 100, height: 50))
        maskView.addTransparentRect(rect: CGRect(x: 100, y: 300, width: 50, height: 50), radius: 15)
        maskView.addTransparentRect(rect: CGRect(x: 100, y: 400, width: 50, height: 50), radius: 0)
        
        //嵌套组合
        maskView.addTransparentOvalRect(rect: CGRect(x: 100, y: 500, width: 50, height: 50))
        maskView.addTransparentRect(rect: CGRect(x: 100, y: 500, width: 50, height: 50), radius: 0)
        
        maskView.showMaskViewInView(view: self.view)
    }
}

