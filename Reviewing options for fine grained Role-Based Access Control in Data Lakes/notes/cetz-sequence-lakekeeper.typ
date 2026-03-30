#import "@preview/cetz:0.4.2"

#figure(
  placement: top,
  scope: "parent"
)[
  #cetz.canvas({
  import cetz.draw: *
  group({
    scale(0.75)
     // === Actors ===
    rect((0, 0), (rel: (3, 1)), name: "qe", stroke: black)
    rect((5, 0), (rel: (3, 1)), name: "oidc", stroke: black)
    rect((10, 0), (rel: (3, 1)), name: "lakekeeper", stroke: black)
    rect((15, 0), (rel: (3, 1)), name: "openfga", stroke: black)
    rect((20, 0), (rel: (3, 1)), name: "storage", stroke: black)
  
    // Actor labels (top)
    content("qe.center", [Query Engine], anchor: "center")
    content("oidc.center", [OIDC Provider], anchor: "center")
    content("lakekeeper.center", [Lakekeeper], anchor: "center")
    content("openfga.center", [OpenFGA], anchor: "center")
    content("storage.center", [Object Storage], anchor: "center")
  
    // === Lifelines ===
    line("qe.south", (rel: (0, -11)), name: "qe-life")
    line("oidc.south", (rel: (0, -11)), name: "oidc-life")
    line("lakekeeper.south", (rel: (0, -11)), name: "lakekeeper-life")
    line("openfga.south", (rel: (0, -11)), name: "openfga-life")
    line("storage.south", (rel: (0, -11)), name: "storage-life")
  
    // === Authenticate ===
    line(
      (name: "qe-life", anchor: 10%),
      (name: "oidc-life", anchor: 10%),
      name: "auth",
      mark: (end: ">")
    )
    content("auth.mid", [Authenticate (OIDC Flow)], anchor: "south")
  
    // ID token + access token (return)
    line(
      (name: "oidc-life", anchor: 15%),
      (name: "qe-life", anchor: 15%),
      name: "tokens",
      stroke: (dash: "dashed")
    )
    mark((name: "qe-life", anchor: 15%), 180deg, symbol: ">")
    content("tokens.mid", [ID Token + Access Token], anchor: "north")
  
    // === Request with token ===
    line(
      (name: "qe-life", anchor: 22%),
      (name: "lakekeeper-life", anchor: 22%),
      name: "request",
      mark: (end: ">")
    )
    content("request.mid", [Request + OIDC Token], anchor: "south")
  
    // === Token validation ===
    line(
      (name: "lakekeeper-life", anchor: 27%),
      (name: "oidc-life", anchor: 27%),
      name: "validate",
      mark: (end: ">")
    )
    content("validate.mid", [Validate Token], anchor: "south")
  
    line(
      (name: "oidc-life", anchor: 32%),
      (name: "lakekeeper-life", anchor: 32%),
      name: "valid",
      stroke: (dash: "dashed")
    )
    mark((name: "lakekeeper-life", anchor: 32%), 0deg, symbol: ">")
    content("valid.mid", [Token Valid], anchor: "north")
  
    // === Authorization ===
    line(
      (name: "lakekeeper-life", anchor: 40%),
      (name: "openfga-life", anchor: 40%),
      name: "check",
      mark: (end: ">")
    )
    content("check.mid", [Check Permission], anchor: "south")
  
    line(
      (name: "openfga-life", anchor: 45%),
      (name: "lakekeeper-life", anchor: 45%),
      name: "decision",
      stroke: (dash: "dashed")
    )
    mark((name: "lakekeeper-life", anchor: 45%), 0deg, symbol: ">")
    content("decision.mid", [allow / deny], anchor: "north")
  
    // === Credentials vending ===
    line(
      (name: "lakekeeper-life", anchor: 55%),
      (name: "qe-life", anchor: 55%),
      name: "creds",
      stroke: (dash: "dashed")
    )
    mark((name: "qe-life", anchor: 55%), 180deg, symbol: ">")
    content("creds.mid", [Vended Credentials (if allow)], anchor: "north")
  
    // === Data access ===
    line(
      (name: "qe-life", anchor: 65%),
      (name: "storage-life", anchor: 65%),
      name: "read",
      mark: (end: ">")
    )
    content("read.mid", [Read Data using credentials], anchor: "south")
  
    line(
      (name: "storage-life", anchor: 72%),
      (name: "qe-life", anchor: 72%),
      name: "data",
      stroke: (dash: "dashed")
    )
    mark((name: "qe-life", anchor: 72%), 180deg, symbol: ">")
    content("data.mid", [Data], anchor: "north")
  
    // === Actor labels (bottom) ===
    content((name: "qe-life", anchor: 100%), [Query Engine], anchor: "north")
    content((name: "oidc-life", anchor: 100%), [OIDC Provider], anchor: "north")
    content((name: "lakekeeper-life", anchor: 100%), [Lakekeeper], anchor: "north")
    content((name: "openfga-life", anchor: 100%), [OpenFGA], anchor: "north")
    content((name: "storage-life", anchor: 100%), [Object Storage], anchor: "north")
    })
})
]