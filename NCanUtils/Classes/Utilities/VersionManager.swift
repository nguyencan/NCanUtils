//
//  VersionManager.swift
//  NCanUtils
//
//  Created by Nguyen Can on 4/29/20.
//  Copyright © 2020 Nguyen Can. All rights reserved.
//

#if canImport(Foundation) && canImport(UIKit) && os(iOS)
import Foundation
import UIKit

// MARK: - VersionManagerDelegate Protocol

public protocol VersionManagerDelegate: class {
    func versionDidShowUpdateDialog(alertType: VersionManagerAlertType)   // User presented with update dialog
    func versionUserDidLaunchAppStore()                          // User did click on button that launched App Store.app
    func versionUserDidSkipVersion()                             // User did click on button that skips version update
    func versionUserDidCancel()                                  // User did click on button that cancels update dialog
    func versionDidFailVersionCheck(error: NSError)              // VersionManager failed to perform version check (may return system-level error)
    func versionDidDetectNewVersionWithoutAlert(message: String) // VersionManager performed version check and did not display alert
    func versionLatestVersionInstalled()                         // VersionManager performed version check and latest version is installed
}

// MARK: - VersionManagerDelegate Protocol Extension

public extension VersionManagerDelegate {
    func versionDidShowUpdateDialog(alertType: VersionManagerAlertType) {}
    func versionUserDidLaunchAppStore() {}
    func versionUserDidSkipVersion() {}
    func versionUserDidCancel() {}
    func versionDidFailVersionCheck(error: NSError) {}
    func versionDidDetectNewVersionWithoutAlert(message: String) {}
    func versionLatestVersionInstalled() {}
}

/**
 Determines the type of alert to present after a successful version check has been performed.
 
 There are four options:
 
 - .Force: Forces user to update your app (1 button alert)
 - .Option: (DEFAULT) Presents user with option to update app now or at next launch (2 button alert)
 - .Skip: Presents user with option to update the app now, at next launch, or to skip this version all together (3 button alert)
 - .None: Doesn't show the alert, but instead returns a localized message for use in a custom UI within the versionDidDetectNewVersionWithoutAlert() delegate method
 
 */
public enum VersionManagerAlertType {
    case force        // Forces user to update your app (1 button alert)
    case option       // (DEFAULT) Presents user with option to update app now or at next launch (2 button alert)
    case skip         // Presents user with option to update the app now, at next launch, or to skip this version all together (3 button alert)
    case none         // Doesn't show the alert, but instead returns a localized message for use in a custom UI within the versionDidDetectNewVersionWithoutAlert() delegate method
}

/**
 Determines the frequency in which the the version check is performed
 
 - .Immediately: Version check performed every time the app is launched
 - .Daily: Version check performedonce a day
 - .Weekly: Version check performed once a week
 
 */
public enum VersionManagerVersionCheckType: Int {
    case immediately = 0    // Version check performed every time the app is launched
    case daily = 1          // Version check performed once a day
    case weekly = 7         // Version check performed once a week
}

/**
 VersionManager-specific Error Codes
 */
fileprivate enum VersionManagerErrorCode: Int {
    case malformedURL = 1000
    case recentlyCheckedAlready
    case noUpdateAvailable
    case appStoreDataRetrievalFailure
    case appStoreJSONParsingFailure
    case appStoreOSVersionNumberFailure
    case appStoreOSVersionUnsupported
    case appStoreVersionNumberFailure
    case appStoreVersionArrayFailure
    case appStoreAppIDFailure
}

/**
 VersionManager-specific Error Throwable Errors
 */
fileprivate enum VersionManagerError: Error {
    case malformedURL
    case missingBundleIdOrAppId
}

/**
 VersionManager-specific NSUserDefault Keys
 */
fileprivate enum VersionManagerUserDefaults: String {
    case StoredVersionCheckDate     // NSUserDefault key that stores the timestamp of the last version check
    case StoredSkippedVersion       // NSUserDefault key that stores the version that a user decided to skip
}


// MARK: - VersionManager

/**
 The VersionManager Class.
 
 A singleton that is initialized using the sharedInstance() method.
 */
public final class VersionManager: NSObject {
    
