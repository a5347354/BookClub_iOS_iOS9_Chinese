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
    
    
    //每次更新Location時會呼叫
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        print(userLocation.coordinate) //座標資訊
        //設定中心點為目前的座標
        mapView.setCenterCoordinate(userLocation.coordinate, animated: true)
        
        //宣告一個可視範圍，單位公尺
        let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)
        
        //設定可視範圍,是否要動畫
        mapView.setRegion(viewRegion, animated: true)
        
        drawRoute()
        
    }
    
    
    
    //小鍵盤右下角那顆
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        CLGeocoder().geocodeAddressString(searchbar.text!){ (placemarks, error) in
            if let coordinate = placemarks?.first?.location?.coordinate {
                    self.dest = coordinate
            
                //TODO: 更換目的時重新繪製路線
            }
            
        }
    }

    //有新的overlay就會呼叫這個方法
    func mapView(mapView: MKMapView, rendererForOverlay overlay: MKOverlay) -> MKOverlayRenderer {
        let render  = MKPolylineRenderer(polyline: self.overlay!)
        render.strokeColor = UIColor(red: 0.9861, green: 0.2939, blue: 0.1098, alpha: 1.0) //設定顏色
        render.lineWidth = 3 //設定粗細
        return render
    }
    
    
    func drawRoute() {
        
        //如果正在畫，就return
        if(drawing) {
            return
        }
        
        //還沒設定目的地，get out
        //guard 類似 if，只要掉進去一定要中斷
        guard let dest = self.dest else {
            return
        }
        
        //要路線圖回來
        let req = MKDirectionsRequest()
        
        //設定交通類型
        req.transportType = .Automobile
        
        //出發地
        req.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate, addressDictionary: nil))
        //目的地
        req.destination = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate, addressDictionary: nil))
        
        let directions = MKDirections(request: req)
        
        drawing = true
        //Closure
        directions.calculateDirectionsWithCompletionHandler{(res, error) in
            //規劃路線時會有很多條，只取第一條
            if let route = res?.routes.first {
                //如果圖層存在，就移除掉
                if let ol = self.overlay {
                    self.mapView.removeOverlay(ol)
                }
                
                //增加圖層
                self.overlay = route.polyline
                self.mapView.addOverlay(route.polyline)
                
                self.distanceLabel.text = "\(route.distance/1000)km"
                self.timeLabel.text = "\(route.expectedTravelTime/3600)hr"
            }
            self.drawing = false
        }
    }
}

