//
//  Env.swift
//  GraphLearning
//
//  Created by Atul Gupta on 10/04/16.
//  Copyright © 2016 EmergeTech Mobile Products & Services Pvt Ltd. All rights reserved.
//

import Foundation
import UIKit

class Env {
    
    static var iPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

