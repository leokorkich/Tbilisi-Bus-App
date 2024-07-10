//
//  BusStopViewController.swift
//  Tbilisi Bus App
//
//  Created by Levan Qorqia on 05.07.24.
//

import UIKit

class BusStopViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
  var tableView: UITableView!
  var busArrivalTimes: [BusArrivalTime] = []
  var metroArrivalTimes: [MetroArrivalTime] = []

  var stop: Location?
  var station: Station?
  var timer: Timer?
  var distanceToTheMS: Double?


  override func viewDidLoad() {
    super.viewDidLoad()
    
    view.backgroundColor = .systemBackground
    
    let label = UILabel()
    label.text = "Bus Stop - \(stop?.id ?? "")"
    label.textColor = .label
    label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(label)
    
    let subtitle = UILabel()
    subtitle.text = "\(stop?.name_en ?? "")"
    subtitle.textColor = .secondaryLabel
    subtitle.font = UIFont.systemFont(ofSize: 15, weight: .medium)
    subtitle.textAlignment = .center
    subtitle.translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(subtitle)
    
    tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(BusArrivalTimeTableViewCell.self, forCellReuseIdentifier: "BusArrivalTimeTableViewCell")
    tableView.register(MetroArrivalTimeTableViewCell.self, forCellReuseIdentifier: "MetroArrivalTimeTableViewCell")
    view.addSubview(tableView)

    if station != nil {
      
    }

    NSLayoutConstraint.activate([
      label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
      label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
      subtitle.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 5),
      subtitle.centerXAnchor.constraint(equalTo: view.centerXAnchor),

      tableView.topAnchor.constraint(equalTo: subtitle.bottomAnchor, constant: 16),
      tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
    ])
    

    loadBusArrivalTimes()
    if station != nil {
      loadMetroArrivalTimes()
    }


    timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
  }
  
  @objc func timerFired() {
    loadBusArrivalTimes()
    if station != nil {
      loadMetroArrivalTimes()
    }
  }
  
  func loadBusArrivalTimes() {
    APICaller.shared.getArrivalTimesForStop(stopId: Int(stop?.id ?? "") ?? 0) { result in
      DispatchQueue.main.async {
        switch result {
        case .success(let busArrivalTimes):
          self.busArrivalTimes = busArrivalTimes
          self.tableView.reloadData()
        case .failure(let error):
          print(error)
        }
      }
    }
  }

  func loadMetroArrivalTimes() {
      APICaller.shared.getArrivalTimesForStation(stationId: station?.id ?? "") { result in
          DispatchQueue.main.async {
              switch result {
              case .success(let metroArrivalTimes):
                  self.metroArrivalTimes = metroArrivalTimes
                  self.tableView.reloadData()
              case .failure(let error):
                  print(error)
              }
          }
      }
  }

  // MARK: - UITableViewDataSource
  
  func numberOfSections(in tableView: UITableView) -> Int {
      return station != nil ? 2 : 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      switch section {
      case 0:
        return busArrivalTimes.count
      case 1:
        return metroArrivalTimes.count
      default:
        return 0
      }
    }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    switch indexPath.section {
    case 0:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "BusArrivalTimeTableViewCell", for: indexPath) as? BusArrivalTimeTableViewCell else {
        return UITableViewCell()
      }
      cell.configure(with: busArrivalTimes[indexPath.row])
      return cell
    case 1:
      guard let cell = tableView.dequeueReusableCell(withIdentifier: "MetroArrivalTimeTableViewCell", for: indexPath) as? MetroArrivalTimeTableViewCell else {
        return UITableViewCell()
      }
      cell.configure(with: metroArrivalTimes[indexPath.row])
      return cell
    default:
      return UITableViewCell()
    }
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
      switch section {
      case 0:
        return 30
      case 1:
          return 70
      default:
          return 70
      }
  }

  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = UIView()
    headerView.backgroundColor = .systemBackground

    switch section {
    case 0:
      if busArrivalTimes.isEmpty {
        let view = UIView()


        let label = UILabel()
        let currentDate = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: currentDate)

        if hour >= 23 && hour < 6 {
          label.text = "There's probably no public transport running right now"
        } else {
          label.text = "An error occurred, try again later"
        }
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)


        NSLayoutConstraint.activate([
          label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
          label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        headerView.addSubview(view)
        return headerView
      }
      else {
        let view = UIView()


        let label = UILabel()
        label.text = "Arrivals"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)


        NSLayoutConstraint.activate([
          label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
          label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        headerView.addSubview(view)
        return headerView
      }


    case 1:
      let view = UIView()
      view.translatesAutoresizingMaskIntoConstraints = false
      headerView.addSubview(view)

      let nearestText = UILabel()
      nearestText.text = "Nearest metro station:"
      nearestText.textColor = .secondaryLabel
      nearestText.font = UIFont.systemFont(ofSize: 20, weight: .medium)
      nearestText.textAlignment = .center
      nearestText.numberOfLines = 0
      nearestText.lineBreakMode = .byWordWrapping
      nearestText.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(nearestText)

      let metroNumberContainer = UIView()
      metroNumberContainer.translatesAutoresizingMaskIntoConstraints = false
      metroNumberContainer.layer.cornerRadius = 7
      metroNumberContainer.layer.masksToBounds = true
      metroNumberContainer.backgroundColor = station?.line == 1 ? UIColor(red: 0.79, green: 0.19, blue: 0.19, alpha: 1.0) : UIColor(red: 0.19, green: 0.79, blue: 0.19, alpha: 1.0)
      view.addSubview(metroNumberContainer)

      let metroNumber = UILabel()
      metroNumber.text = "\(station?.line ?? 0)"
      metroNumber.translatesAutoresizingMaskIntoConstraints = false
      metroNumber.textColor = .white
      metroNumber.font = UIFont.systemFont(ofSize: 20, weight: .bold)
      metroNumberContainer.addSubview(metroNumber)

      let label = UILabel()
      label.text = "\(station?.name ?? "N/A")"
      label.textColor = .label
      label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
      label.textAlignment = .center
      label.numberOfLines = 0
      label.lineBreakMode = .byWordWrapping
      label.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(label)

      let distanceText = UILabel()
      distanceText.text = "(~\(distanceToTheMS ?? 0)m)"
      distanceText.textColor = .secondaryLabel
      distanceText.font = UIFont.systemFont(ofSize: 20, weight: .medium)
      distanceText.textAlignment = .center
      distanceText.numberOfLines = 0
      distanceText.lineBreakMode = .byWordWrapping
      distanceText.translatesAutoresizingMaskIntoConstraints = false
      view.addSubview(distanceText)

        NSLayoutConstraint.activate([
            nearestText.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            nearestText.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            nearestText.centerYAnchor.constraint(equalTo: view.centerYAnchor),

            metroNumberContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            metroNumberContainer.topAnchor.constraint(equalTo: nearestText.bottomAnchor, constant: 10),
            metroNumberContainer.widthAnchor.constraint(equalToConstant: 30),
            metroNumberContainer.heightAnchor.constraint(equalToConstant: 30),

            metroNumber.centerXAnchor.constraint(equalTo: metroNumberContainer.centerXAnchor),
            metroNumber.centerYAnchor.constraint(equalTo: metroNumberContainer.centerYAnchor),

            label.leadingAnchor.constraint(equalTo: metroNumberContainer.trailingAnchor, constant: 10),
            label.centerYAnchor.constraint(equalTo: metroNumberContainer.centerYAnchor),
            distanceText.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10),
            distanceText.centerYAnchor.constraint(equalTo: metroNumberContainer.centerYAnchor)
        ])

        return headerView



    default:
      return nil
    }
  }

  
  // MARK: - UITableViewDelegate
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    
    let busArrivalTime = busArrivalTimes[indexPath.row]
    
    let detailViewController = UIViewController()
    detailViewController.view.backgroundColor = .white
    detailViewController.title = busArrivalTime.headsign
    
    let label = UILabel()
    label.text = "Details for bus \(busArrivalTime.shortName)"
    label.textColor = .black
    label.textAlignment = .center
    label.translatesAutoresizingMaskIntoConstraints = false
    detailViewController.view.addSubview(label)
    
    NSLayoutConstraint.activate([
      label.centerXAnchor.constraint(equalTo: detailViewController.view.centerXAnchor),
      label.centerYAnchor.constraint(equalTo: detailViewController.view.centerYAnchor)
    ])
    
    navigationController?.pushViewController(detailViewController, animated: true)
  }
  
  deinit {
    timer?.invalidate()
  }
}




