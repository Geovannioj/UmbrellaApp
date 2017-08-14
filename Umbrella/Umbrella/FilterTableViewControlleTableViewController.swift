//
//  FilterTableViewControlleTableViewController.swift
//  Umbrella
//
//  Created by Eduardo Pereira on 07/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class FilterTableViewControlleTableViewController: UITableViewController {

    @IBOutlet weak var psycologic: UIButton!
    
    @IBOutlet weak var verbal: UIButton!
    
    @IBOutlet weak var physic: UIButton!
    
    @IBOutlet weak var sexual: UIButton!
    
    var desirables:[String] = []
    var containerToMaster:MapViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func setSelect(_ sender: UIButton) {
        if sender.isSelected{
            sender.isSelected = false
        }else{
            sender.isSelected = true
        }
    }
  
    @IBAction func closeAction(_ sender: Any) {
       // self.view.removeFromSuperview()
        //self.removeFromParentViewController()
       // self.view.isHidden = true
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "CloseFilter"), object: nil)

    }
    @IBAction func FilterAction(_ sender: UIButton) {
        
        if psycologic.isSelected{
            print("psicológica")
            desirables.append("psicológica")
        }
        if verbal.isSelected{
            print("verbal")
            desirables.append("verbal")
        }
        if physic.isSelected{
            print("física")
            desirables.append("física")
        }
        if sexual.isSelected{
            print("sexual")
            desirables.append("sexual")
        }
       // NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "Filter"), object: desirables)
        //performSegue(withIdentifier: "filterAction", sender: self)
        containerToMaster?.filtros = desirables
        containerToMaster?.removePins()
        containerToMaster?.addPins(reports: (containerToMaster?.reports)!)
         NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "CloseFilter"), object: nil)
        
        
    }
    @IBAction func undoAction(_ sender: UIButton) {
        sexual.isSelected = false
        physic.isSelected = false
        psycologic.isSelected = false
        verbal.isSelected = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterAction"{
            let  controller = segue.destination as? MapViewController
            controller?.filtros = desirables
        }
        
    }
    // MARK: - Table view data source

   

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
