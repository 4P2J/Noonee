//
//  HomeViewController.swift
//  Noonee
//
//  Created by 이재은 on 2021/05/22.
//

import UIKit
import SnapKit
import LocalAuthentication

final class HomeViewController: UIViewController {

  // MARK: UI

  @IBOutlet private weak var journeyButton: UIButton!
  @IBOutlet private weak var historyButton: UIButton!
  @IBOutlet private weak var settingButton: UIButton!
    @IBOutlet private weak var busStopLabel: UILabel!
    @IBOutlet private weak var busNumberLabel: UILabel!
    @IBOutlet private weak var timeLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var backView: UIView!

  private lazy var animateCircle: CircleView = {
    var circle: CircleView = CircleView()
    var centerX = UIScreen.main.bounds.size.width * 0.5
    var centerY = UIScreen.main.bounds.size.height * 0.5
    circle.frame = CGRect(x: centerX, y: centerY, width: 100, height: 100)
    circle.layer.backgroundColor = UIColor.red.cgColor
    circle.layer.cornerRadius = 50
    circle.layer.shadowOpacity = 0.5
    circle.layer.shadowRadius = 7
    return circle
  }()
  private var firstAlertLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 22)
    return label
  }()
  private var secondAlertLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 25)
    return label
  }()


  // MARK: Properties

  private lazy var viewCenter: CGPoint = self.view.center
  private lazy var firstFrame = self.animateCircle.frame.insetBy(dx: -50, dy: -50)
  private lazy var secondFrame = self.animateCircle.frame.insetBy(dx: 15, dy: 15)
  private lazy var thirdFrame = self.animateCircle.frame.insetBy(dx: -20, dy: -20)
  private lazy var lastFrame = self.animateCircle.frame.insetBy(dx: 105, dy: 105)
    private var homeState = HomeState(rawValue: UserData.homeState ?? "first")
    let authContext = LAContext()
    var message : String?


  private var isRecievedEvent: AlertAnimation = .none
  {
    didSet {
      switch isRecievedEvent {
      case .none:
        return
      case .payment:
        self.colorFrameChange(UIColor(named: "AlertColorYellow"))
      case .isArrived:
        self.colorFrameChange(UIColor(named: "mainGreen"))
      case .isOnBoard:
        self.colorFrameChange(UIColor(named: "AlertColorYellow"))
      case .curveSoon:
        self.colorFrameChange(UIColor(named: "AlertColorRed"))
      case .afterOneStation:
        self.colorFrameChange(UIColor(named: "mainGreen"))
      case .getOffNow:
        self.colorFrameChange(UIColor(named: "mainGreen"))
      case .completeTheJourney:
        self.colorFrameChange(UIColor(named: "AlertColorYellow"))
      }
    }
  }
  private let duration: Double = 2


  // MARK: Functions

  private func colorFrameChange(_ color: UIColor?) {
    DispatchQueue.main.async {
      self.animateCircle.backgroundColor = color
      UIView.animate(withDuration: self.duration, animations: {
        self.animateCircle.frame = self.firstFrame
      }) { _ in
        UIView.animate(withDuration: self.duration, animations: {
          self.animateCircle.frame = self.secondFrame
        }) { _ in
          UIView.animate(withDuration: self.duration, animations: {
            self.animateCircle.frame = self.thirdFrame
          }) { _ in
            UIView.animate(withDuration: self.duration, animations: {
              self.animateCircle.frame = self.lastFrame
            })
          }
        }
      }
    }
  }

  private func startAnimate() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.isRecievedEvent = .afterOneStation
    }

  }

  private enum ViewMetrics {
    static let buttonCornerRadius: CGFloat = 20
  }

    private enum HomeState: String {
        case first
        case departure
        case destionation
    }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setLayout()
    self.animationLayoutSet()
  }

    override func viewWillAppear(_ animated: Bool) {
        setHomeState()
        setNavigationBar()
    }

  override func viewDidAppear(_ animated: Bool) {
    self.startAnimate()
  }

    @IBAction private func testFaceId(_ sender: UIButton) {
        if authContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                         error: nil) {
            switch authContext.biometryType {
            case .faceID:
                message = "Face ID 인증해주세요."
            case .touchID :
                message = "Touch ID로 인증해주세요."
            case .none :
                message = ""
            @unknown default:
                message = ""
            }

            authContext
                .evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics,
                                localizedReason: message!) { (isSuccess, error) in
                    if isSuccess {
                        print("인증성공")
                    } else {
                        if let error = error {
                            print(error.localizedDescription) }
                    }
                }
        }
    }

    private func setNavigationBar() {
        navigationController?.navigationBar.prefersLargeTitles = false
        let logoImage = UIImage(named: "logo")
        navigationItem.titleView = UIImageView(image: logoImage)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
    }

    private func setLayout() {
        navigationController?.navigationBar.backgroundColor = UIColor(named: "naviBlack")

        journeyButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
        historyButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
        settingButton.layer.cornerRadius = ViewMetrics.buttonCornerRadius
    }

    private func setHomeState() {
        switch homeState {
        case .departure:
            busStopLabel.text = UserData.departure
            busNumberLabel.text = "No."
            journeyButton.isHidden = true
            backView.isHidden = false
        case .destionation:
            busStopLabel.text = UserData.destination
            busNumberLabel.text = "7 stops left"
            timeLabel.isHidden = true
            descriptionLabel.isHidden = true
            journeyButton.isHidden = true
            backView.isHidden = false
        default:
            journeyButton.isHidden = false
            backView.isHidden = true 
        }
    }

  private func animationLayoutSet() {
    self.view.addSubview(self.animateCircle)
    self.animateCircle.addSubview(self.firstAlertLabel)
    self.animateCircle.addSubview(self.secondAlertLabel)
    self.view.bringSubviewToFront(self.animateCircle)


//    self.firstAlertLabel.snp.makeConstraints{
//      $0.bottom.equalTo(self.animateCircle.snp.centerY)
//      $0.centerX.equalToSuperview()
//    }
//    self.secondAlertLabel.snp.makeConstraints{
//      $0.top.equalTo(self.animateCircle.snp.centerY)
//      $0.centerX.equalToSuperview()
//    }
  }
}

class CircleView: UIView {

    override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }

    private func updateCornerRadius() {
        layer.cornerRadius = min(bounds.width, bounds.height) / 2
    }

    override func action(for layer: CALayer, forKey event: String) -> CAAction? {
        if event == "cornerRadius" {
            if let boundsAnimation = layer.animation(forKey: "bounds.size") as? CABasicAnimation {
                let animation = boundsAnimation.copy() as! CABasicAnimation
                animation.keyPath = "cornerRadius"
                let action = Action()
                action.pendingAnimation = animation
                action.priorCornerRadius = layer.cornerRadius
                return action
            }
        }
        return super.action(for: layer, forKey: event)
    }

    private class Action: NSObject, CAAction {
        var pendingAnimation: CABasicAnimation?
        var priorCornerRadius: CGFloat = 0
        public func run(forKey event: String, object anObject: Any, arguments dict: [AnyHashable : Any]?) {
            if let layer = anObject as? CALayer, let pendingAnimation = pendingAnimation {
                if pendingAnimation.isAdditive {
                    pendingAnimation.fromValue = priorCornerRadius - layer.cornerRadius
                    pendingAnimation.toValue = 0
                } else {
                    pendingAnimation.fromValue = priorCornerRadius
                    pendingAnimation.toValue = layer.cornerRadius
                }
                layer.add(pendingAnimation, forKey: "cornerRadius")
            }
        }
    }
}
