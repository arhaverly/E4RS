//
//  TutorialViewController.swift
//  E4RS
//
//  Created by Andrew Haverly on 9/3/19.
//  Copyright © 2019 Vanguard Logic LLC. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UIViewController, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    let colorArray = [ 0x000000, 0xfe0000, 0xff7900, 0xffb900, 0xffde00, 0xfcff00, 0xd2ff00, 0x05c000, 0x00c0a7, 0x0600ff, 0x6700bf, 0x9500c0, 0xbf0199, 0xffffff ]

    @IBOutlet weak var carLabel: UILabel!
    @IBOutlet weak var sirenLabel: UILabel!
    
    @IBAction func backButton(_ sender: Any) {
        let  vc =  self.navigationController?.viewControllers.filter({$0 is UartModuleViewController}).first
        navigationController?.popToViewController(vc!, animated: true)
    }
    
    @IBOutlet weak var arrowPicker: UIPickerView!
    @IBOutlet weak var circlePicker: UIPickerView!
    
    @IBOutlet weak var carSlider: UISlider!
    @IBAction func carChanged(_ sender: UISlider) {
        let step: Float = 1
        var roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        let max = colorArray.count - 1
        if Int(roundedValue) > max{
            roundedValue = Float(max)
        }
        print(uiColorFromHex(rgbValue: colorArray[Int(roundedValue)]))
        carLabel.textColor = uiColorFromHex(rgbValue: colorArray[Int(roundedValue)])
        UserDefaults.standard.set(colorArray[Int(roundedValue)], forKey: "car")
    }
    
    
    @IBOutlet weak var sirenSlider: UISlider!
    @IBAction func sirenChanged(_ sender: UISlider) {
        let step: Float = 1
        var roundedValue = round(sender.value / step) * step
        sender.value = roundedValue
        let max = colorArray.count - 1
        if Int(roundedValue) > max {
            roundedValue = Float(max)
        }
        sirenLabel.textColor = uiColorFromHex(rgbValue: colorArray[Int(roundedValue)])
        UserDefaults.standard.set(colorArray[Int(roundedValue)], forKey: "siren")
    }
    
    
    
    func uiColorFromHex(rgbValue: Int) -> UIColor {
        
        let red =   CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(rgbValue & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    var arrowData: [String] = [String]()
    var circleData: [String] = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Connect data:
        self.arrowPicker.delegate = self
        self.arrowPicker.dataSource = self
        
        self.circlePicker.delegate = self
        self.circlePicker.dataSource = self
        
        // Input the data into the array
        arrowData = ["simple", "andy"]
        circleData = ["compass", "compassWithDirections", "clock", "clockWithNumbers"]
        arrowPicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        let car_val = UserDefaults.standard.string(forKey: "car")
        if car_val != nil{
            let index = colorArray.firstIndex(of: Int(car_val!)!)!
            carSlider.value = Float(index)
            carLabel.textColor = uiColorFromHex(rgbValue: colorArray[index])
        } else{
            carSlider.value = 1
            carLabel.textColor = uiColorFromHex(rgbValue: colorArray[1])
        }
        
        let siren_val = UserDefaults.standard.string(forKey: "siren")
        if siren_val != nil{
            let index = colorArray.firstIndex(of: Int(siren_val!)!)!
            sirenSlider.value = Float(index)
            sirenLabel.textColor = uiColorFromHex(rgbValue: colorArray[index])
        } else{
            sirenSlider.value = 9
            sirenLabel.textColor = uiColorFromHex(rgbValue: colorArray[9])
        }
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        let defaults = UserDefaults.standard
        var arrow_pic = ""
        if defaults.string(forKey: "arrow") != nil {
            arrow_pic = defaults.string(forKey: "arrow")!
            if arrowData.firstIndex(of: arrow_pic) != nil{
                self.arrowPicker.selectRow(arrowData.firstIndex(of: arrow_pic)!, inComponent: 0, animated: false)
            }
        }
        
        var circle_pic = ""
        if defaults.string(forKey: "circle") != nil {
            circle_pic = defaults.string(forKey: "circle")!
            if circleData.firstIndex(of: circle_pic) != nil{
                self.circlePicker.selectRow(circleData.firstIndex(of: circle_pic)!, inComponent: 0, animated: false)
                print("circle")
            }
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == arrowPicker{
            return arrowData.count
        }
        if pickerView == circlePicker{
            return circleData.count
        }
        
        return arrowData.count
    }
    
    // The data to return fopr the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var string = ""
        if pickerView == arrowPicker{
            string = arrowData[row]
        } else if pickerView == circlePicker{
            string = circleData[row]
        }
        return NSAttributedString(string: string, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == arrowPicker{
            UserDefaults.standard.set(arrowData[row], forKey: "arrow")
            print("set arrow")
        }
        if pickerView == circlePicker{
            UserDefaults.standard.set(circleData[row], forKey: "circle")
            print("set circle")
        }
    }

        
}
