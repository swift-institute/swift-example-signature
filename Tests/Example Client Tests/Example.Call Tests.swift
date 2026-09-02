import Example
import Example_Client
import Example_Counter
import Example_Counter_Client
import Example_Greeting
import Example_Greeting_Client
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
    func `a leaf eliminator reaches its own branch`() async throws {
        let greeting = Example.Greeting.Call.greet(.init("Ada"))

        #expect(
            try await greeting.eliminate(greet: { $0.underlying })
                == "Ada"
        )
    }

    @Test
    func `a leaf call carries its operation signature`() {
        let _: Example.Greeting.Call.Operation.Input.Type = Example.Greeting.Name.self
        let _: Example.Greeting.Call.Operation.Output.Type = Example.Greeting.Message.self
        let _: Example.Greeting.Call.Operation.Failure.Type = Swift.Never.self
        let _: Example.Counter.Call.Operation.Input.Type = Example.Counter.Limit.self
        let _: Example.Counter.Call.Operation.Output.Type = Example.Counter.Value.self
        let _: Example.Counter.Call.Operation.Failure.Type = Example.Counter.Error.self
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
    func `the root eliminator is exhaustive over both subdomains`() async throws {
        let greeting = try await Example.Call.greeting(
            .greet(.init("Ada"))
        ).eliminate(
            greeting: { _ in "greeting" },
            counter: { _ in "counter" }
        )
        let counter = try await Example.Call.counter(
            .increment(limit: .init(2))
        ).eliminate(
                greeting: { _ in "greeting" },
                counter: { _ in "counter" }
        )

        #expect([greeting, counter] == ["greeting", "counter"])
    }
}
