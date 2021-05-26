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
    circle.frame = CGRect(x: centerX , y: centerY, width: 0, height: 0)
    circle.layer.backgroundColor = UIColor.red.cgColor

    circle.layer.cornerRadius = 50
    circle.layer.shadowOpacity = 0.5
    circle.layer.shadowRadius = 7
    circle.layer.masksToBounds = true
    return circle
  }()
  private var firstAlertLabel: UILabel = {
    let label = UILabel()
    label.font = .boldSystemFont(ofSize: 38)
    label.textColor = UIColor(named: "backgroundBlack")
    return label
  }()
  private var secondAlertLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 40, weight: .black)
    label.textColor = UIColor(named: "backgroundBlack")
    return label
  }()
  private var backgroundBlackView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(named: "backgroundBlack")
    return view
  }()


  // MARK: Properties

  private lazy var viewCenter: CGPoint = self.view.center
  private lazy var firstFrame = self.animateCircle.frame.insetBy(dx: -700, dy: -700)
  private lazy var secondFrame = self.animateCircle.frame.insetBy(dx: 700, dy: 700)
  var homeState = HomeState(rawValue: UserData.homeState ?? "first")

  var steps: [Step] = []
  var stepCount: Int = 0
  var timer: Timer = Timer()
  var arriveTimeCount: Int = 10 {
    didSet {
      if arriveTimeCount == 0 {
        self.timer.invalidate()
        self.isRecievedEvent = .isArrived
        self.timeLabel.text = "Arrived"
      }
    }
  }


  var isRecievedEvent: AlertAnimation = .none
  {
    didSet {
      switch isRecievedEvent {
      case .none:
        return
      case .payment:
        self.colorFrameChange(UIColor(named: "AlertColorYellow"), text1: "Done") {
          self.firstAlertLabel.accessibilityLabel = "Your payment has been completed. Bus number 360 will arrive at Jamsil station in 20 seconds."
        }
      case .isArrived:
        self.colorFrameChange(UIColor(named: "mainGreen"), text1: "Arrived No. 350", text2: "No. 360") { self.timeLabel.text = "Arrived"
          self.firstAlertLabel.accessibilityLabel = "You have arrived at the destination stop. Now, get off the bus."
        }
      case .isOnBoard:
        self.colorFrameChange(UIColor(named: "AlertColorYellow"), text1: "You'r in", text2: "No. 360") {

        }
      case .curveSoon:
        self.colorFrameChange(UIColor(named: "AlertColorRed"), text1: "caution", text2: "Big Curve")
        self.firstAlertLabel.accessibilityLabel = "It's a curve after 10 seconds. Be careful."
      case .afterOneStation:
        self.colorFrameChange(UIColor(named: "mainGreen"), text1: "After", text2: "1 Station") {
          self.firstAlertLabel.accessibilityLabel = "Get off after one stop. Please get ready to get off."
        }
      case .getOffNow:
        self.colorFrameChange(UIColor(named: "mainGreen"), text1: "Get off", text2: "now") {
        }
      case .completeTheJourney:
        self.colorFrameChange(UIColor(named: "AlertColorYellow"), text1: "Complete", text2: "the Journey"){
          self.firstAlertLabel.accessibilityLabel = "You have arrived at your final destination. Thank you for using the service, see you on the next journey!"
        }
      }
    }
  }
  private let duration: Double = 0.7
  private var stations: [String] = []
  private var busNumbers: [String] = []
  var count = 0


  // MARK: Functions

  private func colorFrameChange(_ color: UIColor?, text1: String, text2: String? = nil, completion: (() -> Void)? = nil) {
    DispatchQueue.main.async {
      self.animateCircle.backgroundColor = color
      self.backgroundBlackView.isHidden = false
      self.backgroundBlackView.alpha = 1
      self.firstAlertLabel.text = text1
      self.secondAlertLabel.text = text2
      self.firstAlertLabel.isHidden = false
      self.secondAlertLabel.isHidden = false
      UIView.animate(withDuration: self.duration, animations: {
        self.animateCircle.frame = self.firstFrame
      }) { _ in
        UIView.animate(withDuration: 2, animations: {
          self.animateCircle.frame = self.secondFrame
        }) { _ in
          UIView.animate(withDuration: 0.3, animations: {
            self.firstAlertLabel.isHidden = true
            self.secondAlertLabel.isHidden = true
            self.backgroundBlackView.alpha = 0
          }) { _ in
            self.backgroundBlackView.alpha = 1
            self.backgroundBlackView.isHidden = true
          }
        }
      }
    }
  }

  private func startAnimate() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
      self.isRecievedEvent = .completeTheJourney
    }
  }

  private enum ViewMetrics {
    static let buttonCornerRadius: CGFloat = 20
  }

  enum HomeState: String {
        case first
        case departure
        case destionation
  }

  private func runTimer() {
    self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.updateTimer), userInfo: nil, repeats: true)

    RunLoop.current.add(timer, forMode: .common)
  }

  @objc private func updateTimer() {
    self.arriveTimeCount -= 1
    self.timeLabel.text = "도착까지 0:0\(arriveTimeCount)"
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    self.setLayout()
    self.animationLayoutSet()
  }

    override func viewWillAppear(_ animated: Bool) {
        setHomeState()
        setNavigationBar()
//      self.showAnimation()
    }


  private func showAnimation() {
    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
      self.isRecievedEvent = .payment
      DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
        self.isRecievedEvent = .isArrived
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
          self.isRecievedEvent = .isOnBoard
          DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.isRecievedEvent = .curveSoon
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
              self.isRecievedEvent = .afterOneStation
              DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                self.isRecievedEvent = .getOffNow
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                  self.isRecievedEvent = .completeTheJourney
                }
              }
            }
          }
        }
      }
    }
  }

  private func animator() {
    for i in 0...6 {
      self.isRecievedEvent = AlertAnimation(rawValue: i)!
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
          let busTypes = self.steps.filter{ $0.type == "BUS" }
          for i in 0..<busTypes.count {
            for j in busTypes[i].stations {
              self.stations.append(j.name)
            }
          }

          for i in 0..<busTypes.count {
            for j in busTypes[i].routes {
              self.busNumbers.append(j.name)
            }
          }

          busStopLabel.text = self.stations[stepCount]
          busNumberLabel.text = self.busNumbers[stepCount]
          self.runTimer()
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
    self.view.addSubview(self.backgroundBlackView)
    self.view.bringSubviewToFront(self.backgroundBlackView)
    self.view.addSubview(self.animateCircle)
    self.view.bringSubviewToFront(self.animateCircle)
    self.view.addSubview(self.firstAlertLabel)
    self.view.addSubview(self.secondAlertLabel)

    self.backgroundBlackView.isHidden = true
    self.firstAlertLabel.isHidden = true
    self.secondAlertLabel.isHidden = true

    self.backgroundBlackView.snp.makeConstraints{
      $0.edges.equalToSuperview()
    }
    self.firstAlertLabel.snp.makeConstraints{
      $0.centerY.equalToSuperview().inset(200)
      $0.centerX.equalToSuperview()
    }
    self.secondAlertLabel.snp.makeConstraints{
      $0.centerX.equalToSuperview()
      $0.top.equalTo(self.firstAlertLabel.snp.bottom).offset(30)
    }
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
