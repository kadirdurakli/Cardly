//
//  ViewController.swift
//  Cardly
//
//  Created by Kadir Duraklı on 17.01.2023.
//

import UIKit

class ViewController: UIViewController {
    
    
    @IBOutlet weak var lastTest: UIImageView!
    @IBOutlet weak var falseLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var trueLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var createImageView: UIImageView!
    @IBOutlet weak var testyourselfImageView: UIImageView!
    @IBOutlet weak var cardsImageView: UIImageView!
    var highscore : Int!
    var truecount : Int!
    var falsecount : Int!
    let front = ""
    let behind = ""
    override func viewDidLoad() {
        
        self.view.bringSubviewToFront(self.resultLabel)
        self.view.bringSubviewToFront(self.falseLabel)
        self.view.bringSubviewToFront(self.trueLabel)
        self.view.bringSubviewToFront(self.highscoreLabel)
        super.viewDidLoad()
        
        if highscore != nil {
            highscoreLabel.text = "High Score: " + String(highscore)
        }
        else {
            highscoreLabel.text = "High Score:"
        }
        if truecount != nil {
            trueLabel.text = "True: " + String(truecount)
        }
        else {
            trueLabel.text = "True:"
        }
        if falsecount != nil {
            falseLabel.text = "False: " + String(falsecount)
        }
        else {
            falseLabel.text = "False:"
        }
        
        
        
        
        //Recognizers
        createImageView.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(create))
        createImageView.addGestureRecognizer(gestureRecognizer)
        
        cardsImageView.isUserInteractionEnabled = true
        let secondRecognizer = UITapGestureRecognizer(target: self, action: #selector(gocards))
        cardsImageView.addGestureRecognizer(secondRecognizer)
        
        testyourselfImageView.isUserInteractionEnabled = true
        let thirdRecognizer = UITapGestureRecognizer(target: self, action: #selector(gotest))
        testyourselfImageView.addGestureRecognizer(thirdRecognizer)
    }
    
    
    @objc func create() {
        performSegue(withIdentifier: "tocreateVC", sender: nil)
        print("oke")
    }
    
    @objc func gocards() {
        performSegue(withIdentifier: "tocardsVC", sender: nil)
    }
    
    @objc func gotest() {
        performSegue(withIdentifier: "totestVC", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "totestVC") && highscore != 0 {
            let destinationVC = segue.destination as! TestViewController
            destinationVC.score = highscore
        }
        if segue.identifier == "tocreateVC" {
            let destinationVC = segue.destination as! createViewController
            destinationVC.control = true
            
        }
        
        
        
        
    }
    
    
}
