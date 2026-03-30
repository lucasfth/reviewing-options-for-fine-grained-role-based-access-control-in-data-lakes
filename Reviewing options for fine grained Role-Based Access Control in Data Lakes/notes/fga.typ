// @listing:fga-schema shows OpenFGA Domain Specific Language (DSL) for an authorization model schema, and @listing:fga-rtuple shows a relationship tuple.
// ATRO: what is the difference between "relationship-based" and "role-based"?
// ATRO: maybe these figures should just go into appendix... i mean, we dont really use them outside of mild reference
// block to isolate custom code block styling
// #figure(
//   placement: top,
//   [
//   // custom styling, add background
//   #show raw: set block(fill: luma(245),inset : 8pt, radius: 4pt)
//   #show raw: set text(8pt)
//   #grid(columns: 2,
//     [
//       #figure(
//         ```toml
//         model
//           schema 1.1
        
//         type user
        
//         type document
//           relations
//             define reader: [user]
//             define writer: [user]
//             define owner: [user]
//         ```,
//         kind: raw,
//         caption: "An OpenFGA authorization model schema definition"
//       )<listing:fga-schema>
//     ],
//     [
//       #figure(
//         ```yaml
//         {
//           user: 'user:anne',
//           relation: 'reader',
//           object: 'document:Z'
//         }
//         ```,
//         kind: raw,
//         caption: [An OpenFGA relationship tuple defining that the user _anne_ is a _reader_ of _document_ "Z"]
//       )<listing:fga-rtuple>
//     ]
//   )]
// )