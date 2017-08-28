//
//  PerfilViewController.swift
//  Umbrella
//
//  Created by Jonas de Castro Leitao on 13/08/17.
//  Copyright © 2017 Geovanni Oliveira de Jesus. All rights reserved.
//

import UIKit

protocol ProfileTableViewControllerProtocol {
    func getNavBar() -> UINavigationItem
    func getSegmentedControl() -> UISegmentedControl
}


class ProfileTableViewController: UITableViewController, InteractorCompleteProtocol {
    
    @IBOutlet weak var emailCell: UITableViewCell!
    @IBOutlet weak var passwordCell: UITableViewCell!
    @IBOutlet weak var birthCell: UITableViewCell!
    @IBOutlet weak var minorityCell: UITableViewCell!
    @IBOutlet weak var emailDetail: UILabel!
    @IBOutlet weak var passwordDetail: UILabel!
    @IBOutlet weak var birthDetail: UILabel!
    @IBOutlet weak var minorityDetail: UILabel!
    @IBOutlet weak var inputs: ProfileView!
    
    
    var delegate: ProfileTableViewControllerProtocol?
    
    var isEdit = false
    var isBirthSelection = false
    var datePicker = UIDatePicker()
    var picker: UIPickerView!
    var minorities: [MinorityEntity] = []
    var minoritySelected: MinorityEntity = MinorityEntity()
    
    let alert: AlertPresenter = AlertPresenter()
    
    let popUp = PopUpPresenter()
    
