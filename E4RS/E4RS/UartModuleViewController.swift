//
//  UartModuleViewController.swift
//  E4RS
//
//  Created by Trevor Beaton on 12/4/16.
//  Copyright © 2016 Vanguard Logic LLC. All rights reserved.
//

import UIKit
import CoreBluetooth

class UartModuleViewController: UIViewController, CBPeripheralManagerDelegate, UITextViewDelegate, UITextFieldDelegate {
    
    //UI
    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var circle: UIImageView!
    @IBOutlet weak var arrow: UIImageView!
    @IBOutlet weak var flashView: UIView!
    
    @IBAction func backButton(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    //Data
    var peripheralManager: CBPeripheralManager?
    var peripheral: CBPeripheral!
    private var consoleAsciiText:NSAttributedString? = NSAttributedString(string: "")
    
    var colorDict:[String:UIColor] = ["h":UIColor.red, "s":UIColor.blue]
    var noiseDict:[String:String] = ["h":"Car Horn", "s":"Siren"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
        
        var arrow_pic = "arrow"
        let defaults = UserDefaults.standard
        if defaults.string(forKey: "arrow") != nil {
            arrow_pic = defaults.string(forKey: "arrow")!
        }
        var image : UIImage = UIImage(named:arrow_pic)!
        self.arrow.image = image
        
        var circle_pic = "compass"
        if defaults.string(forKey: "circle") != nil {
            circle_pic = defaults.string(forKey: "circle")!
        }
        image = UIImage(named:circle_pic)!
        self.circle.image = image
        
        if defaults.string(forKey: "car") != nil {
            let car_color = defaults.string(forKey: "car")!
            colorDict["h"] = uiColorFromHex(rgbValue: Int(car_color)!)
        }
        
        if defaults.string(forKey: "siren") != nil {
            let siren_color = defaults.string(forKey: "siren")!
            colorDict["s"] = uiColorFromHex(rgbValue: Int(siren_color)!)
        }
        
        //Create and start the peripheral manager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        //-Notification for updating the text view with incoming text
        updateIncomingData()
    }
    
    func uiColorFromHex(rgbValue: Int) -> UIColor {
        
        let red =   CGFloat((rgbValue & 0xFF0000) >> 16) / 0xFF
        let green = CGFloat((rgbValue & 0x00FF00) >> 8) / 0xFF
        let blue =  CGFloat(rgbValue & 0x0000FF) / 0xFF
        let alpha = CGFloat(1.0)
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)

        UserDefaults.standard.set("", forKey: "peripheral")

    }
    
    func updateIncomingData () {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Notify"), object: nil , queue: nil){
            notification in
            

            self.infoLabel.text = String(String(characteristicASCIIValue).suffix(4))

            let info = String(characteristicASCIIValue)

            if info.lengthOfBytes(using: String.Encoding.utf8) > 3 {
                let latestInfo = info.suffix(4)
                self.infoLabel.text = self.noiseDict[String(String(latestInfo).prefix(1))]
                let hypo = String(latestInfo.prefix(1))
                self.flashView.backgroundColor = self.colorDict[hypo]
                self.flashView.alpha = 1.0
                self.infoLabel.alpha = 1.0
                self.arrow.alpha = 1.0
                
                let angle = Int(latestInfo.suffix(3))!
                print(angle)
                self.arrow.transform = CGAffineTransform(rotationAngle: -1*CGFloat(angle)*CGFloat.pi/180 + CGFloat.pi)
                UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
                    self.flashView.alpha = 0.0
                }, completion: nil)
                UIView.animate(withDuration: 0.5, delay: 1.5, options: .curveEaseOut, animations: {
                    self.infoLabel.alpha = 0.0
                    self.arrow.alpha = 0.0
                }, completion: nil)
            }
        }
    }

    
    
    func peripheralManagerDidUpdateState(_ peripheral: CBPeripheralManager) {
        if peripheral.state == .poweredOn {
            return
        }
        print("Peripheral manager is running")
    }
    
    //Check when someone subscribe to our characteristic, start sending the data
    func peripheralManager(_ peripheral: CBPeripheralManager, central: CBCentral, didSubscribeTo characteristic: CBCharacteristic) {
        print("Device subscribe to characteristic")
    }

    func peripheralManagerDidStartAdvertising(_ peripheral: CBPeripheralManager, error: Error?) {
        if let error = error {
            print("\(error)")
            return
        }
    }
}

