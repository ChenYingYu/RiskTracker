//
//  ViewController.swift
//  RiskTracker
//
//  Created by ChenAlan on 2018/7/28.
//  Copyright © 2018年 ChenAlan. All rights reserved.
//

import UIKit
import GoogleMaps
import Firebase

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var shortDescription: UILabel!
    @IBOutlet weak var natureTextField: UITextField!
    @IBOutlet weak var seriousnessTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var imageView: UIImageView!
    @IBAction func takePhotos(_ sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera

        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func sendButton(_ sender: UIButton) {
        sendReport()
    }
    
    var imagePicker: UIImagePickerController!
    let nature = ["Cars","Roads","People"]
    let seriousness = ["1", "2", "3"]
    let naturePickerView = UIPickerView()
    let seriousnessPickerView = UIPickerView()
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpMapView()
        setUpPickerView()
        setUpTextField()
        setUpKeyboard()
    }
    
    func setUpMapView() {
        mapView.camera = GMSCameraPosition.camera(withLatitude: locationManager.getUserLatitude(), longitude: locationManager.getUserLongitude(), zoom: 15.0)
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    func setUpPickerView() {
        naturePickerView.delegate = self
        naturePickerView.dataSource = self
        naturePickerView.tag = 1
        seriousnessPickerView.delegate = self
        seriousnessPickerView.dataSource = self
        seriousnessPickerView.tag = 2
    }
    
    func setUpTextField() {
        natureTextField.inputView = naturePickerView
        seriousnessTextField.inputView = seriousnessPickerView
    }
    
    func setUpKeyboard() {
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:))))
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow), name: Notification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: Notification.Name.UIKeyboardWillHide, object: nil)
    }
    
    @objc func keyboardWillHide(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardHeight = keyboardFrame.size.height
            let duration: Double = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            
            UIView.animate(withDuration: duration, animations: { () -> Void in
                var frame = self.view.frame
                frame.origin.y += keyboardHeight
                frame.origin.y -= self.view.safeAreaInsets.bottom
                self.view.frame = frame
            })
        }
    }
    
    @objc func keyboardDidShow(notification: Notification) {
        if let userInfo = notification.userInfo {
            let keyboardFrame: CGRect = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
            let keyboardHeight = keyboardFrame.size.height
            let duration: Double = userInfo[UIKeyboardAnimationDurationUserInfoKey] as! Double
            
            UIView.animate(withDuration: duration, animations: { () -> Void in
                var frame = self.view.frame
                frame.origin.y -= keyboardHeight
                frame.origin.y += self.view.safeAreaInsets.bottom
                self.view.frame = frame
            })
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        self.imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }

    func sendReport() {
        if let nature = self.natureTextField.text, let seriousness = seriousnessTextField.text, let description = descriptionTextView.text {
            let now = Date()
            let timeInterval: TimeInterval = now.timeIntervalSince1970
            let timeStamp = Int(timeInterval)
            let newReport: [String: Any] = ["TimeStamp": timeStamp,
                                              "Location": "\(locationManager.getUserLatitude()), \(locationManager.getUserLongitude())",
                                              "Picture": "Sample",
                                              "Nature": nature,
                                              "Seriousness": seriousness,
                                              "Description": description]
            let ref = Database.database().reference()
            let reportId = ref.child("events").childByAutoId()
            reportId.setValue(newReport)
        }
    }
}

extension CLLocationManager {
    
    func getUserLatitude() -> Double {
        guard let userLatitude = self.location?.coordinate.latitude else {
            print("ErrorMessage userLocationNotFound")
            return 25.042416
        }
        return userLatitude
    }
    
    func getUserLongitude() -> Double {
        guard let userLongitude = self.location?.coordinate.longitude else {
            print("ErrorMessage userLocationNotFound")
            return 121.564793
        }
        return userLongitude
    }
}

extension ViewController: GMSMapViewDelegate, UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerView.tag == 1 ? nature.count : seriousness.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerView.tag == 1 ? nature[row] : seriousness[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            natureTextField.text = nature[row]
            natureTextField.resignFirstResponder()
        } else {
            seriousnessTextField.text = seriousness[row]
            seriousnessTextField.resignFirstResponder()
        }
    }
}
