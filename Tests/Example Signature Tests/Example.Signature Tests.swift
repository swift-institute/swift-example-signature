import Example_Signature
import Tagged
import Testing

@Suite
struct `Example.Signature Tests` {

    @Test
    func `the signature forwards the example interface`() async {
        let greeting = Example.Greeting(greet: { request in Example.Greeting.greet(request.name) })
        #expect(await greeting.greet("Ada") == "Hello, Ada!")
    }
}
