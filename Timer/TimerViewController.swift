import UIKit

final class ViewController: UIViewController {
    
    private var timer : Timer?
    
    private var timerState: TimerState = .pickingTime
    
    private var remainingTime: Int = 0 {
        didSet {
            timeLabel.text = timeFormatter.string(from: TimeInterval(remainingTime))
        }
    }
    
    private let timeFormatter: DateComponentsFormatter = {
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
        button.setTitle("Start", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemBlue.withAlphaComponent(0.1)
        button.layer.cornerRadius = 16
        button.addTarget(self, action: #selector(startResumeButtonTapped), for: .touchUpInside)
        return button
    }()
    
    private lazy var stopButton: UIButton = {
        let button = UIButton()
        button.setTitle("Stop", for: .normal)
        button.setTitleColor(.systemRed, for: .normal)
        button.backgroundColor = .systemRed.withAlphaComponent(0.1)
        button.layer.cornerRadius = 16
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
            timeLabel.isHidden = false
            remainingTime = Int(timePicker.countDownDuration)
            
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
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            
            guard let self,
                  self.remainingTime > 0
            else {
                return
            }
            
            self.remainingTime -= 1
        }
        
        if let timer {
            RunLoop.current.add(timer, forMode: RunLoop.Mode.common)
        }
        
        startPauseButton.setTitle("Pause", for: .normal)
    }
    
    private func pauseTimer() {
        timer?.invalidate()
        timer = nil
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
            stopButton.widthAnchor.constraint(equalToConstant: 150),
            stopButton.heightAnchor.constraint(equalToConstant: 44),
            
            startPauseButton.bottomAnchor.constraint(equalTo: stopButton.topAnchor, constant: -16),
            startPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startPauseButton.widthAnchor.constraint(equalToConstant: 150),
            startPauseButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}
