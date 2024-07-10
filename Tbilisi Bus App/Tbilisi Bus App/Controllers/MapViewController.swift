//
//  MapViewController.swift
//  Tbilisi Bus App
//
//  Created by Levan Qorqia on 03.07.24.
//

import UIKit
import MapboxMaps

class MapViewController: UIViewController {
    var mapView: MapView!
    var busStopAnnotations = [ViewAnnotation]()
    var metroStationAnnotations = [ViewAnnotation]()
    var busStopLocations = [Location]()
    var metroStationLocations = [Station]()

    override func viewDidLoad() {
        super.viewDidLoad()

        mapView = MapView(frame: view.bounds)
        mapView.mapboxMap.styleURI = .outdoors
        let centerCoordinate = CLLocationCoordinate2D(latitude: 41.73244653653062, longitude: 44.78004042311896)
        let cameraOptions = CameraOptions(center: centerCoordinate, zoom: 12, bearing: 0, pitch: 0)
        mapView.mapboxMap.setCamera(to: cameraOptions)
        mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        view.addSubview(mapView)

        addBusAnnotations()
        addMetroAnnotations()
    }

    func loadBusLocations() {
        guard let fileURL = Bundle.main.url(forResource: "bus_locations", withExtension: "json") else {
            return
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let locationsData = try decoder.decode(Locations.self, from: data)
            busStopLocations = locationsData.Location

        } catch {
            print("Error loading locations: \(error)")
            return
        }
    }

    func addBusAnnotations() {
        loadBusLocations()
        let busStopImage = UIImage(named: "busStop")?.resize(to: CGSize(width: 20, height: 20))

        for (index, location) in busStopLocations.enumerated() {
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let annotationView = createBusStopAnnotationView(image: busStopImage, index: index)
            let annotation = ViewAnnotation(coordinate: coordinate, view: annotationView)
            busStopAnnotations.append(annotation)
            mapView.viewAnnotations.add(annotation)

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(annotationTapped(_:)))
            annotationView.addGestureRecognizer(tapGesture)
            annotationView.isUserInteractionEnabled = true
        }
    }

    private func createBusStopAnnotationView(image: UIImage?, index: Int) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .blue
        imageView.accessibilityLabel = "busStop_\(index)"
        return imageView
    }

    func loadMetroLocations() {
        guard let fileURL = Bundle.main.url(forResource: "metro_locations", withExtension: "json") else {
            return
        }

        do {
            let data = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            let locationsData = try decoder.decode(Stations.self, from: data)
            metroStationLocations = locationsData.Station

        } catch {
            print("Error loading locations: \(error)")
            return
        }
    }

    func addMetroAnnotations() {
        loadMetroLocations()

        let metroStationImage_1 = UIImage(named: "metroStation_1")?.resize(to: CGSize(width: 20, height: 20))
        let metroStationImage_2 = UIImage(named: "metroStation_2")?.resize(to: CGSize(width: 20, height: 20))

        for (index, location) in metroStationLocations.enumerated() {
            let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
            let annotationView = createMetroStationAnnotationView(image: location.line == 1 ? metroStationImage_1 : metroStationImage_2, index: index)
            let annotation = ViewAnnotation(coordinate: coordinate, view: annotationView)
            metroStationAnnotations.append(annotation)
            mapView.viewAnnotations.add(annotation)

            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(annotationTapped(_:)))
            annotationView.addGestureRecognizer(tapGesture)
            annotationView.isUserInteractionEnabled = true
        }
    }

    private func createMetroStationAnnotationView(image: UIImage?, index: Int) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .blue
        imageView.accessibilityLabel = "metroStation_\(index)"
        return imageView
    }

    private func distanceBetween(_ coord1: CLLocationCoordinate2D, _ coord2: CLLocationCoordinate2D) -> CLLocationDistance {
        let location1 = CLLocation(latitude: coord1.latitude, longitude: coord1.longitude)
        let location2 = CLLocation(latitude: coord2.latitude, longitude: coord2.longitude)
        return location1.distance(from: location2)
    }

    @objc private func annotationTapped(_ sender: UITapGestureRecognizer) {
        guard let view = sender.view as? UIImageView,
              let label = view.accessibilityLabel else { return }

        if label.hasPrefix("busStop_") {
            let busAnnotationIndexString = label.replacingOccurrences(of: "busStop_", with: "")
            guard let busAnnotationIndex = Int(busAnnotationIndexString) else { return }

            let tappedBusAnnotation = busStopLocations[busAnnotationIndex]
            let busStopCoordinate = CLLocationCoordinate2D(latitude: tappedBusAnnotation.latitude, longitude: tappedBusAnnotation.longitude)

            let nearestMetroStation = metroStationLocations
                .map { (station: $0, distance: distanceBetween(busStopCoordinate, CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude))) }
                .min { $0.distance < $1.distance }

            let detailsVC = BusStopViewController()
            detailsVC.stop = tappedBusAnnotation

            if let nearestStation = nearestMetroStation, nearestStation.distance <= 200 {
                detailsVC.station = nearestStation.station
              detailsVC.distanceToTheMS = (nearestStation.distance * 10).rounded() / 10
            }

            navigationController?.pushViewController(detailsVC, animated: true)

        } else if label.hasPrefix("metroStation_") {
            let metroAnnotationIndexString = label.replacingOccurrences(of: "metroStation_", with: "")
            guard let metroAnnotationIndex = Int(metroAnnotationIndexString) else { return }

            let tappedMetroAnnotation = metroStationLocations[metroAnnotationIndex]
            let detailsVC = MetroStationViewController()
            detailsVC.station = tappedMetroAnnotation
            navigationController?.pushViewController(detailsVC, animated: true)
        }
    }
}







extension UIImage {
    func resize(to size: CGSize) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
