import Example
import Example_Client
import Example_Counter
import Example_Counter_Client
import Example_Greeting
import Example_Greeting_Client
import Optic_Primitives
import Testing

@Suite
struct `Example.Call Tests` {

    @Test
    func `a leaf call round trips through its derived prism`() {
        let call = Example.Counter.Call.increment(limit: .init(7))

        #expect(Example.Counter.Call.prisms.increment.extract(call) != nil)
        #expect(
            Example.Greeting.Call.prisms.greet.extract(.greet(.init("Ada")))
                == Example.Greeting.Name("Ada")
        )
    }

    @Test
    func `a leaf eliminator reaches its own branch`() {
        let greeting = Example.Greeting.Call.greet(.init("Ada"))

        #expect(greeting.eliminate(greet: { $0.underlying }) == "Ada")
    }

    @Test
    func `the derived metadata names each operation's output and refusal`() {
        let _: Example.Greeting.Call.Failure.Type = Swift.Never.self
        let _: Example.Counter.Call.Failure.Type = Example.Counter.Error.self
        let output: Example.Counter.Call.Output = .init(3)

        #expect(output == Example.Counter.Value(3))
    }

    @Test
    func `the root call embeds each leaf and extracts only its own case`() {
        let counter = Example.Call.counter(.increment(limit: .init(3)))
        let greeting = Example.Call.greeting(.greet(.init("Ada")))

        #expect(Example.Call.prisms.counter.extract(counter) != nil)
        #expect(Example.Call.prisms.greeting.extract(counter) == nil)
        #expect(Example.Call.prisms.greeting.extract(greeting) != nil)
        #expect(Example.Call.prisms.counter.extract(greeting) == nil)
    }

    @Test
    func `the root eliminator is exhaustive over both subdomains`() {
        let calls: [Example.Call] = [
            .greeting(.greet(.init("Ada"))),
            .counter(.increment(limit: .init(2))),
        ]

        let named = calls.map { call in
            call.eliminate(
                greeting: { _ in "greeting" },
                counter: { _ in "counter" }
            )
        }

        #expect(named == ["greeting", "counter"])
    }
}
