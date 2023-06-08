//
//  MapViewController.swift
//  Walkation
//
//  Created by Matt on 17/5/2023.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController,MKMapViewDelegate {
    
    var mapView =  MKMapView()
     override func viewDidLoad() {
         super.viewDidLoad()
         //建立地圖
         mapView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
         self.view.addSubview(mapView)
         mapView.delegate = self
         
         
         // 1. 將地圖中心設定為香港,調較數據
         let initialLocation = CLLocation(latitude: 22.30312, longitude: 114.17169)
         let regionRadius: CLLocationDistance = 2000
         let coordinateRegion = MKCoordinateRegion(center: initialLocation.coordinate,
                                                   latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
         mapView.setRegion(coordinateRegion, animated: true)
         mapView.mapType = .standard

         
         // 2. 建立自定義的annotation,自定義圖片
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
         let x  = findCenterCoordinate(for: [annotation1, annotation2, annotation3,annotation4,annotation5,annotation6,annotation7]).latitude
         let y = findCenterCoordinate(for: [annotation1, annotation2, annotation3,annotation4,annotation5,annotation6,annotation7]).longitude
       
         
         let annotation9 = CustomAnnotation(coordinate: CLLocationCoordinate2D(latitude:x, longitude: y),
                                             title: "Lamma Island", subtitle: "A peaceful island with scenic hiking trails and seafood restaurants",
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
         mapView.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: "customAnnotation")
         
         // 4. 繪製圍欄
         let fenceCoordinates = [annotation1.coordinate,annotation2.coordinate,annotation3.coordinate,annotation4.coordinate,annotation5.coordinate,annotation6.coordinate,annotation7.coordinate]
         let fence = polygon(for: fenceCoordinates)
         mapView.addOverlay(fence!)
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
  
  
     
     // 5. 自定義overlayView
     func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
         if let polygonOverlay = overlay as? MKPolygon {
             let polygonRenderer = MKPolygonRenderer(polygon: polygonOverlay)
             polygonRenderer.strokeColor = UIColor(red: 39/255, green: 174/255, blue: 96/255, alpha: 1.0) // 設定邊框為藍色
             polygonRenderer.lineWidth = 1.0
             polygonRenderer.fillColor = UIColor(red: 130/255, green: 224/255, blue: 170/255, alpha: 0.5) // 設定填充為半透明的紅色
             return polygonRenderer
         } else if let polylineOverlay = overlay as? MKPolyline {
             let polylineRenderer = MKPolylineRenderer(polyline: polylineOverlay)
             polylineRenderer.strokeColor = UIColor.gray // 設定線條為黑色
             polylineRenderer.lineWidth = 1.0
            
             return polylineRenderer
         }
         return MKOverlayRenderer(overlay: overlay)
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
}




