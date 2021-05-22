//
//  SearchViewController.swift
//  Noonee
//
//  Created by 이재은 on 2021/05/22.
//

import UIKit
import Speech
import NVActivityIndicatorView

final class SearchViewController: UIViewController {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var speechTextField: UITextField!
    @IBOutlet private weak var recordAnimationView: NVActivityIndicatorView!

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var isDeparture: Bool = true
    var timer = Timer()
    var searchText = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if let vc = UIStoryboard(name: "SearchResult", bundle: .main)
                .instantiateViewController(withIdentifier: "SearchResultController") as? SearchResultController {
                vc.titleText = self.searchText
                vc.isDeparture = self.isDeparture
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        setLayout()
        setNaviBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        startRecording()
    }

    override func viewWillDisappear(_ animated: Bool) {
        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
        }
        timer.invalidate()
    }

    private func setNaviBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.backgroundColor = UIColor(named: "naviBlack")
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }

    private func setLayout() {
        recordAnimationView.type = .ballScaleMultiple
        recordAnimationView.color = UIColor(named: "mainGreen")!
        recordAnimationView.startAnimating()

        if !isDeparture {
            titleLabel.text = "Destination"
        }

        if isDeparture {
            speechTextField.text = "Say your departure"
        } else {
            speechTextField.text = "Say your destination"
        }

        speechTextField.textColor = UIColor(named: "MainGray")
    }

    private func startRecording() {
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }

        recognitionRequest.shouldReportPartialResults = true

        recognitionTask = speechRecognizer?
            .recognitionTask(with: recognitionRequest,
                             resultHandler: { (result, error) in
                                var isFinal = false

                                if result != nil {
                                    self.speechTextField.text = result?.bestTranscription.formattedString
                                    self.searchText = self.speechTextField.text ?? ""
                                    isFinal = (result?.isFinal)!
                                }

                                if error != nil || isFinal {
                                    self.audioEngine.stop()
                                    inputNode.removeTap(onBus: 0)
                                    self.recognitionTask?.finish()
                                    self.recognitionRequest = nil
                                    self.recognitionTask = nil
                                }
        })

        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0,
                             bufferSize: 1024,
                             format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }

        audioEngine.prepare()

        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
    }
}
