//
//  NavigationViewController.swift
//  Walkation (iOS)
//
//  Created by Matt on 1/6/2023.
//

import UIKit
import MapKit
import CoreLocation
import AVFoundation

class NavigationViewController: UIViewController {

    var directionsLabel = UITextView()
    var searchBar = UISearchBar()
    var mapView = MKMapView()
    
    let locationManager = CLLocationManager()
    var currentCoordinate: CLLocationCoordinate2D!
    
    var steps = [MKRoute.Step]()
    
    var stepCounter = 0
    
    var timer: Timer? //導航timer
    var areaTimer: Timer? //檢測圍欄timer
    override func viewDidLoad() {
        super.viewDidLoad()
        //本畫面的背景顏色
        view.backgroundColor = .white
        
        //前端代碼
        directionsLabel.frame = CGRect(x: 10, y: 50, width: self.view.frame.width - 20, height: 100)
        directionsLabel.textColor = .black
        directionsLabel.backgroundColor = .clear
        directionsLabel.isEditable = false
        directionsLabel.text = "這裡會顯示導航實時位置......."
        self.view.addSubview(directionsLabel)
        
        searchBar.frame = CGRect(x: 0, y: 120, width: self.view.frame.width , height: 50)
        searchBar.backgroundColor = .clear
        searchBar.placeholder = "在此輸入目的地位置進行導航"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.delegate = self
        self.view.addSubview(searchBar)
        
        mapView.frame = CGRect(x: 0, y: 200, width: self.view.frame.width, height: 700)
        mapView.delegate = self
        
        self.view.addSubview(mapView)
        mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "customAnnotation")
        //位置權限
        locationManager.requestAlwaysAuthorization()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
       locationManager.startUpdatingLocation()
        
        
        //圍欄地圖
        // 1. 將地圖中心設定為香港,調較數據
 /*       let initialLocation = CLLocation(latitude: 22.30312, longitude: 114.17169)
        let regionRadius: CLLocationDistance = 2000
        let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        mapView.mapType = .standard
*/
        
