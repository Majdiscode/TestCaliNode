//
//  Application.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/9/25.
//

//
//  Application.swift
//  TestCaliNode
//
//  Created by Majd Iskandarani on 5/9/25.
//

import SwiftUI
import UIKit

final class Application_utility{
    static var rootViewController: UIViewController{
        guard let screen = UIApplication.shared.connectedScenes.first as? UIWindowScene else{
            return .init()
            
        }
        
        guard let root = screen.windows.first?.rootViewController else {
            return .init()
        }
        
        return root
    }
    
    
}
