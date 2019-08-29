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
    @IBAction func testButton(_ sender: Any) {
        flashView.backgroundColor = UIColor.white;
    }
    //Data
    var peripheralManager: CBPeripheralManager?
    var peripheral: CBPeripheral!
    private var consoleAsciiText:NSAttributedString? = NSAttributedString(string: "")
    
    var colorDict:[String:UIColor] = ["h":UIColor.red, "s":UIColor.blue]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title:"Back", style:.plain, target:nil, action:nil)
        //Create and start the peripheral manager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        //-Notification for updating the text view with incoming text
        updateIncomingData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        // peripheralManager?.stopAdvertising()
        // self.peripheralManager = nil
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self)
        
    }
    
    func updateIncomingData () {
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: "Notify"), object: nil , queue: nil){
            notification in
            let appendString = "\n"
            let myFont = UIFont(name: "Helvetica Neue", size: 15.0)
            let myAttributes2 = [NSAttributedString.Key.font: myFont!, NSAttributedString.Key.foregroundColor: UIColor.red]
            let attribString = NSAttributedString(string: "[Incoming]: " + (characteristicASCIIValue as String) + appendString, attributes: myAttributes2)
            let newAsciiText = NSMutableAttributedString(attributedString: self.consoleAsciiText!)

            
            newAsciiText.append(attribString)
            
            self.consoleAsciiText = newAsciiText
            self.infoLabel.text = characteristicASCIIValue as String
            
            let info = String(characteristicASCIIValue)
            
            if info.lengthOfBytes(using: String.Encoding.utf8) > 4{
                let latestInfo = info.suffix(4)
                let hypo = String(latestInfo.prefix(1))
                self.flashView.backgroundColor = self.colorDict[hypo]
                
                let angle = Int(latestInfo.suffix(3))!
                print(angle)
                    self.arrow.transform = CGAffineTransform(rotationAngle: -1*CGFloat(angle)*CGFloat.pi/180 + CGFloat.pi)
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

