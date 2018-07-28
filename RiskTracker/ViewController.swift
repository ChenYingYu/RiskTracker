//
//  ViewController.swift
//  RiskTracker
//
//  Created by ChenAlan on 2018/7/28.
//  Copyright © 2018年 ChenAlan. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var natureLabel: UILabel!
    @IBOutlet weak var seriousnessLabel: UILabel!
    @IBOutlet weak var shortDescription: UILabel!
    @IBOutlet weak var natureTextField: UITextField!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func takePhotos(_ sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera

        present(imagePicker, animated: true, completion: nil)
    }
    
    var imagePicker: UIImagePickerController!
    let nature = ["Cars","Roads","People"]
    let naturePickerView = UIPickerView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpMapView()
        setUpPickerView()
        setUpTextField()
    }
    
    func setUpMapView() {
        let locationManager = CLLocationManager()
        mapView.camera = GMSCameraPosition.camera(withLatitude: locationManager.getUserLatitude(), longitude: locationManager.getUserLongitude(), zoom: 15.0)
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
    }
    
    func setUpPickerView() {
        naturePickerView.delegate = self
        naturePickerView.dataSource = self
    }
    
    func setUpTextField() {
        natureTextField.inputView = naturePickerView
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        imagePicker.dismiss(animated: true, completion: nil)
        self.imageView.image = info[UIImagePickerControllerOriginalImage] as? UIImage
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        return nature.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return nature[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        natureTextField.text = nature[row]
        natureTextField.resignFirstResponder()
    }
}
