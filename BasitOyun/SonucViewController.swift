//
//  SonucViewController.swift
//  BasitOyun
//
//  Created by utku enes alagöz on 11.10.2022.
//

import UIKit

class SonucViewController: UIViewController {
    
    
    
    @IBOutlet weak var anlıkSonucLabel: UILabel!
    
    @IBOutlet weak var yuksekSonucLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let d = UserDefaults.standard
        
        let anlikSkor = d.integer(forKey: "anlikSkor")
        let yuksekSkor = d.integer(forKey: "yuksekSkor")
        
        anlıkSonucLabel.text = "\(anlikSkor)"
        
        if anlikSkor > yuksekSkor {
            d.set(anlikSkor, forKey: "yuksekSkor")
            yuksekSonucLabel.text = "\(anlikSkor)"
        }else{
            yuksekSonucLabel.text = "\(yuksekSkor)"
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }

    @IBAction func tekrarOyna(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
