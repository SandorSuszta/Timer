import UIKit

final class ViewController: UIViewController {
    
    private var timer : Timer?
    
    private var timerState: TimerState = .pickingTime
    
    private let formatter: DateComponentsFormatter = {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        return formatter
    }()
    
    private let timePicker: UIDatePicker = {
        let picker = UIDatePicker()
        picker.datePickerMode = .countDownTimer
        return picker
    }()
    
    private let timeLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        label.font = .systemFont(ofSize: 80, weight: .regular)
        return label
    }()
    
    private lazy var startPauseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.addTarget(self, action: #selector(startResumeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Stop", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.addTarget(self, action: #selector(stopButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupViewHierarchy()
        setupLayout()
    }
    
    //MARK: - Private methods
    
    @objc func startResumeButtonTapped() {
        switch timerState {
            
        case .pickingTime:
            timerState = .isRunning
            timePicker.isHidden = true
            timeLabel.text = formatter.string(from: timePicker.countDownDuration)
            timeLabel.isHidden = false
            startTimer()
            
        case .isRunning:
            timerState = .paused
            pauseTimer()
            
        case .paused:
            timerState = .isRunning
            startTimer()
        }
    }
    
    @objc func stopButtonTapped() {
        timerState = .pickingTime
        timePicker.isHidden = false
        timeLabel.isHidden = true
        stopTimer()
    }
    
    private func startTimer() {
        startPauseButton.setTitle("Pause", for: .normal)
    }
    
    private func pauseTimer() {
        startPauseButton.setTitle("Resume", for: .normal)
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        timerState = .pickingTime
        timePicker.isHidden = false
        timeLabel.isHidden = true
        
        startPauseButton.setTitle("Start", for: .normal)
    }
    
    private func setupViewHierarchy() {
        view.addSubview(timeLabel)
        view.addSubview(startPauseButton)
        view.addSubview(stopButton)
        view.addSubview(timePicker)
    }
    
    private func setupLayout() {
        
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
        startPauseButton.translatesAutoresizingMaskIntoConstraints = false
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        timePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            timePicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timePicker.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            stopButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            stopButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            startPauseButton.bottomAnchor.constraint(equalTo: stopButton.topAnchor, constant: -30),
            startPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }
}
