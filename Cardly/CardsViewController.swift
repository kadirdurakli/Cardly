//
//  CardsViewController.swift
//  Cardly
//
//  Created by Kadir Duraklı on 17.01.2023.
//

import UIKit
import CoreData

class CardsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var frontArray = [String]()
    var idArray = [UUID]()
    var behindArray = [String()]
    var chosenname = ""
    var chosennamebehind = ""
    var chosennameid : UUID?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getData()
      }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(getData), name: NSNotification.Name(rawValue: "newData"), object: nil)
    }
    
    @objc func getData() {
        frontArray.removeAll(keepingCapacity: false)
        behindArray.removeAll(keepingCapacity: false)
        idArray.removeAll(keepingCapacity: false)
        
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
                
                if let id = result.value(forKey: "id") as? UUID {
                    self.idArray.append(id)
                }
                
                self.tableView.reloadData()
            }
        } catch {
            print("error")
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                let context = appDelegate.persistentContainer.viewContext
                
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Cards")
                
                let idString = idArray[indexPath.row].uuidString
                
                fetchRequest.predicate = NSPredicate(format: "id = %@", idString)
                fetchRequest.returnsObjectsAsFaults = false
                
                do {
                let results = try context.fetch(fetchRequest)
                if results.count > 0 {
                        
                    for result in results as! [NSManagedObject] {
                            
                        if let id = result.value(forKey: "id") as? UUID {
                                
                            if id == idArray[indexPath.row] {
                                context.delete(result)
                                frontArray.remove(at: indexPath.row)
                                idArray.remove(at: indexPath.row)
                                self.tableView.reloadData()
                                    
                                do {
                                    try context.save()
                                        
                                } catch {
                                    print("error")
                                }
                                break
                            }
                        }
                    }
                }
            } catch {
                print("error")
            }
        }
    }
 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return frontArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = frontArray[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            chosenname = frontArray[indexPath.row]
            chosennamebehind = behindArray[indexPath.row]
            chosennameid = idArray[indexPath.row]
            performSegue(withIdentifier: "tocreateVC2", sender: nil)
        }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.identifier == "tocreateVC2" {
                let destinationVC = segue.destination as! createViewController
                destinationVC.selectedname = chosenname
                destinationVC.selectednamebehind = chosennamebehind
                destinationVC.selectedcardId = chosennameid
            }
        }
}


