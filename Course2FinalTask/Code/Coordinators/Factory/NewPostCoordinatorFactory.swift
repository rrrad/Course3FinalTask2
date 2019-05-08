//
//  NewPostCoordinatorFactory.swift
//  Course2FinalTask
//
//  Created by Radislav Gaynanov on 23/03/2019.
//  Copyright © 2019 e-Legion. All rights reserved.
//

import Foundation

protocol NewPostCoordinatorFactoryProtocol {
    func makeFirstViewController() -> Presentable & NewPostViewControllerOutputProtocol & NewPostViewControllerInputProtocol
    func makeFilterViewController() -> Presentable & FilterViewControllerOutputProtocol & FilterViewControllerInputProtocol
    func makeDescribePostViewController() -> Presentable & DescribePostViewControllerOutputProtocol & DescribePostViewControllerInputProtocol
    
}

class NewPostCoordinatorFactory: NewPostCoordinatorFactoryProtocol {
    func makeFirstViewController() -> Presentable & NewPostViewControllerOutputProtocol & NewPostViewControllerInputProtocol {
        return NewPostViewController.init()
    }
    
    func makeFilterViewController() -> Presentable & FilterViewControllerOutputProtocol & FilterViewControllerInputProtocol {
        return FilterViewController.init()
    }
    
    func makeDescribePostViewController() -> Presentable & DescribePostViewControllerOutputProtocol & DescribePostViewControllerInputProtocol {
        return DescribePostViewController.init()
    }
}