    static func setupCheckVersion(type: VersionManagerAlertType
        , countryCode: String = ""
        , debugEnabled: Bool = false
        , textColor: UIColor = .black
        , buttonColor: UIColor = .black) {
        
        let versionManager = VersionManager.shared
        versionManager.debugEnabled = debugEnabled
        versionManager.textColor = textColor
        versionManager.buttonColor = buttonColor
        versionManager.alertControllerTintColor = textColor
        versionManager.alertType = type
        versionManager.countryCode = countryCode
        versionManager.checkVersion(checkType: .immediately)
    }
    
    /**
     Current installed version of your app
     */
    fileprivate var currentInstalledVersion: String? = {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }()
    
    /**
     The error domain for all errors created by VersionManager
     */
    public let VersionManagerErrorDomain = "VersionManager Error Domain"
    
    /**
     The VersionManagerDelegate variable, which should be set if you'd like to be notified:
     
     - When a user views or interacts with the alert
     - versionDidShowUpdateDialog(alertType: VersionManagerAlertType)
     - versionUserDidLaunchAppStore()
     - versionUserDidSkipVersion()
     - versionUserDidCancel()
     - When a new version has been detected, and you would like to present a localized message in a custom UI
     - versionDidDetectNewVersionWithoutAlert(message: String)
     
     */
    public weak var delegate: VersionManagerDelegate?
    
    /**
     The debug flag, which is disabled by default.
     
     When enabled, a stream of println() statements are logged to your console when a version check is performed.
     */
    public lazy var debugEnabled = false
    
    /**
     Determines the type of alert that should be shown.
     
     See the VersionManagerAlertType enum for full details.
     */
    public var alertType = VersionManagerAlertType.option {
        didSet {
            majorUpdateAlertType = alertType
            minorUpdateAlertType = alertType
            patchUpdateAlertType = alertType
            revisionUpdateAlertType = alertType
        }
    }
    
    /**
     Determines the type of alert that should be shown for major version updates: A.b.c
     
     Defaults to VersionManagerAlertType.Option.
     
     See the VersionManagerAlertType enum for full details.
     */
    public lazy var majorUpdateAlertType = VersionManagerAlertType.option
    
    /**
     Determines the type of alert that should be shown for minor version updates: a.B.c
     
     Defaults to VersionManagerAlertType.Option.
     
     See the VersionManagerAlertType enum for full details.
     */
    public lazy var minorUpdateAlertType  = VersionManagerAlertType.option
    
    /**
     Determines the type of alert that should be shown for minor patch updates: a.b.C
     
     Defaults to VersionManagerAlertType.Option.
     
     See the VersionManagerAlertType enum for full details.
     */
    public lazy var patchUpdateAlertType = VersionManagerAlertType.option
    
    /**
     Determines the type of alert that should be shown for revision updates: a.b.c.D
     
     Defaults to VersionManagerAlertType.Option.
     
     See the VersionManagerAlertType enum for full details.
     */
    public lazy var revisionUpdateAlertType = VersionManagerAlertType.option
    
    // Optional Vars
    /**
     The name of your app.
     
     By default, it's set to the name of the app that's stored in your plist.
     */
    public lazy var appName: String = Bundle.main.bestMatchingAppName()
    
    /**
     The region or country of an App Store in which your app is available.
     
     By default, all version checks are performed against the US App Store.
     If your app is not available in the US App Store, you should set it to the identifier
     of at least one App Store within which it is available.
     */
    public var countryCode: String?
    
    public lazy var textColor: UIColor = .black
    public lazy var buttonColor: UIColor = .black
    
    /**
     Overrides the tint color for UIAlertController.
     */
    public var alertControllerTintColor: UIColor?
    
    /**
     When this is set, the alert will only show up if the current version has already been released for X days
     */
    public var showAlertAfterCurrentVersionHasBeenReleasedForDays: Int? = nil
    
    /**
     The current version of your app that is available for download on the App Store
     */
    public fileprivate(set) var currentAppStoreVersion: String?
    
    // fileprivate
    fileprivate var appID: Int?
    fileprivate var lastVersionCheckPerformedOnDate: Date?
    fileprivate var updaterWindow: UIWindow?
    
    // Initialization
    public static let shared = VersionManager()
    
    override init() {
        lastVersionCheckPerformedOnDate = UserDefaults.standard.object(forKey: VersionManagerUserDefaults.StoredVersionCheckDate.rawValue) as? Date
    }
    
