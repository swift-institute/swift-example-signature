import Example
import Example_Client
import Example_Counter
import Example_Counter_Client
import Example_Greeting
import Example_Greeting_Client
import Operation
import Testing

@Suite
struct `Example.Call Tests` {

    @Test
    func `a call is switched over like any coproduct`() {
        let call = Example.Call.counter(.increment(limit: .init(3)))

        switch call {
        case .counter(.increment(let increment)):
            #expect(increment.input == .init(3))
        case .greeting:
            Issue.record("expected the counter branch")
        }
    }
}
