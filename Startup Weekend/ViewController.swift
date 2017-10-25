//
//  ViewController.swift
//  Startup Weekend
//
//  Created by Caleb Scott on 10/21/17.
//  Copyright © 2017 Acceleration Apps. All rights reserved.
//

import UIKit
var EndCost: Double!
var Input: String!

class ViewController: UIViewController {
    @IBOutlet weak var myDatePicker: UIDatePicker!
    var InputStr: String!
    @IBOutlet var Money: UILabel!
    @IBOutlet var Oct3: UIButton!
    @IBOutlet var Oct27: UIButton!
    @IBOutlet var labl: UILabel!
    @IBOutlet var EndCostL: UILabel!
    @IBOutlet var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet var Next: UIButton!
    @IBOutlet var Take: UIButton!
    var blurEffectView: UIVisualEffectView!

    @IBAction func Back(){
        if Input.count != 0{
        Input = Input.substring(to: Input.index(before: Input.endIndex))
        self.textFieldDidChange()
        }
    }
    @IBAction func The27(){
        Take?.isHidden = false
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.Oct3?.layer.cornerRadius = 0
            self.Oct3.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            self.Oct3?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        })
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.Oct27?.layer.cornerRadius = (self.Oct27?.frame.width)!/2
            self.Oct27.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            self.Oct27?.backgroundColor = UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1)
        })
    }
    @IBAction func The3(){
        Take?.isHidden = false
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.Oct3?.layer.cornerRadius = (self.Oct3?.frame.width)!/2
            self.Oct3.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
            self.Oct3?.backgroundColor = UIColor(red: 241/255, green: 196/255, blue: 15/255, alpha: 1)

        })
        if Oct27?.layer.cornerRadius != 0 {
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.Oct27?.layer.cornerRadius = 0
            self.Oct27.titleLabel?.font = UIFont.systemFont(ofSize: 17)
            self.Oct27?.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        })
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
    @objc func Stop(){
        UIView.animate(withDuration: 1.0, animations: { () -> Void in
            self.blurEffectView.alpha = 0
        })
        
        var Str = Input
        if Str?.count == 0{
            InputStr = "0.00"
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
            
            
        }
        InputStr = "$" + InputStr
        EndCostL.text = InputStr
        print(Input)
        
        activityIndicatorView.stopAnimating()
    }
    override func viewDidLoad() {
        
        if Input == nil{
            Input = ""
        }
        if EndCost != nil{
            var Str = String(EndCost)
            if Str.count == 0{
                InputStr = "0.00"
            }
            if Str.count == 1 {
                InputStr = "0.0" + Str
            }
            if Str.count == 2 {
                InputStr = "0." + Str
            }
            if Str.count >= 3 {
                var Num = String(EndCost)
                InputStr = Num


                let count = (Str.count) - 1
                let index = Str.index((Str.startIndex), offsetBy: count)

                if Str[index] == "0"{
                    InputStr = InputStr + "0"
                }
                

            }
            InputStr = "$" + InputStr
            EndCostL?.text = InputStr
            print(Input)
            if InputStr != "$0.00"{
//                Next.isHidden = false
            }else{
//                Next.isHidden = true
            }
        }

       
        
        if self.title == "Congratulations!" {
            
            let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
            blurEffectView = UIVisualEffectView(effect: blurEffect)
            blurEffectView.frame = view.bounds
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            view.addSubview(blurEffectView)
            activityIndicatorView.startAnimating()
            view.addSubview(activityIndicatorView)

            Timer.scheduledTimer(timeInterval: TimeInterval(1.73), target: self, selector: #selector(Stop), userInfo: nil, repeats: false)

        }
        
        
        
        
        
        
        Take?.layer.cornerRadius = 10
labl?.layer.cornerRadius = (labl?.frame.height)!/2
        myDatePicker?.setValue(UIColor.white, forKeyPath: "textColor")
        
//        let gradient: CAGradientLayer = CAGradientLayer()
//        let colorTop =  UIColor(red: 0/255.0, green: 0/255.0, blue: 155.0/255.0, alpha: 1.0).cgColor
//        let colorBottom = UIColor(red: 0.0/255.0, green: 128.0/255.0, blue: 255.0/255.0, alpha: 1.0).cgColor
//
//        gradient.colors = [colorTop, colorBottom]
//        gradient.locations = [0.0 , 1.5]
//        gradient.startPoint = CGPoint(x: 0.0, y: 1.0)
//        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
//        gradient.frame = CGRect(x: 0.0, y: 0.0, width: self.view.frame.size.width, height: self.view.frame.size.height)
        
//        self.view.layer.insertSublayer(gradient, at: 0)
        
        myDatePicker?.datePickerMode = .date
//        var gradientLayer: CAGradientLayer!
//        gradientLayer = CAGradientLayer()
//
//        gradientLayer.frame = self.view.bounds
//
//        gradientLayer.colors = [UIColor.red.cgColor, UIColor.yellow.cgColor]
//
//        self.view.layer.addSublayer(gradientLayer)
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
   @IBAction func textFieldDidChange() {
    Oct3?.layer.masksToBounds = true


    var Str = Input
    if Str?.count == 0{
        InputStr = "0.00"
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
        
        EndCost = Num * 1.1
        
        let count = (Str!.count) - 1
        let index = Str?.index((Str?.startIndex)!, offsetBy: count)
        
        if Str![index!] == "0"{
            InputStr = InputStr + "0"
        }
        
        
    }
 
        
    
    InputStr = "$" + InputStr
    Money.text = InputStr
        print(Input)
    if InputStr != "$0.00"{
        Next.isHidden = false
    }else{
        Next.isHidden = true
    }
    }
    @IBAction func datePickerAction(sender: AnyObject) {
        
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy HH:mm"
        let strDate = dateFormatter.string(from: myDatePicker.date)
        self.selectedDate?.text = strDate
        print(strDate)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }




}