    /**
     Checks the currently installed version of your app against the App Store.
     The default check is against the US App Store, but if your app is not listed in the US,
     you should set the `countryCode` property before calling this method. Please refer to the countryCode property for more information.
     
     - parameter checkType: The frequency in days in which you want a check to be performed. Please refer to the VersionManagerVersionCheckType enum for more details.
     */
    public func checkVersion(checkType: VersionManagerVersionCheckType) {
        
        guard let _ = Bundle.bundleID() else {
            printMessage(message: "Please make sure that you have set a `Bundle Identifier` in your project.")
            return
        }
        
        if checkType == .immediately {
            performVersionCheck()
        } else {
            guard let lastVersionCheckPerformedOnDate = lastVersionCheckPerformedOnDate else {
                performVersionCheck()
                return
            }
            
            if days(since: lastVersionCheckPerformedOnDate) >= checkType.rawValue {
                performVersionCheck()
            } else {
                postError(.recentlyCheckedAlready, underlyingError: nil)
            }
        }
    }
    
}

// MARK: - Helpers (Networking)

fileprivate extension VersionManager {
    
    func performVersionCheck() {
        
        // Create Request
        do {
            let url = try iTunesURLFromString()
            let request = URLRequest(url: url)
            
            // Perform Request
            let session = URLSession.shared
            let task = session.dataTask(with: request, completionHandler: { [unowned self] (data, response, error) in
                
                if let error = error {
                    self.postError(.appStoreDataRetrievalFailure, underlyingError: error)
                } else {
                    
                    guard let data = data else {
                        self.postError(.appStoreDataRetrievalFailure, underlyingError: nil)
                        return
                    }
                    
                    // Convert JSON data to Swift Dictionary of type [String: AnyObject]
                    do {
                        
                        let jsonData = try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.allowFragments)
                        
                        guard let appData = jsonData as? [String: AnyObject],
                            self.isUpdateCompatibleWithDeviceOS(appData: appData) else {
                                
                                self.postError(.appStoreJSONParsingFailure, underlyingError: nil)
                                return
                        }
                        
                        DispatchQueue.main.async {
                            
                            // Print iTunesLookup results from appData
                            self.printMessage(message: "JSON results: \(appData)")
                            
                            // Process Results (e.g., extract current version that is available on the AppStore)
                            self.processVersionCheck(withResults: appData)
                            
                        }
                        
                    } catch let error as NSError {
                        self.postError(.appStoreDataRetrievalFailure, underlyingError: error)
                    }
                }
                
                })
            
            task.resume()
            
        } catch let error as NSError {
            postError(.malformedURL, underlyingError: error)
        }
        
    }
    
    func processVersionCheck(withResults results: [String: AnyObject]) {
        
        // Store version comparison date
        storeVersionCheckDate()
        
        guard let allResults = results["results"] as? [[String: AnyObject]] else {
            self.postError(.appStoreVersionNumberFailure, underlyingError: nil)
            return
        }
        
        guard !allResults.isEmpty else {
            /**
             Conditional that avoids crash when app not in App Store
             */
            postError(.appStoreDataRetrievalFailure, underlyingError: nil)
            return
        }
        
        guard let appID = allResults.first?["trackId"] as? Int else {
            postError(.appStoreAppIDFailure, underlyingError: nil)
            return
        }
        
        self.appID = appID
        
        guard let currentAppStoreVersion = allResults.first?["version"] as? String else {
            self.postError(.appStoreVersionArrayFailure, underlyingError: nil)
            return
        }
        
        self.currentAppStoreVersion = currentAppStoreVersion
        
        guard isAppStoreVersionNewer() else {
            delegate?.versionLatestVersionInstalled()
            postError(.noUpdateAvailable, underlyingError: nil)
            return
        }
        
        guard let alertDays = showAlertAfterCurrentVersionHasBeenReleasedForDays else {
            showAlertIfCurrentAppStoreVersionNotSkipped()
            return
        }
        
        guard let currentVersionReleaseDate = allResults.first?["currentVersionReleaseDate"] as? String,
            let daysSinceRelease = days(since: currentVersionReleaseDate),
            daysSinceRelease >= alertDays else {
                return
        }
        
        showAlertIfCurrentAppStoreVersionNotSkipped()
        showAlertAfterCurrentVersionHasBeenReleasedForDays = nil
    }
    
    func iTunesURLFromString() throws -> URL {
        
        var components = URLComponents()
        components.scheme = "https"
        components.host = "itunes.apple.com"
        components.path = "/lookup"
        
        var items: [URLQueryItem] = [URLQueryItem(name: "bundleId", value: Bundle.bundleID())]
        
        if let countryCode = countryCode {
            let item = URLQueryItem(name: "country", value: countryCode)
            items.append(item)
        }
        
        components.queryItems = items
        
        guard let url = components.url, !url.absoluteString.isEmpty else {
            throw VersionManagerError.malformedURL
        }
        
        return url
    }
    
}


