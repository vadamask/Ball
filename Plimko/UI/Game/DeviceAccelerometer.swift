import Foundation
import CoreMotion

final class DeviceAccelerometer {
    
    private let motionManager = CMMotionManager()
    
    func start() {
        motionManager.startAccelerometerUpdates()
    }
    
    func stop() {
        motionManager.stopAccelerometerUpdates()
    }
    
    func getAsyncData(interval: TimeInterval = 0.1, handler: @escaping (_ x: Float, _ y: Float, _ z: Float) -> Void) {
        
        if motionManager.isAccelerometerAvailable {
            motionManager.accelerometerUpdateInterval = interval
            motionManager.startAccelerometerUpdates(to: OperationQueue()) { data, error in
                if let data {
                    handler(Float(data.acceleration.x), Float(data.acceleration.y), Float(data.acceleration.z))
                }
            }
        }
    }
    
    func getData() -> CMAccelerometerData? {
        motionManager.accelerometerData
    }
}
