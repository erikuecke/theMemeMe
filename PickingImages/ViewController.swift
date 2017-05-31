//
//  ViewController.swift
//  PickingImages
//
//  Created by Erik Uecke on 5/30/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var imageAlbums: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    


    // Setting up font style
    // Text Font, white with black outline
    let memeTextAttributes: [String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -5
    ]
    
    // Initialize Delegate
    let memeTextDelegate = MemeTextFieldDelegate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Assign MemeTextFieldDelegate
        self.topTextField.delegate = memeTextDelegate
        self.bottomTextField.delegate = memeTextDelegate
        
        
        
        
        
        // Set meme text attributes
        topTextField.defaultTextAttributes = memeTextAttributes
        bottomTextField.defaultTextAttributes = memeTextAttributes
        
        // Initial text of textfields
        topTextField.text = "TOP"
        topTextField.textAlignment = .center
        bottomTextField.text = "BOTTOM"
        bottomTextField.textAlignment = .center
    }
    
    // Camera status enabling or disabling 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        subscribeToKeyboardNotifications()
        subscribeToHideKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        uncsubscribeFromKeyboardNotifications()
        uncsubscribeFromHideKeyboardNotifications()
    }
    
    // Image Picker setting func
    func imagePickerSetPresent(pickerSourceType: UIImagePickerControllerSourceType?) {
        
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        if let sourceType = pickerSourceType {
            pickerController.sourceType = sourceType
        }
        self.present(pickerController, animated: true, completion: nil)
    }

    // Picking an image
    @IBAction func pickAnImage(_ sender: Any) {
        imagePickerSetPresent(pickerSourceType: nil)
    }
    
    // Picking an image from album
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
       imagePickerSetPresent(pickerSourceType: .photoLibrary)
    }
    
    // Taking a picture to use.
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        imagePickerSetPresent(pickerSourceType: .camera)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            imagePickerView.image = image
        }
        
        
        dismiss(animated: true, completion: nil)
        
      
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        dismiss(animated: true, completion: nil)
    }
    
    // Methods to add to Keyboard notification subscriptions
    func keyboardWillshow(_ notification: Notification) {
        
        view.frame.origin.y -= getKeyBoardHeight(notification)
    }
    
    func getKeyBoardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // Keyboard methods for subscribing/unsubscribing from notifications
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillshow(_:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    func uncsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
    }
    
    // Reversing keyboard. Keyboard will hide.
    func keyboardWillHide() {
        view.frame.origin.y = 0
        print("It did hide")
    }
    
    func subscribeToHideKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func uncsubscribeFromHideKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        print("It unsubscribed from hide observer")
    }

}

