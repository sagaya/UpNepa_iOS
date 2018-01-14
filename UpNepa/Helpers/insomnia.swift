
//
import UIKit

/**
 Insomnia modes:
 
 - `disabled`: Nothing will change (disabled functionality).
 - `always`: Your iOS device will never timeout and lock.
 - `whenCharging`: Device will stay active as long as it's connected to charger.
 */
public enum InsomniaMode {
    /**
     Nothing will change (disabled functionality).
     */
    case disabled
    /**
     Your iOS device will never timeout and lock.
     */
    case always
    /**
     Device will stay active as long as it's connected to charger.
     */
    case whenCharging
}

/**
 This protocol describes ability to set `batteryStateHandler` and be notified about battery state changes.
 */
public protocol BatteryStateReporting: class {
    /**
     You can set this closure to be notified when your device is being plugged/unplugged from charger.
     */
    var batteryStateHandler: ((_ isPlugged: Bool) -> Void)? { get set }
}

public protocol InsomniaModeHaving {
    /**
     This mode will change the behavior:
     - `disabled`: Nothing will change (disabled functionality).
     - `always`: Your iOS device will never timeout and lock.
     - `whenCharging`: Device will stay active as long as it's connected to charger.
     */
    var mode: InsomniaMode { get set }
}

/**
 Sometimes you want your iPhone to stay active a little bit longer is it an import or just game interface.
 This simple class aims to simplify the code and give you a well tested solution.
 
 Main functionalities:
 * always prevent iOS device from timeout and lock
 * prevent only when charging
 * notify about battery state (`isPlugged`)
 */
public final class Insomnia: BatteryStateReporting, InsomniaModeHaving {
    
    /**
     This mode will change the behavior:
     
     - `disabled`: Nothing will change (disabled functionality).
     - `always`: Your iOS device will never timeout and lock.
     - `whenCharging`: Device will stay active as long as it's connected to charger.
     */
    public var mode: InsomniaMode {
        didSet {
            updateInsomniaMode()
        }
    }
    
    /**
     You can set this closure to be notified when your device is being plugged/unplugged from charger.
     */
    public var batteryStateHandler: ((_ isPlugged: Bool) -> Void)? {
        didSet {
            notifyAboutCurrentBatteryState()
        }
    }
    
    private unowned let device: UIDevice
    private unowned let notificationCenter: NotificationCenter
    private unowned let application: UIApplication
    
    /**
     Initializes a new Insomnia instance.
     - parameters:
     - mode: Mode determines behaviour (see InsomniaMode enum).
     - device: UIDevice
     - notificationCenter: NotificationCenter
     - application: UIApplication
     */
    public init(mode: InsomniaMode,
                device: UIDevice = UIDevice.current,
                notificationCenter: NotificationCenter = NotificationCenter.default,
                application: UIApplication = UIApplication.shared) {
        self.device = device
        self.mode = mode
        self.notificationCenter = notificationCenter
        self.application = application
        startMonitoring()
    }
    
    private func startMonitoring() {
        device.isBatteryMonitoringEnabled = true
        notificationCenter.addObserver(self,
                                       selector: #selector(batteryStateDidChange),
                                       name: NSNotification.Name.UIDeviceBatteryStateDidChange, object: nil)
        updateInsomniaMode()
    }
    
    @objc private func batteryStateDidChange(notification: NSNotification){
        updateInsomniaMode()
    }
    
    private func updateInsomniaMode() {
        notifyAboutCurrentBatteryState()
        application.isIdleTimerDisabled = mode == .whenCharging ? isPlugged : (mode != .disabled)
    }
    
    private func notifyAboutCurrentBatteryState() {
        batteryStateHandler?(isPlugged)
    }
    
    private var isPlugged: Bool {
        switch device.batteryState {
        case .unknown, .unplugged:
            return false
        default:
            return true
        }
    }
    
    deinit {
        notificationCenter.removeObserver(self)
        device.isBatteryMonitoringEnabled = false
        application.isIdleTimerDisabled = false
    }
}