    draw()
      //url
        
    }
    
    func handleURLSchemeRequest(_ url: URL) {
        if url.scheme == "testmynfc://test" {
            // 在这里添加打开应用程序首页的代码
           
        }
    }
    
    
    func draw(){
        // 2. 建立自定義的annotation,自定義圖片1-7
        let annotation1 = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 22.30312, longitude: 114.17169),
                                           title: "Victoria Peak", subtitle: "The highest point on Hong Kong Island",
                                           imageName: "Theme=3D-1")
        
        let annotation2 = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 22.29818, longitude: 114.17202),
                                           title: "Hong Kong Disneyland", subtitle: "A magical world of Disney characters and attractions",
                                           imageName: "Theme=3D-7")
        
        let annotation3 = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 22.29809, longitude: 114.16976),
                                           title: "Lamma Island", subtitle: "A peaceful island with scenic hiking trails and seafood restaurants",
                                           imageName: "Theme=3D-6")
        
        let annotation4 = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 22.29941, longitude: 114.16933),
                                           title: "Lamma Island", subtitle: "A peaceful island with scenic hiking trails and seafood restaurants",
                                           imageName: "Theme=3D-4")
        
       let annotation5 = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 22.30048, longitude: 114.16845),
                                           title: "Lamma Island", subtitle: "A peaceful island with scenic hiking trails and seafood restaurants",
                                           imageName: "Theme=3D-5")
        
        let annotation6 = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 22.30179, longitude: 114.16810),
                                            title: "Lamma Island", subtitle: "A peaceful island with scenic hiking trails and seafood restaurants",
                                            imageName: "Theme=3D-5")
        
        let annotation7 = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude: 22.30289, longitude: 114.16816),
                                            title: "Lamma Island", subtitle: "A peaceful island with scenic hiking trails and seafood restaurants",
                                            imageName: "Theme=3D-5")
       
        
        
        
        //計算中點，x,y
        let x  = findCenterCoordinate(for: [annotation1, annotation2, annotation3,annotation4,annotation5,annotation6,annotation7]).latitude
        let y = findCenterCoordinate(for: [annotation1, annotation2, annotation3,annotation4,annotation5,annotation6,annotation7]).longitude
        //上面1-7 圖標的中心點 -》 找到中點進行設置為了下面圍欄計算
        let annotation9 = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude:x, longitude: y),
                                            title: "", subtitle: "",
                                            imageName: "")
        

        // 2. 建立自定義的圍欄
        var a = drawLine(from: annotation1.coordinate, to: annotation9.coordinate, imageName: "Theme=3D-1")
        var b = drawLine(from: annotation2.coordinate, to: annotation9.coordinate, imageName: "Theme=3D-6")
        var c = drawLine(from: annotation3.coordinate, to: annotation9.coordinate, imageName: "Theme=3D-7")
        var d = drawLine(from: annotation4.coordinate, to: annotation9.coordinate, imageName: "Theme=3D-4")
        var e = drawLine(from: annotation5.coordinate, to: annotation9.coordinate, imageName: "Theme=3D-5")
        var f = drawLine(from: annotation6.coordinate, to: annotation9.coordinate, imageName: "Theme=3D-8")
        var g = drawLine(from: annotation7.coordinate, to: annotation9.coordinate, imageName: "Theme=3D-9")
        
        // 3. 將annotation加到mapView上
        mapView.addAnnotations([a,b,c,d,e,f,g])
       
        
        // 4. 繪製圍欄
        let fenceCoordinates = [annotation1.coordinate,annotation2.coordinate,annotation3.coordinate,annotation4.coordinate,annotation5.coordinate,annotation6.coordinate,annotation7.coordinate]
        let fence = polygon(for: fenceCoordinates)
        mapView.addOverlay(fence!)
        
        
        //檢測用戶是否在此圍欄區域
        calculateInAreaRange(annotation1: annotation1, annotation2: annotation2, annotation3: annotation3, annotation4: annotation4, annotation5: annotation5, annotation6: annotation6, annotation7: annotation7)
    }
    
    // 7. 根據點的數量繪製多邊形和循環連線
   func polygon(for coordinates: [CLLocationCoordinate2D]) -> MKOverlay? {
       guard coordinates.count >= 3 else {
           return nil // 需要至少三個頂點
       }
       
       var polygon: MKOverlay
       
       let points = coordinates + [coordinates[0]] // 將第一個點添加到最後以形成閉合的形狀
       
       var polylinePoints = [CLLocationCoordinate2D]() // 用於創建 MKPolyline
       
       for i in 0..<points.count {
           polylinePoints.append(points[i])
           
           if i < points.count - 1 {
               // 將相鄰的兩個點添加到 MKPolyline 中
               let polyline = MKPolyline(coordinates: [points[i], points[i+1]], count: 2)
               mapView.addOverlay(polyline)
           }
       }
       
       switch coordinates.count {
       case let count where count >= 3 && count <= 10:
           polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
       default:
           polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
       }
       
       return polygon
   }
    
    func drawLine(from locationA: CLLocationCoordinate2D, to locationB: CLLocationCoordinate2D, imageName: String) -> CustomAnnotation {
        let centerCoordinate = findClosestLocation(from: locationA, to: locationB)
        
        let annotation = CustomAnnotation(coordinate: centerCoordinate, title: nil, subtitle: nil, imageName: imageName)
        
        return annotation
    }
    
    func findClosestLocation(from locationA: CLLocationCoordinate2D, to locationB: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
        let centerCoordinate = CLLocationCoordinate2D(latitude: (locationA.latitude + locationB.latitude)/2, longitude: (locationA.longitude + locationB.longitude)/2)
        let centerCoordinate1 = findFinalClosestLocation(from: locationA, to: centerCoordinate)
       
        return centerCoordinate1
    }
    
    func findFinalClosestLocation(from locationA: CLLocationCoordinate2D, to locationB: CLLocationCoordinate2D) -> CLLocationCoordinate2D {
       
        let centerCoordinate = CLLocationCoordinate2D(latitude: (locationA.latitude + locationB.latitude)/2 , longitude: (locationA.longitude + locationB.longitude)/2 )
       
        return centerCoordinate
    }
    
    
    var annotationsRect = MKMapRect.null //區域位置範圍
    //計算區域範圍位置
    func calculateInAreaRange(annotation1:CustomAnnotation,
                              annotation2:CustomAnnotation,
                              annotation3:CustomAnnotation,
                              annotation4:CustomAnnotation,
                              annotation5:CustomAnnotation,
                              annotation6:CustomAnnotation,
                              annotation7:CustomAnnotation
    ){
        for annotation in [annotation1, annotation2, annotation3, annotation4, annotation5, annotation6, annotation7] {
            let annotationPoint = MKMapPoint(annotation.coordinate)
            annotationsRect = annotationsRect.union(MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0))
        }

    }
 
    func findCenterCoordinate(for annotations: [CustomAnnotation]) -> CLLocationCoordinate2D {
        var x: Double = 0
        var y: Double = 0
        var z: Double = 0
        
        for annotation in annotations {
            let lat = annotation.coordinate.latitude * Double.pi / 180
            let lon = annotation.coordinate.longitude * Double.pi / 180
            
            x += cos(lat) * cos(lon)
            y += cos(lat) * sin(lon)
            z += sin(lat)
        }
        
        let count = Double(annotations.count)
        x /= count
        y /= count
        z /= count
        
        let lon = atan2(y, x)
        let hyp = sqrt(x * x + y * y)
        let lat = atan2(z, hyp)
        
        let centerCoordinate = CLLocationCoordinate2D(latitude: lat * 180 / Double.pi, longitude: lon * 180 / Double.pi)
       
        return centerCoordinate
    }
  
    
    func getDirections(to destination: MKMapItem) {
        //偵測顯示地圖地理位置
        let sourcePlacemark = MKPlacemark(coordinate: currentCoordinate)
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        
        let directionsRequest = MKDirections.Request()
        directionsRequest.source = sourceMapItem
        directionsRequest.destination = destination
        directionsRequest.transportType = .automobile
        // Set the locale to Chinese
     

        
        let directions = MKDirections(request: directionsRequest)
        directions.calculate { [self] (response, _) in
            guard let response = response else { return }
            guard let primaryRoute = response.routes.first else { return }
            
            self.mapView.addOverlay(primaryRoute.polyline)
            
        self.locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for: $0) })
            
            self.steps = primaryRoute.steps
            for i in 0 ..< primaryRoute.steps.count {
                let step = primaryRoute.steps[i]
                print(step.instructions)
                print(step.distance)
                let region = CLCircularRegion(center: step.polyline.coordinate,
                                              radius: 20,
                                              identifier: "\(i)")
                self.locationManager.startMonitoring(for: region)
                let circle = MKCircle(center: region.center, radius: region.radius)
                self.mapView.addOverlay(circle)
                
            }
            
         
            //顯示目前導航位置
            let initialMessage = " 在\(self.steps[0].distance) 米, \(self.steps[0].instructions) 然後在 \(self.steps[1].distance) 米, \(self.steps[1].instructions)."
            self.directionsLabel.text = initialMessage
            self.stepCounter += 1
        }
    }
    
    
   
    
    @objc func startNavigationTracking() {
       
        //用戶輸入好位置後反應。
        let localSearchRequest = MKLocalSearch.Request()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        let region = MKCoordinateRegion(center: currentCoordinate, span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        localSearchRequest.region = region
        let localSearch = MKLocalSearch(request: localSearchRequest)
        
       
        localSearch.start { (response, _) in
            guard let response = response else { return }
            guard let firstMapItem = response.mapItems.first else { return }
            self.getDirections(to: firstMapItem)
        }
        
       }
    
    @objc func startAreaTracking() {
        //檢測用戶是否在圍欄區域
        let currentLocation = CLLocation(latitude: currentCoordinate.latitude, longitude: currentCoordinate.latitude)
        let currentLocationPoint = MKMapPoint(currentLocation.coordinate)
        let isInside = annotationsRect.contains(currentLocationPoint)

        if isInside {
            //觸發能量集滿event!!!!!
            print("目前位置在annotation的範圍內")
            
        } else {
            //不在這個區域位置，請忽略
            print("目前位置不在annotation的範圍內")
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //取消所有timer設置
        timer?.invalidate()
        timer = nil
        areaTimer?.invalidate()
        areaTimer?.invalidate()
    }

}

extension NavigationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        manager.stopUpdatingLocation()
        guard let currentLocation = locations.first else { return }
        currentCoordinate = currentLocation.coordinate
        print("current location is ",currentLocation)
        mapView.userTrackingMode = .followWithHeading
        
   //     let currentLocation = CLLocation(latitude: currentCoordinate.latitude, longitude: currentCoordinate.latitude)
      /**
       let currentLocationPoint = MKMapPoint(currentLocation.coordinate)
       let isInside = annotationsRect.contains(currentLocationPoint)

       if isInside {
           print("目前位置在annotation的範圍內")
       } else {
           print("目前位置不在annotation的範圍內")
       }
       */
        
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        stepCounter += 1
        if stepCounter < steps.count {
            let currentStep = steps[stepCounter]
            let message = "在 \(currentStep.distance) 米, \(currentStep.instructions)"
            directionsLabel.text = message

         
        } else {
            let message = "到達目的地"
            directionsLabel.text = message
            stepCounter = 0
            locationManager.monitoredRegions.forEach({ self.locationManager.stopMonitoring(for: $0) })
            
        }
       
    }
}

