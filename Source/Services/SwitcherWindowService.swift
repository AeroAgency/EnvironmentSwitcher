//
//  SwitcherWindowService.swift
//  EnvironmentSwitcher
//
//  Created by Stas on 18/06/2019.
//  Copyright © 2019 AERO. All rights reserved.
//

import UIKit

// MARK: - sizes
private enum SwitcherIconRects {
    private static let size = 48
    
    private static let yPosition: Int = {
        let margin = 4
        if #available(iOS 11.0, *) {
            guard let vc = SwitcherWindowService.shared().environmentSwitcherWindow.rootViewController as? SwitcherServerSelectController else {
                return margin
            }
            return Int(vc.view.safeAreaInsets.top / 2) + margin
        }
        return margin
    }()
    
    
    enum Margins {
        static let horizontalX = Int(UIScreen.main.bounds.width / 2) - Int(size / 2)
        static let verticalX = Int(UIScreen.main.bounds.height / 2) - Int(size / 2)
    }
    
    static let horizontal = CGRect(x: Margins.horizontalX, y: yPosition, width: size, height: size)
    static let vertical = CGRect(x: Margins.verticalX, y: yPosition, width: size, height: size)
}


// MARK: - container of UIWindow protocol and UIApplication extension
/// Protocol for main window container. Swither will displayed over main window and
/// replased main window on application start of this container.
/// -
/// By default using UIApplication with keyWindow or
public protocol MainWindowContaner {
    /// Main window of apllication
    var mainWindow: UIWindow? { get }
}

extension UIApplication: MainWindowContaner {
    public var mainWindow: UIWindow? {
        guard let window = delegate?.window else {
            return keyWindow ?? windows.last
        }
        return window
    }
}


// MARK: - service
class SwitcherWindowService {
    
    // MARK: variables
    private static let shared = SwitcherWindowService()
    private var application = UIApplication.shared as MainWindowContaner
    private var mainWindowRootVc: UIViewController?
    private var checkSubviewsFrontTimer: Timer?
    
    // MARK: lazy vars
    private lazy var mainWindow: UIWindow = {
        guard let window = application.mainWindow else {
            fatalError("Main window dont found on. All windows in current application:\n\(UIApplication.shared.windows)")
        }
        
        return window
    }()
    
    private(set) lazy var environmentSwitcherWindow: UIWindow = {
        let vc = SwitcherServerSelectController.fromNib()
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.windowLevel = .alert
        window.rootViewController = vc
        window.backgroundColor = .clear
        window.clipsToBounds = true
        
        return window
    }()
    
    private lazy var iconView: UIImageView = {
        let imgView = UIImageView(image: EnvironmentSwitcher.icon)
        imgView.frame = iconFrame()
        imgView.backgroundColor = .white
        imgView.isUserInteractionEnabled = true
        
        return imgView
    }()
    
    private lazy var showingIconView: UIView = {
        let view = UIView()
        view.frame = iconFrame()
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    // MARK: - life cicle and init
    private init() { }
    
    deinit {
        checkSubviewsFrontTimer?.invalidate()
        checkSubviewsFrontTimer = nil
    }
    
    static func shared(_ app: MainWindowContaner? = nil) -> SwitcherWindowService {
        if let appInstance = app {
            shared.attachToApp(appInstance)
        }
        return shared
    }
    
    private func attachToApp(_ app: MainWindowContaner) {
        application = app
        
        showingIconView.removeFromSuperview()
        iconView.removeFromSuperview()
        
        mainWindow.addSubview(showingIconView)
        mainWindow.addSubview(iconView)
        
        addDoubleTap()
        addLongTouch()
        
        initTimer()
        
        toggleIcon(true)
    }
    
    // MARK: selection manipulation
    func dispaySelectOnAppStartIfNeeded(_ isNeeded: Bool, currentServer: String) {
        guard isNeeded else {
            return
        }
        
        let appStartVc = AppStartRootController.fromNib()
        appStartVc.setCurrentServer(currentServer)
        mainWindowRootVc = mainWindow.rootViewController
        mainWindow.rootViewController = appStartVc
        environmentSwitcherWindow.isHidden = false
    }
    
    // MARK: timer
    /// TODO: this is hack for moving buttons to front every 3 seconds. Should find other solution, without timer and sometimes moving window to front
    private func initTimer() {
        guard checkSubviewsFrontTimer == nil else {
            return
        }
        
        checkSubviewsFrontTimer = Timer.scheduledTimer(withTimeInterval: 3.0, repeats: true, block: { _ in
            self.moveIconsToFront()
        })
    }
    
    
    // MARK: window manipulation
    func toggleSelectServerVc() {
        environmentSwitcherWindow.willMove(toWindow: mainWindow)
        environmentSwitcherWindow.isHidden = !environmentSwitcherWindow.isHidden
        toggleIcon(true)
        
        guard let vc = mainWindowRootVc else { //
            return
        }
        mainWindow.rootViewController = vc
        mainWindowRootVc = nil
        moveIconsToFront()
    }

    
    // MARK: icon manipulation
    func updatePositionIfNeeeded() {
        iconView.frame = iconFrame()
        showingIconView.frame = iconFrame()
    }
    
    private func iconFrame() -> CGRect {
        #if DEBUG
        print("vertical margin: \(SwitcherIconRects.Margins.verticalX)")
//        print("horizontal margin: \(SwitcherIconRects.Margins.horizontalX)")
//        print("-----")
        #endif
        
        var position = SwitcherIconRects.horizontal
        if UIDevice.current.orientation.isLandscape {
            position = SwitcherIconRects.vertical
        }
        return position
    }
    
    // swiftlint:disable discouraged_optional_boolean
    private func toggleIcon(_ specificState: Bool? = nil) {
    // swiftlint:enable discouraged_optional_boolean
        guard let state = specificState else {
            iconView.isHidden = !iconView.isHidden
            return
        }
        
        iconView.isHidden = state
    }
    
    private func moveIconsToFront() {
        mainWindow.bringSubviewToFront(showingIconView)
        mainWindow.bringSubviewToFront(iconView)
    }
}


// MARK: - taps manipulation extension
private extension SwitcherWindowService {
    private func doubleTapGesureRecognize() -> UITapGestureRecognizer {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(tapGesture))
        gesture.numberOfTapsRequired = 2
        return gesture
    }
    
    // MARK: add taps
    private func addDoubleTap() {
        showingIconView.addGestureRecognizer(doubleTapGesureRecognize())
        iconView.addGestureRecognizer(doubleTapGesureRecognize())
    }
    
    private func addLongTouch() {
        let longTap = UILongPressGestureRecognizer(target: self, action: #selector(longTapGesture))
        longTap.minimumPressDuration = 2
        iconView.addGestureRecognizer(longTap)
    }
    
    // MARK: taps actions
    @objc private func tapGesture(_ gesture: UITapGestureRecognizer) {
        toggleIcon()
    }
    
    @objc private func longTapGesture(_ gesture: UILongPressGestureRecognizer) {
        guard gesture.state == .began else {
            return
        }
        toggleSelectServerVc()
    }
}
