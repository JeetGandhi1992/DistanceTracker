//
//  MapView.swift
//  Distance Tracker
//
//  Created by Jeet Gandhi on 6/4/21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    var coordinates: [CLLocationCoordinate2D]

    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        
        init(_ parent: MapView) {
            self.parent = parent
        }
        
        func mapViewDidChangeVisibleRegion(_ mapView: MKMapView) {
            print(mapView.centerCoordinate)
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: nil)
            view.canShowCallout = true
            return view
        }
        
        
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            guard let polyline = overlay as? MKPolyline else {
                return MKOverlayRenderer(overlay: overlay)
            }
            let renderer = MKPolylineRenderer(polyline: polyline)
            renderer.strokeColor = .blue
            renderer.lineWidth = 5
            renderer.lineCap = .round
            renderer.lineJoin = .round
            return renderer
        }
        
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    func makeUIView(context: UIViewRepresentableContext<MapView>) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        
        return mapView
    }
    
    func updateUIView(_ view: MKMapView, context: UIViewRepresentableContext<MapView>) {
        if coordinates.count > 0 {
            view.addOverlay(MKPolyline(coordinates: coordinates,
                                          count: coordinates.count))
            let region = MKCoordinateRegion.init(center: coordinates.last!, latitudinalMeters: 500, longitudinalMeters: 500)
            
            view.setRegion(region, animated: true)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    
    static var previews: some View {
        MapView(coordinates: [CLLocationCoordinate2D(latitude: 25.7617,
                                                     longitude: 80.1918)])
    }
}
