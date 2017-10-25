//
//  Lending.swift
//  Startup Weekend
//
//  Created by Caleb Scott on 10/23/17.
//  Copyright © 2017 Acceleration Apps. All rights reserved.
//

import UIKit

class Lending: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    @IBOutlet var ReThink: UIButton!
    @IBOutlet var Sure: UIButton!
    @IBOutlet var Next: UIButton!
    @IBOutlet var Days: UIButton!
    @IBOutlet var picker: UIPickerView!
    var pickerData: [String] = [String]()
    var Addition = ""
    @IBOutlet var Lend: UILabel!
var InputStr = ""
    @IBAction func Back(){
        if Input.count != 0{
            Input = Input.substring(to: Input.index(before: Input.endIndex))
            self.textFieldDidChange()
        }
    }
    @IBAction func B1(){
        Input = Input + "1"
        self.textFieldDidChange()
    }
    @IBAction func B2(){
        Input = Input + "2"
        self.textFieldDidChange()
    }
    @IBAction func B3(){
        Input = Input + "3"
        self.textFieldDidChange()
    }
    @IBAction func B4(){
        Input = Input + "4"
        self.textFieldDidChange()
    }
    @IBAction func B5(){
        Input = Input + "5"
        self.textFieldDidChange()
    }
    @IBAction func B6(){
        Input = Input + "6"
        self.textFieldDidChange()
    }
    @IBAction func B7(){
        Input = Input + "7"
        self.textFieldDidChange()
    }
    @IBAction func B8(){
        Input = Input + "8"
        self.textFieldDidChange()
    }
    @IBAction func B9(){
        Input = Input + "9"
        self.textFieldDidChange()
    }
    @IBAction func B0(){
        Input = Input + "0"
        self.textFieldDidChange()
    }

@IBAction func textFieldDidChange() {
    
    
    var Str = Input
    if Str?.count == 0{
        InputStr = "0.00"
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.Next.alpha = 0
        })
    }
    if Str?.count == 1 {
        InputStr = "0.0" + Str!
    }
    if Str?.count == 2 {
        InputStr = "0." + Str!
    }
    if Str!.count >= 3 {
        var Num = Double(Input)! / 100.00
        InputStr = String(Num)
        
        EndCost = Num * 1.06
        
        let count = (Str!.count) - 1
        let index = Str?.index((Str?.startIndex)!, offsetBy: count)
        
        if Str![index!] == "0"{
            InputStr = InputStr + "0"
        }
        if Str!.count > 0 {
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.Next.alpha = 1
            })
        }
    }
    


    InputStr = "$" + InputStr
    Lend?.text = InputStr

    print(Input)
}
  
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if row > 14 {
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.Days.alpha = 1
            })
        }else{
            UIView.animate(withDuration: 1.0, animations: { () -> Void in
                self.Days.alpha = 0
            })
            
        }
    }
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedStringKey.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedStringKey.foregroundColor:UIColor.white])
        return myTitle
    }

    override func viewDidLoad() {

        
        Days?.alpha = 0
        Next?.alpha = 0
        Sure?.layer.cornerRadius = 5
        ReThink?.layer.cornerRadius = 5
        Days?.layer.cornerRadius = 5
        var i = 0
        while i <= 365 {
            if i != 1  {
                Addition = String(i) + " Days"
                
            }else{
                Addition = String(i) + " Day"
                
            }
            i = i + 1
            pickerData.append(Addition)
            print(pickerData)
        // Connect data

        if Input == nil{
            Input = ""
        }

        }
        self.picker?.dataSource = self as! UIPickerViewDataSource;
        self.picker?.delegate = self as! UIPickerViewDelegate;
super.viewDidLoad()
    
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
}
