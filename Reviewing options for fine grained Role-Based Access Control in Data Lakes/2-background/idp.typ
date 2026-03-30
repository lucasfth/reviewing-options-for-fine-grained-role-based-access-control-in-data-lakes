== Identity Provider

Identity Provider (IdP) is responsible for storing and managing a user's identity, thus ensuring authentication.
When provided with a valid password and email, it will return a token, most often a JWT Token#footnote[https://www.ibm.com/docs/en/cics-ts/6.x?topic=cics-json-web-token-jwt], proving the client's identity.
This token is then appended to subsequent calls, which need the user to be authenticated.#cite(<cloudflare-idp-exp>)
The IdP Service is one of the external services some data lakes rely on for validating identities, while some have their own internal one, or sometimes they have the option for both.
