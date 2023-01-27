//
//  TestViewController.swift
//  Cardly
//
//  Created by Kadir Duraklı on 24.01.2023.
//

import UIKit
import CoreData

class TestViewController: UIViewController {
    var frontArray = [String]()
    var behindArray = [String]()
    var num = Int()
    var truePoint = Int()
    var score : Int!
    var storedhighscore : Int!
    var falsePoint = Int()
    

    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var behindLabel: UITextField!
    @IBOutlet weak var falseLabel: UILabel!
    @IBOutlet weak var trueLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    override func viewDidLoad() {
        if score == nil {
            score = 0
        }
        
        super.viewDidLoad()
        self.navigationItem.leftBarButtonItems = [UIBarButtonItem(title: "back", style: .plain, target: self, action: #selector(backButton))]
                
        
        
        // Do any additional setup after loading the view.
    }
    
   
    
    
    override func viewDidDisappear(_ animated: Bool) {
        truePoint = 0
        
    
        print("score" + String(score))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if score != nil {
            print("scoree" + String(score))
        }
        getData()
        num = 1
        trueLabel.text = "True: "
        falseLabel.text = "False: "
        frontLabel.text = frontArray[0]
        
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
    
   
    
    @IBAction func checkButton(_ sender: Any) {
        var controlNum = frontArray.count
        
        
        if (controlNum >= num) && (behindLabel.text == behindArray[num - 1]) {
            print("success bro")
            truePoint += 1
            trueLabel.text = String(truePoint)
            
        }
        
        if (num == controlNum) {
            frontLabel.text = "Test Completed"
            behindLabel.isHidden = true
            Button.isHidden = true
            if (truePoint > score) {
                score = truePoint
                
               
                print("hata" + String((score)))
            }
            
        }
        if (controlNum >= num) && (behindLabel.text != behindArray[num - 1]) {
            falsePoint += 1
            falseLabel.text = String(falsePoint)
        }
        
        
        
        if (controlNum > num) {
            print(frontArray[num - 1])
            print(behindArray[num - 1])
            frontLabel.text = frontArray[num]
            num += 1
        }
    }
    
    @objc func backButton() {
        
        
        
        
        self.navigationController?.popViewController(animated: true)
       
        
        
        
        print("segue" + String(score))
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(score)
        if (segue.identifier == "vc") && (truePoint > score) {
            
            
            print("suu")
            let destinationVC = segue.destination as! ViewController
            
            destinationVC.highscore = score
            
        }
        if (segue.identifier == "vc") && (truePoint <= score) {
            
            
            let destinationVC = segue.destination as! ViewController
            destinationVC.highscore = score
            destinationVC.truecount = truePoint
            destinationVC.falsecount = falsePoint
            print("ikincisegue" + String(score))
        }
    }
    
    
    
  
    }