extension NavigationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        print("開始導航......")
        
        // Start the timer 用戶確認，開始導航timer
            timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(startNavigationTracking), userInfo: nil, repeats: true)
            timer?.fire()
        
        
        // Start the timer 檢測用戶是否在圍欄區域timer
        areaTimer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(startAreaTracking), userInfo: nil, repeats: true)
        areaTimer?.fire()
        

        
        
    }
}

extension NavigationViewController: MKMapViewDelegate {
    //地圖上風格
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKPolyline {
            let renderer = MKPolylineRenderer(overlay: overlay)
            renderer.strokeColor = .green
            renderer.fillColor = .green
            renderer.lineWidth = 5
            renderer.alpha = 0.4
            return renderer
        }
        if overlay is MKCircle {
            let renderer = MKCircleRenderer(overlay: overlay)
            renderer.strokeColor = .red
            renderer.fillColor = .red
            renderer.alpha = 0.2
            return renderer
        }
        
        if let polygonOverlay = overlay as? MKPolygon {
            let polygonRenderer = MKPolygonRenderer(polygon: polygonOverlay)
            polygonRenderer.strokeColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0) // 設定邊框為藍色
            polygonRenderer.lineWidth = 1.0
            polygonRenderer.fillColor = UIColor(red: 130/255, green: 224/255, blue: 170/255, alpha: 0.5) // 設定填充為半透明的紅色
            return polygonRenderer
        }
        return MKOverlayRenderer()
    }
    
    // 6. 自定義annotationView
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard let customAnnotation = annotation as? CustomAnnotation else { return nil }
        
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "customAnnotation", for: customAnnotation)
        if annotationView == nil {
            annotationView = CustomAnnotationView(annotation: customAnnotation, reuseIdentifier: "customAnnotation")
            annotationView.canShowCallout = true
        } else {
            annotationView.annotation = customAnnotation
        }
        return annotationView
    }
    
    
    
    
    
    
    

}

class CustomAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var imageName: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String?, subtitle: String?, imageName: String?) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.imageName = imageName
    }
}

class CustomAnnotationView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        didSet {
            guard let customAnnotation = annotation as? CustomAnnotation else { return }
            image = UIImage(named: customAnnotation.imageName ?? "")
            frame.size = CGSize(width: 30, height: 30)
        }
    }
}
