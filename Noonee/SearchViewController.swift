//
//  SearchViewController.swift
//  Noonee
//
//  Created by 이재은 on 2021/05/22.
//

import UIKit
import Speech
import NVActivityIndicatorView

final class SearchViewController: UIViewController, SFSpeechRecognizerDelegate {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var speechTextField: UITextField!
    @IBOutlet private weak var recordAnimationView: NVActivityIndicatorView!

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))

    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    var isDeparture: Bool = true
    var searchText = ""


    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel.becomeFirstResponder()
        titleLabel.isAccessibilityElement = true
        UIAccessibility.post(notification: .screenChanged, argument: titleLabel)
        if isDeparture {
            titleLabel.accessibilityLabel = "Let's set the departure. Please say your departure address slowly."
        } else {
            titleLabel.accessibilityLabel = "Next, It’s time to set the destination now. Please say your destination address."
        }

        // 기존 코드
//        DispatchQueue.main.asyncAfter(deadline: .now() + 12) {
//            if let vc = UIStoryboard(name: "SearchResult", bundle: .main)
//                .instantiateViewController(withIdentifier: "SearchResultController") as? SearchResultController {
//                vc.titleText = self.searchText
//                vc.isDeparture = self.isDeparture
//                self.navigationController?.pushViewController(vc, animated: true)
//            }
//        }

        // 테스트용 코드
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            if let vc = UIStoryboard(name: "SearchResult", bundle: .main)
                .instantiateViewController(withIdentifier: "SearchResultController") as? SearchResultController {
                vc.titleText = "서울"
                vc.isDeparture = self.isDeparture
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setLayout()
        setNaviBar()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // 기존 코드
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.startRecording()
//        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        audioEngine.accessibilityActivate()
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        if audioEngine.isRunning {
            audioEngine.stop()
            recognitionRequest?.endAudio()
            recognitionTask?.finish()
            recognitionTask?.cancel()
            recognitionRequest = nil
            recognitionTask = nil
        }
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
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.setMode(AVAudioSession.Mode.spokenAudio)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

            let currentRoute = AVAudioSession.sharedInstance().currentRoute
                for description in currentRoute.outputs {
                    if description.portType == AVAudioSession.Port.headphones {
                        try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.none)
                        print("headphone plugged in")
                    } else {
                        print("headphone pulled out")
                        try audioSession.overrideOutputAudioPort(AVAudioSession.PortOverride.speaker)
                    }
            }
        } catch {
            print("audioSession properties weren't set because of an error.")
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()

        let inputNode = audioEngine.inputNode

        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }

        recognitionRequest.shouldReportPartialResults = true

        self.recognitionTask = self.speechRecognizer?
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
