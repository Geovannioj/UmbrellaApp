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
        self.tableView.layer.cornerRadius = 10
        
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        containerToMaster?.mapView.allowsZooming = true
        containerToMaster?.mapView.allowsRotating = true
        containerToMaster?.mapView.allowsScrolling = true
        
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
            desirables.append("psicológica")
        }
        if verbal.isSelected{
            desirables.append("verbal")
        }
        if physic.isSelected{
            desirables.append("física")
        }
        if sexual.isSelected{
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


}
