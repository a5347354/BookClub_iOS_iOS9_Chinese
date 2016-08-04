//
//  ViewController.swift
//  MapKit0804
//
//  Created by Fan on 2016/8/4.
//  Copyright © 2016年 Luke. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, UISearchBarDelegate, MKMapViewDelegate, CLLocationManagerDelegate{

    @IBOutlet weak var searchbar: UISearchBar!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager! //位置權限、自動更新定位開啟，讓使用者允許是否定位，允許後不斷去抓目前位置
    var dest: CLLocationCoordinate2D? //目前導航目標（要去的地方）
    var drawing: Bool = false //避免多個繪圖動作同時運行所需的旗標，因為為非同步的程式，避免在網路不順時出現兩條線
    var overlay: MKPolyline? //目前導航路線所在的overlay（蓋在地圖上的圖層）
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest //定位精準度，可有可無
        locationManager.requestAlwaysAuthorization() //要權限
        
        locationManager.startUpdatingLocation()
        //設定定位每隔多少公尺update (公尺為單位)
        // locationManager.distanceFilter = 10
        
        searchbar.delegate = self
        mapView.delegate = self
        
        //用預設的icon設定自己的位置 (defualt false)
        mapView.showsUserLocation = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