// MARK: - Helpers (Alert)

fileprivate extension VersionManager {
    
    func showAlertIfCurrentAppStoreVersionNotSkipped() {
        alertType = setAlertType()
        
        guard let previouslySkippedVersion = UserDefaults.standard.object(forKey: VersionManagerUserDefaults.StoredSkippedVersion.rawValue) as? String else {
            showAlert()
            return
        }
        
        if let currentAppStoreVersion = currentAppStoreVersion, currentAppStoreVersion != previouslySkippedVersion {
            showAlert()
        }
    }
    
    func showAlert() {
        let strAlertTitle = NSLocalizedString("version_update_title", comment: "Update Available")
        let strAlertMessage = localizedNewVersionMessage()
        
        let alertView = UpdateAlertView()
        alertView.setContent(title: strAlertTitle, message: strAlertMessage)
        switch alertType {
        case .force:
            alertView.addActionWithTitle(localizedUpdateButtonTitle(), action: {
                self.launchAppStore()
                self.delegate?.versionUserDidLaunchAppStore()
            })
        case .option:
            alertView.addActionWithTitle(localizedNextTimeButtonTitle(), action: {
                self.delegate?.versionUserDidCancel()
            })
            alertView.addActionWithTitle(localizedUpdateButtonTitle(), action: {
                self.launchAppStore()
                self.delegate?.versionUserDidLaunchAppStore()
            })
        case .skip:
            alertView.addActionWithTitle(localizedNextTimeButtonTitle(), action: {
                self.delegate?.versionUserDidCancel()
            })
            alertView.addActionWithTitle(localizedSkipButtonTitle(), action: {
                if let currentAppStoreVersion = self.currentAppStoreVersion {
                    UserDefaults.standard.set(currentAppStoreVersion, forKey: VersionManagerUserDefaults.StoredSkippedVersion.rawValue)
                    UserDefaults.standard.synchronize()
                }
                
                self.hideWindow()
                self.delegate?.versionUserDidSkipVersion()
            })
            alertView.addActionWithTitle(localizedUpdateButtonTitle(), action: {
                self.launchAppStore()
                self.delegate?.versionUserDidLaunchAppStore()
            })
        case .none:
            delegate?.versionDidDetectNewVersionWithoutAlert(message: strAlertMessage)
        }
        
        if alertType != .none {
            alertView.show()
            delegate?.versionDidShowUpdateDialog(alertType: alertType)
        }
    }
    
    func setAlertType() -> VersionManagerAlertType {
        
        guard let currentInstalledVersion = currentInstalledVersion,
            let currentAppStoreVersion = currentAppStoreVersion else {
                return .option
        }
        
        let oldVersion = (currentInstalledVersion).split {$0 == "."}.map { String($0) }.map {Int($0) ?? 0}
        let newVersion = (currentAppStoreVersion).split {$0 == "."}.map { String($0) }.map {Int($0) ?? 0}
        
        guard let newVersionFirst = newVersion.first, let oldVersionFirst = oldVersion.first else {
            return alertType // Default value is .Option
        }
        
        if newVersionFirst > oldVersionFirst { // A.b.c.d
            alertType = majorUpdateAlertType
        } else if newVersion.count > 1 && (oldVersion.count <= 1 || newVersion[1] > oldVersion[1]) { // a.B.c.d
            alertType = minorUpdateAlertType
        } else if newVersion.count > 2 && (oldVersion.count <= 2 || newVersion[2] > oldVersion[2]) { // a.b.C.d
            alertType = patchUpdateAlertType
        } else if newVersion.count > 3 && (oldVersion.count <= 3 || newVersion[3] > oldVersion[3]) { // a.b.c.D
            alertType = revisionUpdateAlertType
        }
        
        return alertType
    }
}


// MARK: - Helpers (Localization)