    override func viewDidLoad() {

        MinorityInteractor.getMinorities(completion: { minoritiesFirebase in
            self.minorities.append(contentsOf: minoritiesFirebase)
            self.picker = UIPickerView()
            
        })
        
        inputs.alterarFotoButton.isHidden = true
        delegate?.getNavBar().rightBarButtonItem = UIBarButtonItem(title: "Editar", style: .plain, target: self, action: #selector(editingMode))
        
        super.viewDidLoad()
        view.backgroundColor = .clear
        
        setupInputs()
        setupUser()
        setTable()
        setPopUp()
        
        // Necessary to be behind de pop up view
        tableView.tableFooterView?.layer.zPosition = -10

    }
    
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 150
        }
        if isEdit == true && section == 2 {
            return 150
        }
        return 0
    }
    
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        if isEdit == true && section == 2 {
//            let image = UIView(frame: CGRect(x: tableView.rectForHeader(inSection: 2).size.width * 1/2, y: tableView.rectForHeader(inSection: 2).size.height * 1/2, width: 0.1, height: 0.1))
//            //let image = UIImageView(image: #imageLiteral(resourceName: "heart"))
//            image.image = #imageLiteral(resourceName: "heart")
//            //image.contentMode = .scaleAspectFit
//            return image
//        }
//        return nil
//    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if isEdit == false {
            if indexPath.section == 0 && indexPath.row == 1 {
                return 0
            }
            if indexPath.section == 2 && indexPath.row == 1 {
                return 0
            }
            return 44
        }
        else {
            if indexPath.section == 0 && indexPath.row == 0 {
                return 0
            }
            if indexPath.section == 1 && indexPath.row == 0 {
                return 0
            }
            if indexPath.section == 1 && indexPath.row == 1 {
                return 0
            }
            if indexPath.section == 2 && indexPath.row == 0 {
                return 0
            }
            return 44
        }
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if isEdit == false {
            if indexPath == IndexPath(row: 0, section: 2) {
                UserInteractor.disconnectUser(handler: self)
            }
        }
        else {
            switch indexPath {
//            case IndexPath(row: 0, section: 0):
//                break
                
            case IndexPath(row: 1, section: 0):
                alert.showAlert(viewController: self, title: "Olá!", message: "Deseja mesmo alterar sua senha?", confirmButton: "Sim", cancelButton: "Não", onAffirmation: {
                    UserInteractor.sendPasswordResetEmail(email: UserInteractor.getCurrentUserEmail()!, handler: self)
                    self.alert.showAlert(viewController: self, title: "Tudo bem", message: "Confirme se você recebeu nosso e-mail com um link para alterar sua senha.", confirmButton: nil, cancelButton: "OK")
                })
                
            case IndexPath(row: 2, section: 0):
                isBirthSelection = true
                chooseBirthDate()
                
            case IndexPath(row: 3, section: 0):
                isBirthSelection = false
                chooseMinority()
                
            case IndexPath(row: 1, section: 2):
                alert.showAlert(viewController: self, title: "Atenção!", message: "Tem certeza que deseja deletar sua conta?", confirmButton: "Sim", cancelButton: "Não", onAffirmation: {
                    UserInteractor.deleteUser(handler: self)
                })
                
            default:
                break
            }
        }
    }
    
    func completeSendPasswordResetEmail(error: Error?) {
        if error != nil {
            alert.showAlert(viewController: self, title: "Alerta!!", message: "A conta de usuário não foi encontrada.", confirmButton: nil, cancelButton: "OK")
        }
    }
    
    func completeSingOut(error: Error?) {
        if error != nil {
            alert.showAlert(viewController: self, title: "Alerta!!", message: "Ocorreu um erro na base de dados. Tente novamente mais tarde.", confirmButton: nil, cancelButton: "OK")
        }
        else {
            
            performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    func completeDelete(error: Error?) {
        if error != nil {
            
        }
        else {
            performSegue(withIdentifier: "loginSegue", sender: nil)
        }
    }
    
    func setupInputs() {
        
        inputs.translatesAutoresizingMaskIntoConstraints = false
        inputs.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        inputs.heightAnchor.constraint(equalToConstant: 155).isActive = true
        inputs.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        inputs.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        inputs.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        inputs.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        
        inputs.alterarFotoButton.addTarget(self, action: #selector(handleSelectProfileImage), for: .touchUpInside)
        
    }
    
    func setupUser(){
        
        guard let id = UserInteractor.getCurrentUserUid() else {
            return //Erro de usuario n logado
        }
        
        UserInteractor.getUser(withId: id, completion: { (user) in
    
            if let url = user.urlPhoto {
                self.inputs.profileImage.loadCacheImage(url)
            }
            self.inputs.username.text = user.nickname
            
        })
    }
    
    /**
     Gets data from database to fill the necessary cells from the table view.
    */
    func setTable() {
        // Tries to get from the local database
        if let user = SaveManager.realm.objects(UserEntity.self).filter("id == %s", UserInteractor.getCurrentUserUid()!).first {
            self.emailDetail.text = user.email
            
            if user.birthDate != nil{
                let formatter = user.dateConverter()
                self.birthDetail.text = formatter.string(from: (user.birthDate)!)
            }
            else {
                self.birthDetail.text = ""
            }
            
            self.minorityDetail.text = user.typeMinority ?? ""
            
        }
        // Tries to get from the web database
        else {
            UserInteractor.getUser(withId: UserInteractor.getCurrentUserUid()!, completion: { user in
                SaveManager.instance.create(user)
                
                self.emailDetail.text = user.email
                
                if user.birthDate != nil {
                    let formatter = user.dateConverter()
                    self.birthDetail.text = formatter.string(from: (user.birthDate)!)
                }
                else {
                    self.birthDetail.text = ""
                }
                if user.idMinority != "" {
                    self.minorityDetail.text = self.minorities.filter{ $0.id == user.idMinority }.first?.type
                }
                else {
                    self.minorityDetail.text = ""
                }
            })
        }

        tableView.reloadData()
        
    }
    
    func setPopUp() {
        popUp.prepare(view: view,
        popUpFrame: CGRect(x: 8, y: 1/9 * self.view.frame.height, width: self.view.frame.width - 16, height: 3/5 * self.view.frame.height),
        blurFrame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height))
        popUp.isHidden = true
        putButtonsOnPopUp()
    }
    
    /**
     Changes the screen when the user click on the editing button.
     */
    func editingMode() {
        if isEdit == false {
            isEdit = true
            
            // Navigation Bar changes
            delegate?.getNavBar().rightBarButtonItem?.title = "Pronto"
            delegate?.getNavBar().leftBarButtonItem?.isEnabled = false
            delegate?.getSegmentedControl().isEnabled = false
            
            
            // Views and cells changes
            inputs.alterarFotoButton.isHidden = false
            
            emailCell.accessoryType = .disclosureIndicator
            emailCell.accessoryView?.tintColor = .clear
            emailDetail.textColor = UIColor(r: 165, g: 145, b: 174)
            
            birthCell.accessoryType = .disclosureIndicator
            birthCell.accessoryView?.tintColor = .clear
            birthDetail.textColor = UIColor(r: 165, g: 145, b: 174)
            birthDetail.text = "Selecionar"
            
            minorityCell.accessoryType = .disclosureIndicator
            minorityCell.accessoryView?.tintColor = .clear
            minorityDetail.textColor = UIColor(r: 165, g: 145, b: 174)
            minorityDetail.text = "Selecionar"
            
            // Table view reload
            tableView.reloadData()
            tableView.beginUpdates()
            tableView.reloadSections(IndexSet(integersIn: 0...2), with: .top)
            tableView.endUpdates()
            
            //view.bringSubview(toFront: inputs)
            //tableView.bringSubview(toFront: inputs)
            //print(tableView.layer.zPosition)
            //print(view.bringSubview(toFront: tableView.subviews.last!))
            //view.bringSubview(toFront: tableView.subviews.last!)
            
        }
        else {
            isEdit = false

            // Navigation Bar changes
            delegate?.getNavBar().rightBarButtonItem?.title = "Editar"
            delegate?.getNavBar().leftBarButtonItem?.isEnabled = true
            delegate?.getSegmentedControl().isEnabled = true
            
            // Views and cells changes
            inputs.alterarFotoButton.isHidden = true
            
            emailCell.accessoryType = .none
            emailDetail.textColor = UIColor(r: 170, g: 10, b: 234)
            emailDetail.text = ""
            
            birthCell.accessoryType = .none
            birthDetail.textColor = UIColor(r: 170, g: 10, b: 234)
            birthDetail.text = ""
            
            minorityCell.accessoryType = .none
            minorityDetail.textColor = UIColor(r: 170, g: 10, b: 234)
            minorityDetail.text = ""
            
            // Table view reload
            setTable()
            tableView.reloadData()
            tableView.beginUpdates()
            tableView.reloadSections(IndexSet(integersIn: 0...2), with: .top)
            tableView.endUpdates()
        }
    }
    
    /**
     Sets standard buttons on the current pop up view.
     */
    func putButtonsOnPopUp() {
        
        let closeButton = UIImageView(frame: CGRect(x: 15, y: 15, width: 20, height: 20))
        closeButton.image = #imageLiteral(resourceName: "CloseIcon")
        self.popUp.popUpView.addSubview(closeButton)
        self.popUp.popUpView.bringSubview(toFront: (view.subviews.last)!)
        closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeButtonAction)))
        closeButton.isUserInteractionEnabled = true
        
        
        
        let saveButton = UIButton(frame: CGRect(x: self.popUp.popUpView.bounds.size.width * 1/3, y: self.popUp.popUpView.bounds.size.height - self.popUp.popUpView.bounds.size.height * 1/10 - 20, width: self.popUp.popUpView.bounds.size.width * 1/3, height: self.popUp.popUpView.bounds.size.height * 1/10))
        saveButton.setTitle("Salvar", for: .normal)
        saveButton.tintColor = .white
        saveButton.backgroundColor = UIColor(r: 74, g: 3, b: 103)
        saveButton.layer.cornerRadius = 5
        self.popUp.popUpView.addSubview(saveButton)
        self.popUp.popUpView.bringSubview(toFront: (view.subviews.last)!)
        saveButton.addTarget(self, action: #selector(saveButtonAction), for: .touchUpInside)
    }
    
    /**
     Sets up a data picker view for the user choose his birthday.
     */
    func chooseBirthDate() {
        tableView.isScrollEnabled = false
        popUp.isHidden = false
        delegate?.getNavBar().rightBarButtonItem?.isEnabled = false
        tableView.tableFooterView?.isUserInteractionEnabled = false
        
        datePicker = UIDatePicker(frame: CGRect(x: 0, y: 1/5 * self.popUp.popUpView.frame.height, width: self.popUp.popUpView.frame.width, height: 1/2 * self.popUp.popUpView.frame.height))
        datePicker.setValue(UIColor.white, forKey: "textColor")
        datePicker.locale = Locale(identifier: "pt_BR")
        datePicker.datePickerMode = .date
        self.popUp.popUpView.addSubview(datePicker)
        self.popUp.popUpView.bringSubview(toFront: (view.subviews.last)!)
        
    }
    
    /**
     Sets up a picker view filled with minorities the user can choose.
     */
    func chooseMinority() {
        tableView.isScrollEnabled = false
        popUp.isHidden = false
        delegate?.getNavBar().rightBarButtonItem?.isEnabled = false
        tableView.tableFooterView?.isUserInteractionEnabled = false
        
        picker = UIPickerView(frame: CGRect(x: 0, y: 1/5 * self.popUp.popUpView.frame.height, width: self.popUp.popUpView.frame.width, height: 1/2 * self.popUp.popUpView.frame.height))
        picker.dataSource = self
        picker.delegate = self
        
        minoritySelected = minorities.first!
        picker.setValue(UIColor.white, forKey: "textColor")
        self.popUp.popUpView.addSubview(picker)
        self.popUp.popUpView.bringSubview(toFront: (view.subviews.last)!)
        
    }
    
    /**
     Activated when the close button is clicked.
     */
    func closeButtonAction() {
        tableView.isScrollEnabled = true
        popUp.isHidden = true
        delegate?.getNavBar().rightBarButtonItem?.isEnabled = true
        tableView.tableFooterView?.isUserInteractionEnabled = true

        if isBirthSelection == true {
            datePicker.removeFromSuperview()
        }
        else {
            picker.removeFromSuperview()
        }
    }
    
    /**
     Activated when the save button is clicked.
    */
    func saveButtonAction() {
        if isBirthSelection == true {
            saveBirthAction()
        }
        else {
            saveMinorityAction()
        }
    }
    
    /**
     Saves the date the user chose as his birthday.
     */
    func saveBirthAction() {
        let date = datePicker.date
        if date >= Date() {
            alert.showAlert(viewController: self, title: "Alerta!!", message: "Sua data de nascimento deve ser no passado.", confirmButton: nil, cancelButton: "OK")
        }
        else {
            closeButtonAction()
            UserInteractor.updateCurrentUser(birthDate: datePicker.date)
        }
    }
    
    /**
     Saves the item the user chose as his minority.
     */
    func saveMinorityAction() {
        closeButtonAction()
        UserInteractor.updateCurrentUser(minority: minoritySelected)
    }
    
}





extension ProfileTableViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {

        return minorities.count
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = minorities[row].type
        let title = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Helvetica", size: 24.0)!,NSForegroundColorAttributeName: UIColor.white])
        return title
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 35
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        minoritySelected = minorities[row]
    }
}

extension ProfileTableViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func handleSelectProfileImage() {
        
        let chooseAction = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        
        chooseAction.addAction(UIAlertAction(title: "Tirar Foto", style: .default, handler:{_ in
            self.handlePresentPicker(type: .camera)
        }))
        
        chooseAction.addAction(UIAlertAction(title: "Escolher Foto", style: .default, handler:{_ in
            self.handlePresentPicker(type: .photoLibrary)
        }))
        
        chooseAction.addAction(UIAlertAction(title: "Remover Foto", style: .destructive, handler:{_ in
            self.inputs.profileImage.image = nil
        }))
        
        chooseAction.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(chooseAction, animated: true, completion: nil)
    }
    
    func handlePresentPicker(type : UIImagePickerControllerSourceType) {
        
        let picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        
        if UIImagePickerController.isSourceTypeAvailable(type) {
            picker.sourceType = type
            self.present(picker, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            inputs.profileImage.image = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            inputs.profileImage.image = originalImage
        }
        
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

}
