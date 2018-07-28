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
    
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePicker: UIImagePickerController!
    
    @IBAction func takePhotos(_ sender: UIButton) {
        imagePicker =  UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera

        present(imagePicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setUpMapView()
    }
    
    func setUpMapView() {
        let locationManager = CLLocationManager()
        mapView.camera = GMSCameraPosition.camera(withLatitude: locationManager.getUserLatitude(), longitude: locationManager.getUserLongitude(), zoom: 15.0)
        mapView.isMyLocationEnabled = true
        mapView.delegate = self
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

extension ViewController: GMSMapViewDelegate {

}