fileprivate extension VersionManager {
    
    func localizedNewVersionMessage() -> String {
        let newVersionMessage = NSLocalizedString("version_update_message", comment: "")
        
        guard let currentAppStoreVersion = currentAppStoreVersion else {
            return NSLocalizedString("version_update_message_unknow", comment: "")
        }
        
        return String(format: newVersionMessage, currentAppStoreVersion)
    }
    
    func localizedUpdateButtonTitle() -> String {
        return NSLocalizedString("version_btn_update", comment: "Update")
    }
    
    func localizedNextTimeButtonTitle() -> String {
        return NSLocalizedString("version_btn_next", comment: "Next Time")
    }
    
    func localizedSkipButtonTitle() -> String {
        return NSLocalizedString("version_btn_skip", comment: "Skip this version")
    }
}


// MARK: - Helpers (Version)

fileprivate extension VersionManager {
    
    func isAppStoreVersionNewer() -> Bool {
        
        var newVersionExists = false
        
        if let currentInstalledVersion = currentInstalledVersion,
            let currentAppStoreVersion = currentAppStoreVersion,
            (currentInstalledVersion.compare(currentAppStoreVersion, options: .numeric) == .orderedAscending) {
            
            newVersionExists = true
        }
        
        return newVersionExists
    }
    
    func storeVersionCheckDate() {
        lastVersionCheckPerformedOnDate = Date()
        if let lastVersionCheckPerformedOnDate = lastVersionCheckPerformedOnDate {
            UserDefaults.standard.set(lastVersionCheckPerformedOnDate, forKey: VersionManagerUserDefaults.StoredVersionCheckDate.rawValue)
            UserDefaults.standard.synchronize()
        }
    }
    
}

// MARK: - Helpers (Date)

fileprivate extension VersionManager {
    
    static func setupDateFormatter() -> DateFormatter {
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        return dateformatter
    }
    
    func days(since date: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: date, to: Date())
        return components.day!
    }
    
    func days(since dateString: String) -> Int? {
        let dateformatter = VersionManager.setupDateFormatter()
        guard let releaseDate = dateformatter.date(from: dateString) else { return nil }
        return days(since: releaseDate)
    }
}

// MARK: - Helpers (Misc.)

fileprivate extension VersionManager {
    
    func isUpdateCompatibleWithDeviceOS(appData: [String: AnyObject]) -> Bool {
        
        guard let results = appData["results"] as? [[String: AnyObject]],
            let requiredOSVersion = results.first?["minimumOsVersion"] as? String else {
                postError(.appStoreOSVersionNumberFailure, underlyingError: nil)
                return false
        }
        
        let systemVersion = UIDevice.current.systemVersion
        
        if systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedDescending ||
            systemVersion.compare(requiredOSVersion, options: .numeric) == .orderedSame {
            return true
        } else {
            postError(.appStoreOSVersionUnsupported, underlyingError: nil)
            return false
        }
        
    }
    
    func hideWindow() {
        if let updaterWindow = updaterWindow {
            updaterWindow.isHidden = true
            self.updaterWindow = nil
        }
    }
    
    func launchAppStore() {
        guard let appID = appID else {
            return
        }
        
        let iTunesString =  "https://itunes.apple.com/app/id\(appID)"
        DispatchQueue.main.async {
            iTunesString.open(type: .website)
        }
        
    }
    
    func printMessage(message: String) {
        if debugEnabled {
            print("[VersionManager] \(message)")
        }
    }
    
}

// MARK: - NSBundle Extension

fileprivate extension Bundle {
    
    class func bundleID() -> String? {
        return Bundle.main.bundleIdentifier
    }
    
    func bestMatchingAppName() -> String {
        let bundleDisplayName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String
        let bundleName = Bundle.main.object(forInfoDictionaryKey: kCFBundleNameKey as String) as? String
        
        return bundleDisplayName ?? bundleName ?? ""
    }
    
}


// MARK: - Error Handling

