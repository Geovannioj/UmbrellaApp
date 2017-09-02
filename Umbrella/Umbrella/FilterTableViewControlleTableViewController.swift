//
//  FilterTableViewControlleTableViewController.swift
//  Umbrella
//
//  Created by Eduardo Pereira on 07/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

class FilterTableViewControlleTableViewController: UITableViewController {

   
    

    
    var desirables:[String] = []
    var containerToMaster:MapViewController?
    var filters:[FilterEntity] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.allowsSelection = false
        self.tableView.layer.cornerRadius = 10
        updateFilter()
        
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.tableView.reloadData()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        containerToMaster?.mapView.allowsZooming = true
        containerToMaster?.mapView.allowsRotating = true
        containerToMaster?.mapView.allowsScrolling = true
        
    }
    func updateFilter(){
        FilterInteractor.getFilters(completion: { filtersFirebase in
            self.filters.append(contentsOf: filtersFirebase)
            self.tableView.reloadData()
            
        })
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
    
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "CloseFilter"), object: nil)

    }
    @IBAction func FilterAction(_ sender: UIButton) {
        
//        if psycologic.isSelected{
//            desirables.append("psicológica")
//        }
        for i in 0...filters.count - 1 {
            let indexPath = IndexPath(row: i, section: 0)
            let cell = self.tableView.cellForRow(at: indexPath) as! FilterTableViewCell
            
            if cell.checkButton.isSelected{
                self.desirables.append("\(cell.violenceTitle.text ?? "")")
            }
        }
       // NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "Filter"), object: desirables)
        //performSegue(withIdentifier: "filterAction", sender: self)
        containerToMaster?.filtros = desirables
        containerToMaster?.removePins()
        containerToMaster?.addPins(reports: (containerToMaster?.reports)!)
        NotificationCenter.default.post(name: NSNotification.Name.init(rawValue: "CloseFilter"), object: nil)
       
        
    }
    @IBAction func undoAction(_ sender: UIButton) {
//        sexual.isSelected = false
//        physic.isSelected = false
//        psycologic.isSelected = false
//        verbal.isSelected = false
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "filterAction"{
            let  controller = segue.destination as? MapViewController
            controller?.filtros = desirables
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        
    return  filters.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FilterCell") as! FilterTableViewCell
        
        cell.violenceTitle.text = filters[indexPath.row].type
        
        return cell
    }


}
