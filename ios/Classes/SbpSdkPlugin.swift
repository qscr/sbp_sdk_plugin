import Flutter
import UIKit
import SBPWidget

public class SbpSdkPlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "sbp_sdk_plugin", binaryMessenger: registrar.messenger())
    let instance = SbpSdkPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "init":
        if #available(iOS 14.0, *) {
            result(true)
        } else {
            result(false)
        }
    case "showModal":
        let url = call.arguments as! String
        if #unavailable(iOS 14.0) {
            result(FlutterError(code: "iOSSdkVersionTooSmall", message: "Слишком низкая версия SDK для iOS", details: nil))
            return
        } else {
            do {
                guard let rootController = UIApplication.shared.delegate?.window??.rootViewController else {
                    result(FlutterError(code: "RootViewControllerNotFound", message: "Не найден рутовый ViewController для отображения модального окна", details: nil))
                    return
                }
                try SBPWidgetSDK.shared.presentBankListViewController(paymentURL: url, parentViewController: rootController)
            } catch SBPWidgetError.presentationFailed {
                result(FlutterError(code: "PresentationFailed", message: "Parent view controller for modal presentation not found", details: nil))
            } catch SBPWidgetError.loadingFaild {
                result(FlutterError(code: "LoadingFaild", message: "Can't load bank list", details: nil))
            } catch SBPWidgetError.invalidURLString {
                result(FlutterError(code: "InvalidURLString", message: "Can't parse parameters from received url", details: nil))
            } catch {
                result(FlutterError(code: "UnhandledException", message: "Произошла непредвиденная ошибка", details: nil))
            }
        }
    case "getBankList":
        let url = call.arguments as! String
        do {
            try SBPWidgetBank.fetchAll(paymentURL: url, receivOn: .main) { response in
                if case .success(let banks) = response {
                    let codableBanks = banks.map { bank in
                        return SBPWidgetBankWrapper(name: bank.name, logoURL: bank.logoURL, dboLink: bank.dboLink)
                    }
                    let jsonEncoder = JSONEncoder()
                    do {
                        let jsonData = try jsonEncoder.encode(codableBanks)
                        let json = String(data: jsonData, encoding: String.Encoding.utf8)
                        result(json)
                    } catch {
                        result(FlutterError(code: "InvalidJSONConversion", message: "Не удалось сериализовать в JSON", details: nil))
                    }
                }
                if case .failure(let error) = response {
                    result(FlutterError(code: "GetBankListError", message: error.localizedDescription, details: nil))
                }
            }
        } catch SBPWidgetError.presentationFailed {
            result(FlutterError(code: "PresentationFailed", message: "Parent view controller for modal presentation not found", details: nil))
        } catch SBPWidgetError.loadingFaild {
            result(FlutterError(code: "LoadingFaild", message: "Can't load bank list", details: nil))
        } catch SBPWidgetError.invalidURLString {
            result(FlutterError(code: "InvalidURLString", message: "Can't parse parameters from received url", details: nil))
        } catch {
            result(FlutterError(code: "UnhandledException", message: "Произошла непредвиденная ошибка", details: nil))
        }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