fileprivate extension VersionManager {
    
    func postError(_ code: VersionManagerErrorCode, underlyingError: Error?) {
        
        let description: String
        
        switch code {
        case .malformedURL:
            description = "The iTunes URL is malformed. Please leave an issue on http://github.com/ArtSabintsev/VersionManager with as many details as possible."
        case .recentlyCheckedAlready:
            description = "Not checking the version, because it already checked recently."
        case .noUpdateAvailable:
            description = "No new update available."
        case .appStoreDataRetrievalFailure:
            description = "Error retrieving App Store data as an error was returned."
        case .appStoreJSONParsingFailure:
            description = "Error parsing App Store JSON data."
        case .appStoreOSVersionNumberFailure:
            description = "Error retrieving iOS version number as there was no data returned."
        case .appStoreOSVersionUnsupported:
            description = "The version of iOS on the device is lower than that of the one required by the app verison update."
        case .appStoreVersionNumberFailure:
            description = "Error retrieving App Store version number as there was no data returned."
        case .appStoreVersionArrayFailure:
            description = "Error retrieving App Store verson number as results.first does not contain a 'version' key."
        case .appStoreAppIDFailure:
            description = "Error retrieving trackId as results.first does not contain a 'trackId' key."
        }
        
        var userInfo: [String: Any] = [NSLocalizedDescriptionKey: description]
        
        if let underlyingError = underlyingError {
            userInfo[NSUnderlyingErrorKey] = underlyingError
        }
        
        let error = NSError(domain: VersionManagerErrorDomain, code: code.rawValue, userInfo: userInfo)
        
        delegate?.versionDidFailVersionCheck(error: error)
        
        printMessage(message: error.localizedDescription)
    }
    
}

// MARK: - Helpers (Testing Target)

extension VersionManager {
    
    func testSetCurrentInstalledVersion(version: String) {
        currentInstalledVersion = version
    }
    
    func testSetAppStoreVersion(version: String) {
        currentAppStoreVersion = version
    }
    
    func testIsAppStoreVersionNewer() -> Bool {
        return isAppStoreVersionNewer()
    }
    
}

// MARK: - Update Version Alert View

typealias DismissBlock = () -> Void

// Action Types
enum MActionType {
    case none, selector, closure
}

// Button sub-class
class MButton: UIButton {
    var actionType: MActionType = .none
    var target: AnyObject!
    var selector: Selector!
    var action: (() -> Void)?
    var customBackgroundColor: UIColor?
    var customTextColor: UIColor?
    var initialTitle: String!
    var showDurationStatus: Bool = false
    
    override open var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                imageView?.alpha = 0.5
                titleLabel?.alpha = 0.5
            } else{
                imageView?.alpha = 1.0
                titleLabel?.alpha = 1.0
            }
        }
    }
    
    public init() {
        super.init(frame: CGRect.zero)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    override public init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    func callAction() {
        if self.actionType == .closure {
            self.action?()
        } else if self.actionType == .selector {
            let ctrl = UIControl()
            ctrl.sendAction(self.selector, to: self.target, for: nil)
        } else {
            // Nothing to do
        }
    }
}

