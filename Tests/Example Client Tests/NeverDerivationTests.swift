import Algebra_Derivation
public import Call_Derivation
import Client
import Testing

public enum NeverDerivationFixture {
    @Algebra
    @Calls
    package protocol Signature {
        func inspect(_ value: Int) async -> String
        func idle() async throws(Swift.Never)
    }
}

@Test
func explicitNeverRemainsAnEmptyFailureRow() async {
    let client = NeverDerivationFixture.Client(
        inspect: { String($0) },
        idle: {}
    )
    let _: NeverDerivationFixture.Call.Failure.Type = Swift.Never.self

    await client.idle()
    let output = await client(.idle)
    let isIdle = if case .idle = output { true } else { false }
    #expect(isIdle)
}
