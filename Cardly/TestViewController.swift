//
//  TestViewController.swift
//  Cardly
//
//  Created by Kadir Duraklı on 24.01.2023.
//

import UIKit
import CoreData
protocol Delegate : AnyObject {
    func save(str: String, str2: String, str3: String, int: Int, str4: String)
}

class TestViewController: UIViewController {
    var frontArray = [String]()
    var behindArray = [String]()
    var num = Int()
    var truePoint : Int!
    var score : Int!
    var storedhighscore : Int!
    var falsePoint : Int!
    var result = ""
    
    @IBOutlet weak var backImage: UIImageView!
    @IBOutlet weak var Button: UIButton!
    @IBOutlet weak var behindLabel: UITextField!
    @IBOutlet weak var falseLabel: UILabel!
    @IBOutlet weak var trueLabel: UILabel!
    @IBOutlet weak var frontLabel: UILabel!
    weak var delegate : Delegate?
    override func viewDidLoad() {
        if score == nil {
            score = 0
        }
        super.viewDidLoad()
        truePoint = 0
        falsePoint = 0
        
        backImage.isUserInteractionEnabled = true
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backButton))
        backImage.addGestureRecognizer(gestureRecognizer)
        backImage.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        truePoint = 0
    }
    
    override func viewWillAppear(_ animated: Bool) {
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
        
        let controlNum = frontArray.count
        
        if (controlNum >= num) && (behindLabel.text == behindArray[num - 1]) {
            truePoint += 1
            trueLabel.text = "True: " + String(truePoint)
        }
        if (controlNum >= num) && (behindLabel.text != behindArray[num - 1]) {
            falsePoint += 1
            falseLabel.text = "False: " + String(falsePoint)
        }
        
        if (num == controlNum) {
            frontLabel.text = "Test Completed"
            behindLabel.isHidden = true
            Button.isHidden = true
            backImage.isHidden = false

            
            
            if (falsePoint == 0) && (truePoint != 0) {
                result = "Successfully completed."
            }
            
            else {
                result = "Practice more"
            }
          
            if (truePoint > score) {
                score = truePoint
            }
        }
        
        if (controlNum > num) {
            frontLabel.text = frontArray[num]
            num += 1
        }
        behindLabel.text = ""
    }
    
    @objc func backButton() {
        if let del = self.delegate {
            let txt = "True: " + String(truePoint)
            let txt2 = "False: " + String(falsePoint)
            let txt3 =  "High Score: " + String(score)
            let txt4 = score
            let txt5 = "Result: " + result
            
            del.save(str: txt, str2: txt2, str3: txt3, int: txt4!, str4: txt5)
            self.dismiss(animated: true)
        }
    }
}





