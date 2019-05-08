//
//  ViewController.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 24/02/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit
protocol ViewControllerOutputProtocol {
    var callBack: (() -> Void)? {get set}
}

class ViewController: UIViewController, ViewControllerOutputProtocol {
        
        // MARK: - Intput -
        private var titleButton: String
        private var backColor: UIColor
        
        // MARK: - Output -
        var callBack: (() -> Void)?
        
    init(name: String) {
            titleButton = name
            backColor = UIColor().randomColor()
            super.init(nibName: nil, bundle: nil)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = backColor
            let button = UIButton.init(type: .system)
            button.setTitle(titleButton, for: .normal)
            button.backgroundColor = UIColor.brown
            button.frame = CGRect.init(x: view.center.x - 50, y: view.center.y - 25, width: 100, height: 50)
            button.addTarget(self, action: #selector(press), for: .touchUpInside)
            view.addSubview(button)
        }
        
        @objc
        func press(){
            dismiss(animated: false, completion: nil)
        }
        
}
