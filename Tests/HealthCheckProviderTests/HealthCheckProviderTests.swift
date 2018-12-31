import XCTest
@testable import HealthCheckProvider
@testable import Vapor
import Testing

final class HealthCheckProviderTests: XCTestCase {

    func testHealthcheck() {
        var config = try! Config(arguments: ["vapor", "--env=test"])
        try! config.set("healthcheck.url", "healthcheck")
	try! config.addProvider(HealthCheckProvider.Provider.self)
        let drop = try! Droplet(config)
        background {
            try! drop.run()
        }

        try! drop
            .testResponse(to: .get, at: "healthcheck")
            .assertStatus(is: .ok)
            .assertJSON("status", equals: "up")
    }


    static var allTests = [
        ("testHealthcheck", testHealthcheck),
    ]

    override func setUp() 
    {
        Testing.onFail = XCTFail
    }
}