class BusArrivalTimeTableViewCell: UITableViewCell {

    let busNumberContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.masksToBounds = true
        return view
    }()

    let busNumber: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        return label
    }()

    let busDestination: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    let arrivalTime: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        contentView.addSubview(busNumberContainer)
        busNumberContainer.addSubview(busNumber)
        contentView.addSubview(busDestination)
        contentView.addSubview(arrivalTime)

        NSLayoutConstraint.activate([
            busNumberContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            busNumberContainer.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            busNumber.leadingAnchor.constraint(equalTo: busNumberContainer.leadingAnchor, constant: 8),
            busNumber.trailingAnchor.constraint(equalTo: busNumberContainer.trailingAnchor, constant: -8),
            busNumber.topAnchor.constraint(equalTo: busNumberContainer.topAnchor, constant: 4),
            busNumber.bottomAnchor.constraint(equalTo: busNumberContainer.bottomAnchor, constant: -4),

            busDestination.leadingAnchor.constraint(equalTo: busNumberContainer.trailingAnchor, constant: 15),
            busDestination.trailingAnchor.constraint(equalTo: arrivalTime.leadingAnchor, constant: -10),
            busDestination.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            arrivalTime.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
            arrivalTime.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrivalTime.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with busArrivalTime: BusArrivalTime) {
        busNumber.text = busArrivalTime.shortName
        busDestination.text = busArrivalTime.headsign
        arrivalTime.text = "\(busArrivalTime.realtimeArrivalMinutes)"

        switch busArrivalTime.color {
        case "00B38B":
            busNumberContainer.backgroundColor = UIColor(red: 0.1, green: 0.7, blue: 0.1, alpha: 1.0)
        case "0033B4":
            busNumberContainer.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.8, alpha: 1.0)
        default:
            busNumberContainer.backgroundColor = UIColor(red: 0.1, green: 0.7, blue: 0.1, alpha: 1.0)
        }
    }
}