fileprivate class UpdateAlertView: UIViewController {
    
    public struct MAppearance {
        
        let kSpaceWindowVertical: CGFloat
        let kSpaceWindowHorizontal: CGFloat
        
        let kSpaceContentVertical: CGFloat
        let kSpaceContentHorizontal: CGFloat
        
        let kButtonHeight: CGFloat
        let kButtonSpacing: CGFloat
        
        // Fonts
        let kTitleFont: UIFont
        let kTextFont: UIFont
        let kButtonFont: UIFont
        
        init() {
            self.kSpaceWindowVertical = 20.0
            self.kSpaceWindowHorizontal = 20.0
            
            self.kSpaceContentVertical = 30.0
            self.kSpaceContentHorizontal = 12.0
            
            self.kButtonSpacing = 1.0
            self.kButtonHeight = 50.0
            
            self.kTitleFont = UIFont.boldSystemFont(ofSize: 20)
            self.kTextFont = UIFont.systemFont(ofSize: 15)
            self.kButtonFont = UIFont.boldSystemFont(ofSize: 18)
        }
    }
    
    var appearance: MAppearance!
    
    var baseView = UIView()
    var contentContainer = UIView()
    var labelTitle = UILabel()
    var labelMessage = UILabel()
    var buttonsContainer = UIView()
    var buttons = [MButton]()
    
    var dismissBlock : DismissBlock?
    
    public init(appearance: MAppearance) {
        self.appearance = appearance
        super.init(nibName:nil, bundle:nil)
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    required public init() {
        appearance = MAppearance()
        super.init(nibName:nil, bundle:nil)
        setup()
    }
    
    override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        appearance = MAppearance()
        super.init(nibName:nibNameOrNil, bundle:nibBundleOrNil)
        setup()
    }
    
    fileprivate func setup() {
        view.frame = UIScreen.main.bounds
        view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        view.addSubview(baseView)
        
        // Base View (Background View)
        var baseFrame = view.frame
        baseFrame.size.width -= (appearance.kSpaceWindowHorizontal*2)
        baseFrame.size.height -= (appearance.kSpaceWindowVertical*2)
        baseView.frame = baseFrame
        baseView.backgroundColor = .white
        baseView.applyStyle()
        
        let titleDefaultHeight = CGFloat(50)
        // Title View
        labelTitle.numberOfLines = 0
        labelTitle.textColor = VersionManager.shared.textColor
        labelTitle.backgroundColor = .clear
        labelTitle.textAlignment = .center
        labelTitle.font = appearance.kTitleFont
        labelTitle.frame = CGRect(x: appearance.kSpaceContentHorizontal, y: appearance.kSpaceContentVertical, width: baseFrame.size.width - (appearance.kSpaceContentHorizontal*2), height: titleDefaultHeight)
        
        // Message View
        labelMessage.numberOfLines = 0
        labelMessage.textColor = VersionManager.shared.textColor
        labelMessage.backgroundColor = .clear
        labelMessage.textAlignment = .center
        labelMessage.font = appearance.kTextFont
        labelMessage.frame = CGRect(x: appearance.kSpaceContentHorizontal, y: appearance.kSpaceContentVertical + titleDefaultHeight, width: baseFrame.size.width - (appearance.kSpaceContentHorizontal*2), height: titleDefaultHeight)
        
        contentContainer.frame = CGRect(x: 0, y: 0, width: baseFrame.size.width, height: 2*titleDefaultHeight)
        contentContainer.backgroundColor = .white
        
        contentContainer.addSubview(labelTitle)
        contentContainer.addSubview(labelMessage)
        
        baseView.addSubview(contentContainer)
        
        let yContainer = baseView.frame.size.height - (appearance.kButtonHeight + appearance.kButtonSpacing)
        let containerFrame = CGRect(x: 0.0, y: yContainer, width: baseFrame.size.width, height: appearance.kButtonHeight + appearance.kButtonSpacing)
        buttonsContainer.frame = containerFrame
        buttonsContainer.backgroundColor = .clear
        
        baseView.addSubview(buttonsContainer)
    }
    
    override open func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        let sz: CGSize
        if let rv = UIApplication.getWindow() {
            sz = rv.frame.size
        } else {
            sz = UIScreen.main.bounds.size
        }
        
        // Set background frame
        view.frame.size = sz
        
        var baseFrame = baseView.frame
        baseFrame.size.width = sz.width - (appearance.kSpaceWindowHorizontal*2)
        baseFrame.origin.x = appearance.kSpaceWindowVertical
        
        var consumedHeight = CGFloat(0)
        
        // Calculate height of title
        var titleHeight = CGFloat(0)
        let titleWidth = baseFrame.size.width - (appearance.kSpaceContentHorizontal*2)
        let mssgY: CGFloat
        if let title = labelTitle.text {
            titleHeight = heightForView(text: title, font: appearance.kTitleFont, width: titleWidth)
            
            labelTitle.frame = CGRect(x: appearance.kSpaceContentHorizontal, y: appearance.kSpaceContentVertical, width: titleWidth, height: titleHeight)
            labelTitle.alpha = 1.0
            
            mssgY = titleHeight + (appearance.kSpaceContentVertical*2)
        } else {
            labelTitle.frame = CGRect(x: appearance.kSpaceContentHorizontal, y: 0.0, width: titleWidth, height: 0.0)
            labelTitle.alpha = 0.0
            
            mssgY = appearance.kSpaceContentVertical
        }
        consumedHeight += mssgY
        
        // Calculate height of message
        var mssgHeight = CGFloat(0)
        let mssgWidth = baseFrame.size.width - (appearance.kSpaceContentHorizontal*2)
        if let message = labelMessage.text {
            mssgHeight = heightForView(text: message, font: appearance.kTextFont, width: mssgWidth)
            
            labelMessage.frame = CGRect(x: appearance.kSpaceContentHorizontal, y: mssgY, width: mssgWidth, height: mssgHeight)
            labelTitle.alpha = 1.0
            
            consumedHeight += mssgHeight + appearance.kSpaceContentVertical
        } else {
            labelMessage.frame = CGRect(x: appearance.kSpaceContentHorizontal, y: mssgY, width: mssgWidth, height: 0.0)
            labelTitle.alpha = 0.0
            
            consumedHeight += appearance.kSpaceContentVertical
        }
        var contentContainerFrame = contentContainer.frame
        contentContainerFrame.size.height = consumedHeight
        contentContainer.frame = contentContainerFrame
        
        var btnContainerHeight = CGFloat(0)
        if buttons.count == 2 {
            let width1 = widthForView(text: buttons[0].title(for: .normal), font: appearance.kButtonFont)
            let width2 = widthForView(text: buttons[1].title(for: .normal), font: appearance.kButtonFont)
            let btnWidth = (baseFrame.size.width - appearance.kButtonSpacing)/2
            if width1 < btnWidth && width2 < btnWidth {
                buttons[0].frame = CGRect(x: 0.0, y: appearance.kButtonSpacing, width: btnWidth, height: appearance.kButtonHeight)
                buttons[1].frame = CGRect(x: btnWidth + appearance.kButtonSpacing, y: appearance.kButtonSpacing, width: btnWidth, height: appearance.kButtonHeight)
                
                btnContainerHeight += appearance.kButtonSpacing + appearance.kButtonHeight
            } else {
                let btnWidth = baseFrame.size.width
                for btn in buttons {
                    let btnY = btnContainerHeight + appearance.kButtonSpacing
                    btn.frame = CGRect(x: 0.0, y: btnY, width: btnWidth, height: appearance.kButtonHeight)
                    
                    btnContainerHeight += (appearance.kButtonSpacing + appearance.kButtonHeight)
                }
            }
        } else {
            let btnWidth = baseFrame.size.width
            for btn in buttons {
                let btnY = btnContainerHeight + appearance.kButtonSpacing
                btn.frame = CGRect(x: 0.0, y: btnY, width: btnWidth, height: appearance.kButtonHeight)
                
                btnContainerHeight += (appearance.kButtonSpacing + appearance.kButtonHeight)
            }
        }
        let containerFrame = CGRect(x: 0.0, y: consumedHeight, width: baseFrame.size.width, height: btnContainerHeight)
        buttonsContainer.frame = containerFrame
        
        consumedHeight += btnContainerHeight
        
        // set frame for base view
        baseFrame.origin.y = (sz.height - consumedHeight)/2
        baseFrame.size.height = consumedHeight
        baseView.frame = baseFrame
    }
    
    fileprivate func widthForView(text: String?, font: UIFont) -> CGFloat {
        
        if let textToEvaluate = text {
            let sizeOfText = textToEvaluate.size(withAttributes: [.font: font])
            return sizeOfText.width
        } else {
            return 0.0
        }
    }
    
    fileprivate func heightForView(text:String, font: UIFont, width: CGFloat) -> CGFloat {
        let label:UILabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: width, height: .greatestFiniteMagnitude))
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    open func setContent(title: String?, message: String?) {
        labelTitle.text = title
        labelMessage.text = message
    }
    
    open func addActionWithTitle(_ title: String, action: @escaping ()->Void) {
        let button = MButton()
        button.setTitle(title, for: .normal)
        button.setTitleColor(VersionManager.shared.buttonColor, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = appearance.kButtonFont
        button.actionType = .closure
        button.action = action
        button.addTarget(self, action:#selector(buttonTapped(_:)), for:.touchUpInside)
        
        buttons.append(button)
        buttonsContainer.addSubview(button)
    }
    
    // showTitle(view, title, subTitle, duration, style)
    open func show() {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = self
        window.windowLevel = UIWindow.Level.alert + 1
        
        VersionManager.shared.updaterWindow = window
        
        window.makeKeyAndVisible()
    }
    
    @objc func buttonTapped(_ btn: MButton) {
        btn.callAction()
        // Hide popup view
        if let view = self.view, view.alpha > 0 {
            VersionManager.shared.hideWindow()
        }
    }
}

private extension UIView {
    
    func applyStyle(corners: UIRectCorner? = nil, radius: CGFloat = 5.0, border: (width: CGFloat, color: UIColor)? = nil) {
        if radius > 0 {
            self.layer.masksToBounds = true
        }
        if let corners = corners {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.lineWidth = 1.0
            mask.strokeColor = UIColor.black.cgColor
            mask.path = path.cgPath
            self.layer.mask = mask
            self.layer.cornerRadius = 0
        } else {
            self.layer.cornerRadius = radius
            self.layer.mask = nil
        }
        if let border = border {
            self.layer.borderColor = border.color.cgColor
            self.layer.borderWidth = border.width
        }
    }
}

#endif
