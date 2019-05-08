//
//  Coordinable.swift
//  Coorinator
//
//  Created by Radislav Gaynanov on 23/02/2019.
//  Copyright © 2019 Radislav Gaynanov. All rights reserved.
//

import UIKit

protocol Coordinable: class {
    var nameCoordinator: String {get}
    var router: Routable {get}
    func start()
}
