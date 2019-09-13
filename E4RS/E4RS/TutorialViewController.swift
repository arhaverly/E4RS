//
//  TutorialViewController.swift
//  E4RS
//
//  Created by Andrew Haverly on 9/3/19.
//  Copyright © 2019 Vanguard Logic LLC. All rights reserved.
//

import Foundation
import UIKit

class TutorialViewController: UIViewController, UITextViewDelegate, UITextFieldDelegate {
    
    override func viewDidDisappear(_ animated: Bool) {
        UserDefaults.standard.set("true", forKey: "info_read")
    }



}
