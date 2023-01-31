//
//  ViewController.swift
//  Cardly
//
//  Created by Kadir Duraklı on 17.01.2023.
//

import UIKit
import CoreData

class ViewController: UIViewController, Delegate{
    func save(str: String, str2: String, str3: String, int: Int, str4: String) {
        trueLabel.text = str
        falseLabel.text = str2
        highscoreLabel.text = str3
        highscore = int
        resultLabel.text = str4
    }
    
    @IBOutlet weak var lastTest: UIImageView!
    @IBOutlet weak var falseLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var trueLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var createImageView: UIImageView!
    @IBOutlet weak var testyourselfImageView: UIImageView!
    @IBOutlet weak var cardsImageView: UIImageView!
    
    var frontArray = [String]()
    var behindArray = [String]()
    var highscore = 0
    var truecount : Int!
    var falsecount : Int!
    let front = ""
    let behind = ""
    
    override func viewDidLoad() {
        if highscoreLabel.text == "High Score:"{
            highscoreLabel.text = "High Score: " + String(0)
        }
        
        self.view.bringSubviewToFront(self.resultLabel)
        self.view.bringSubviewToFront(self.falseLabel)
        self.view.bringSubviewToFront(self.trueLabel)
        self.view.bringSubviewToFront(self.highscoreLabel)
        super.viewDidLoad()
        
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
    
    func getData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
        fetchRequest.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(fetchRequest)
            
            for result in results as! [NSManagedObject] {
                if let front = result.value(forKey: "front") as? String {
                    self.frontArray.append(front)
                }
                if let behind = result.value(forKey: "behind") as? String {
                    self.behindArray.append(behind)
                }
            }
        } catch {
            print("error")
        }
    }
    
    @objc func create() {
        performSegue(withIdentifier: "tocreateVC", sender: nil)
    }
    
    @objc func gocards() {
        performSegue(withIdentifier: "tocardsVC", sender: nil)
    }
    
    @objc func gotest() { 
        getData()
        if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "testVC") as? TestViewController {
            if frontArray.count != 0 {
                vc.delegate = self
                self.present(vc, animated: true, completion: nil)
                vc.score = highscore
            }
            if frontArray.count == 0 {
                let alert = UIAlertController(title: "Error", message: "You don't have any cards.", preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default)
                alert.addAction(okButton)
                self.present(alert, animated: true)
            }
            frontArray.removeAll()
            behindArray.removeAll()
        }
    }
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "tocreateVC" {
            let destinationVC = segue.destination as! createViewController
            destinationVC.control = true
        }
    }
}
