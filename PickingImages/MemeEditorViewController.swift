//
//  MemeEditorViewController.swift
//  PickingImages
//
//  Created by Erik Uecke on 5/30/17.
//  Copyright © 2017 Erik Uecke. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var theTableView: SentMemesTableViewController!
    
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var imageAlbums: UIBarButtonItem!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    
    // Bar Items
    @IBOutlet weak var topBar: UINavigationBar!
    @IBOutlet weak var bottomBar: UIToolbar!
    
    
    // Share Button
    @IBOutlet weak var shareButton: UIBarButtonItem!

    // Clear out status bar
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    // Setting up font style
    // Text Font, white with black outline
    let memeTextAttributes: [String:Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName: -3.5
    ]
    
    // Initialize Delegate
    let memeTextDelegate = MemeTextFieldDelegate()
    
    // Initial textField Methods
    func configureTextField(_ textField: UITextField, defaultText: String) {
        
        textField.delegate = memeTextDelegate
        textField.defaultTextAttributes = memeTextAttributes
        
        textField.text = defaultText
        textField.textAlignment = .center
    }
    
    // MARK: VIEW DID LOAD
    override func viewDidLoad() {
        super.viewDidLoad()
    
        // Initial text of textfields
        configureTextField(topTextField, defaultText: "TOP")
        configureTextField(bottomTextField, defaultText: "BOTTOM")
        
        // Disable share button
            shareButton.isEnabled = false
        
    }
    
    
    // Camera status enabling or disabling 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        subscribeToKeyboardNotifications()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        uncsubscribeFromKeyboardNotifications()
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
            shareButton.isEnabled = true
        }
        
        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {

        dismiss(animated: true, completion: nil)
    }
    
    // MARK: KEYBOARD SETUP
    
    // Methods to add to Keyboard notification subscriptions
    func keyboardWillshow(_ notification: Notification) {
        
        if bottomTextField.isFirstResponder {
            view.frame.origin.y -= getKeyBoardHeight(notification)
        } else {
        view.frame.origin.y = 0
        }
    }
    
    // Reversing keyboard. Keyboard will hide.
    func keyboardWillHide() {
        view.frame.origin.y = 0
    }
    
    func getKeyBoardHeight(_ notification: Notification) -> CGFloat {
        
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    // Keyboard methods for subscribing/unsubscribing from notifications
    func subscribeToKeyboardNotifications() {
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillshow(_:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
    }
    
    func uncsubscribeFromKeyboardNotifications() {
        
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)

    }
    
    // GENERATE MEMED IMAGE AND MEME STRUCT
    
    
    // ToolBar/NavBar visibility method
    
    func shouldHideBars(_ isHidden: Bool) {
        topBar.isHidden = isHidden
        bottomBar.isHidden = isHidden
    }
    
    // Initializing a memed model object
    func save() {
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePickerView.image!, memedImage: generateMemedImage())
        
        // Saving meme to the AppDelegate
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    // Creating memedImage combining Image and text
    func generateMemedImage() -> UIImage {
        
        // Hide toolbar navigation bar
        shouldHideBars(true)
    
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // Show toolbar/navigation
        shouldHideBars(false)
        
        return memedImage
    }
    

    // MARK: SHARE ACTION METHOD
    
    // Returnin to Sent Memes when sharing or canceling
    func returnToSentMemes() {
        let memeTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        self.present(memeTabBarController, animated: true, completion: nil)
    }
    // IBACTION for Sharing
    @IBAction func shareButtonPressed(_ sender: Any) {
        
        // Generate memed image
        let activeMemedImage = [generateMemedImage()]
        
        // Define an instance of ActivityViewController
        let shareViewController = UIActivityViewController(activityItems: activeMemedImage, applicationActivities: nil)
        shareViewController.completionWithItemsHandler = { activity, completed, items, error in
            if completed {
                self.save()
                self.dismiss(animated: true, completion: nil)
                
            }
        }
        self.present(shareViewController, animated: true, completion: nil)
    }
    
    // MARK: CANCEL BUTTON METHOD
    @IBAction func cancelButtonPressed(_ sender: Any) {
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imagePickerView.image = nil
        
       dismiss(animated: true, completion: nil)

    }

}

