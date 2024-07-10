//
//  MetroStationViewController.swift
//  Tbilisi Bus App
//
//  Created by Levan Qorqia on 10.07.24.
//

import UIKit

class MetroStationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var tableView: UITableView!
    var metroArrivalTimes: [MetroArrivalTime] = []

  var station: Station?


    var timer: Timer?

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground

        let metroNumberContainer = UIView()
        metroNumberContainer.translatesAutoresizingMaskIntoConstraints = false
        metroNumberContainer.layer.cornerRadius = 10
        metroNumberContainer.layer.masksToBounds = true
      metroNumberContainer.backgroundColor = station?.line == 1 ? UIColor(red: 0.79, green: 0.19, blue: 0.19, alpha: 1.0) : UIColor(red: 0.19, green: 0.79, blue: 0.19, alpha: 1.0)
        view.addSubview(metroNumberContainer)

        let metroNumber = UILabel()
        metroNumber.text = "\(station?.line ?? 0)"
        metroNumber.translatesAutoresizingMaskIntoConstraints = false
        metroNumber.textColor = .white
        metroNumber.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        metroNumberContainer.addSubview(metroNumber)

        let label = UILabel()
        label.text = "\(station?.name ?? "N/A")"
        label.textColor = .label
        label.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)

        tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(MetroArrivalTimeTableViewCell.self, forCellReuseIdentifier: "MetroArrivalTimeTableViewCell")
        view.addSubview(tableView)

        NSLayoutConstraint.activate([
            metroNumberContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
            metroNumberContainer.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            metroNumberContainer.widthAnchor.constraint(equalToConstant: 40),
            metroNumberContainer.heightAnchor.constraint(equalToConstant: 40),

            metroNumber.centerXAnchor.constraint(equalTo: metroNumberContainer.centerXAnchor),
            metroNumber.centerYAnchor.constraint(equalTo: metroNumberContainer.centerYAnchor),

            label.leadingAnchor.constraint(equalTo: metroNumberContainer.trailingAnchor, constant: 16),
            label.centerYAnchor.constraint(equalTo: metroNumberContainer.centerYAnchor),

            tableView.topAnchor.constraint(equalTo: metroNumberContainer.bottomAnchor, constant: 16),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        loadMetroArrivalTimes()

        timer = Timer.scheduledTimer(timeInterval: 30.0, target: self, selector: #selector(timerFired), userInfo: nil, repeats: true)
    }

    @objc func timerFired() {
        loadMetroArrivalTimes()
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

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return metroArrivalTimes.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MetroArrivalTimeTableViewCell", for: indexPath) as? MetroArrivalTimeTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: metroArrivalTimes[indexPath.row])
        return cell
    }

    deinit {
        timer?.invalidate()
    }
}

class MetroArrivalTimeTableViewCell: UITableViewCell {

    let metroDestination: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .secondaryLabel
        label.font = UIFont.systemFont(ofSize: 17, weight: .bold)
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

        contentView.addSubview(metroDestination)
        contentView.addSubview(arrivalTime)

        NSLayoutConstraint.activate([
            metroDestination.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            metroDestination.trailingAnchor.constraint(equalTo: arrivalTime.leadingAnchor, constant: -10),
            metroDestination.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            arrivalTime.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 10),
            arrivalTime.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            arrivalTime.widthAnchor.constraint(equalToConstant: 50)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with metroArrivalTime: MetroArrivalTime) {
        metroDestination.text = metroArrivalTime.headsign
        arrivalTime.text = "\(metroArrivalTime.realtimeArrivalMinutes)"
    }
}

