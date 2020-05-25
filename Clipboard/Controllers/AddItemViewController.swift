//
//  AddItemViewController.swift
//  Clipboard
//
//  Created by Jonathan Yataco  on 5/24/20.
//  Copyright © 2020 JonYataco. All rights reserved.
//

import UIKit

class AddItemViewController: UIViewController {
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var urlTextField: UITextField!
    
    var clip: Clip?
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func textFieldChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateSaveButtonState()

        // Do any additional setup after loading the view.
    }
    
    func updateSaveButtonState() -> Void {
        let nameText = nameTextField.text ?? ""
        let urlText = urlTextField.text ?? ""
        
        if nameText != "" && urlText != "" {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = nameTextField.text!
        let urlLink = urlTextField.text!
        
        clip = Clip(title: title, link: urlLink)
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
