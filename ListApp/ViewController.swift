//
//  ViewController.swift
//  ListApp
//
//  Created by Bektur Mamytov on 21/10/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!

    var alertController = UIAlertController()
    
    var data = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        return cell
    }

    @IBAction func removeBarButtonTapped(_ sender: UIBarButtonItem) {
       presentAlert(title: "Alert!",
                    message: "Are you sure remove all items?",
                    cancelButtonTitle: "Cancel",
                    defaultButtonTitle: "Remove") { _ in
                        self.data.removeAll()
                        self.tableView.reloadData()
                    }
        
        
    }
    
    @IBAction func addBarButtonTapped(_ sender: UIBarButtonItem) {
       presentAddAlert()
    }
    
    func presentAddAlert() {
//        //create alert controller
//        let alertController = UIAlertController(title: "Add new element", message: nil, preferredStyle: .alert)
//
//        //create add button
//        let defaultButton = UIAlertAction(title: "Add", style: .default) { _ in
//            //to eliminate the empty element conducted fi control
//            let text = alertController.textFields?.first?.text
//            if text != "" {
//                self.data.append((text)!)
//                self.tableView.reloadData()
//            } else {
//                self.presentWarningAlert()
//            }
//        }
//        //create cancel button
//        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
//
//        //add textField
//        alertController.addTextField()
//
//        alertController.addAction(defaultButton)
//        alertController.addAction(cancelButton)
//        present(alertController, animated: true)
        
        presentAlert(title: "Add new element",
                     message: nil,
                     cancelButtonTitle: "Canccel",
                     isTextFieldAvailable: true,
                     defaultButtonTitle: "Add",
                     defaultButtonHandler: {_ in
            let text = self.alertController.textFields?.first?.text
            if text != "" {
                self.data.append((text)!)
                self.tableView.reloadData()
            } else {
                self.presentWarningAlert()
            }
        }
        )
    }
    
    func presentWarningAlert() {
        presentAlert(title: "Alert",
                     message: "You can't add an empty element",
                     cancelButtonTitle: "OK")
    }
    
    func presentAlert(title: String?,
                      message: String?,
                      preferedStyle: UIAlertController.Style = .alert,
                      cancelButtonTitle: String?,
                      isTextFieldAvailable: Bool = false,
                      defaultButtonTitle: String? = nil,
                      defaultButtonHandler: ((UIAlertAction) -> Void)? = nil
                      ) {
        
        alertController = UIAlertController(title: title,
                                                message: message,
                                                preferredStyle: preferedStyle)
        if defaultButtonTitle != nil {
            let defaultButton = UIAlertAction(title: defaultButtonTitle,
                                              style: .default,
                                              handler: defaultButtonHandler)
            alertController.addAction(defaultButton)
        }
       
        
        let cancelButton = UIAlertAction(title: cancelButtonTitle,
                                         style: .cancel)
        
        if isTextFieldAvailable {
            alertController.addTextField()
        }
        
        
        alertController.addAction(cancelButton)
        present(alertController, animated: true)
    }
}

