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
    
    static var uartTxCharacteristic: CBCharacteristic?
    static var uartTxCharacteristicWriteType: CBCharacteristicWriteType?
    
    
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
    
    private func write(data: Data, characteristic: CBCharacteristic, writeType: CBCharacteristicWriteType, _: ((Error?) -> Void)? = nil) {

        peripheral.writeValue(data, for: characteristic, type: writeType)
    }
    
    func sendData(data: Data){
        var offset = 0
        var writtenSize = 0
        let progress: ((Float)->Void)? = nil
        
        //let maxPacketSize = peripheral.maximumWriteValueLength(for: uartTxCharacteristicWriteType)
        let maxPacketSize = peripheral.maximumWriteValueLength(for: .withoutResponse)      // Use .withoutResponseevent if sending .withResponse or didWriteValueFor is not called when using a larger packet
//        let str = "what is up my dudes"
//        let data = str.data(using: .utf8)!
//        print(str)
        
        var counter = 0
        
        repeat {
            
            let packetSize = min(data.count-offset, maxPacketSize)
            let packet = data.subdata(in: offset..<offset+packetSize)
            let writeStartingOffset = offset
            
            
//            print("ayy lmao", txCharacteristic)
            if txCharacteristic != nil{
                print("inside")
                self.write(data: packet, characteristic: txCharacteristic!, writeType: CBCharacteristicWriteType.withResponse){ error in
                    writtenSize = writeStartingOffset
                    //            peripheral.writeValue(data, for: uartTxCharacteristic!, type: uartTxCharacteristicWriteType!){
                    print("im not sure what this program is doing")
                    if let error = error {
                        print("what is going on here!?!?!?!?!?!??!?!?!??!!?")
                        print("error", error)
                    } else {
                        writtenSize += packetSize
                        //                    if BlePeripheral.kDebugLog {
                        //                        UartLogManager.log(data: packet, type: .uartTx)
                        //                    }
                        print("sir, i think its the fish people")
                        print("written")
                    }
                    
                    if writtenSize >= data.count {
                        progress?(1)
                        //                    completion?(error)
                    }
                    else {
                        progress?(Float(writtenSize) / Float(data.count))
                    }
                }
                writtenSize = writeStartingOffset
                writtenSize += packetSize
            }else{
                print("no tx")
                peripheral.discoverServices([BLEService_UUID])
                guard let services = peripheral.services else {
                    return
                }
                //We need to discover the all characteristic
                for service in services {
//                    print(service)
                    peripheral.discoverCharacteristics(nil, for: service)
                    // bleService = service
                }
                counter += 1
                if counter % 5 == 0{
                    if blePeripheral != nil{
//                        print("Disconnected")
//                        cent?.cancelPeripheralConnection(blePeripheral!)
//                        print("Connecting")
//                        cent?.connect(blePeripheral!, options: nil)
//                        sleep(10)
                        
                    }
                    return
                }
//                peripheral.discoverCharacteristics(, for: peripheral.services![0])
            }
            offset += writtenSize
            print(offset, "data", data.count)
            
            sleep(1)
        } while offset < data.count
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Determine the file name
        
        var offset = 0
        var writtenSize = 0
        let progress: ((Float)->Void)? = nil
        
        //let maxPacketSize = peripheral.maximumWriteValueLength(for: uartTxCharacteristicWriteType)
        let maxPacketSize = peripheral.maximumWriteValueLength(for: .withoutResponse)      // Use .withoutResponseevent if sending .withResponse or didWriteValueFor is not called when using a larger packet
        
        
        let str1 = "hey there my guy"
        let data1 = str1.data(using: .utf8)!

        sendData(data: data1)
//
//        // !!!!!!!!!!!!!! SOME OF THIS IS GOOD. DO NOT DELETE ALL !!!!!!!!!!!!!!
//        let path = Bundle.main.path(forResource: "ascii", ofType: "")
////
//        if let stream:InputStream = InputStream(fileAtPath: path!) {
//            var buf:[UInt8] = [UInt8](repeating: 0, count: 20)
//            stream.open()
//            while true {
//                let len = stream.read(&buf, maxLength: buf.count)
//                
//                print(String(data: NSData(bytes: &buf, length: len) as Data, encoding: .utf8)!)
//                sendData(data: NSData(bytes: &buf, length: len) as Data)
//                
//                if len < buf.count {
//                    break
//                }
//            }
//            stream.close()
//        }
        
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
//                print(angle)
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

