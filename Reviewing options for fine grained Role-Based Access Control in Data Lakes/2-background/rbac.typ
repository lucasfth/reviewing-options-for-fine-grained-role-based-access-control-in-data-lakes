#import "@preview/cetz:0.4.2"
== Role-based Access Control
#label("sec:rbac")

Role-based Access Control (RBAC) @ferraiolo1992rbac is an approach to access control based around assigning permissions to roles, and grouping users into these roles. Access control is then managed by controlling what roles are allowed to do what, instead of managing each user individually.
The "Core RBAC" model, as defined by Ferraiolo et. al. 2001, @ferraiolo2001proposal, consists of five basic elements: _users_, _roles_, _permissions_, _operations_ and _objects_.
A _user_ is some actor, typically a human user, but could also be an autonomous actor, who needs to be authorized for some set of actions.
A user is assigned one or more _roles_.
A role is simply some named collection of authorizations; for example, a job title.
A role is assigned one or more _permissions_, which are what give authorization to perform an _operation_ on a secured _object_. In a database context, an operation could be SQL commands like `SELECT` or `INSERT`, which are then applied to some database object, like a table or column. 
With this, _users_ have a many-to-many relationship to what _permissions_ they are authorized for, through their roles.
@listing:sql-rbac shows an example of permissions assignment to a role, and role assignment to a user in SQL.

#figure(
  caption: [Assignment of permission to a role, and role to a user in SQL],
  placement: top,
  scope: "column"
)[
    #set text(size: 8pt)
    #cetz.canvas({
      import cetz.draw: *
    
      group({
        content((0,0), [
          ```sql
          GRANT SELECT, INSERT ON TABLE journals TO doctors;
          ```
        ])
        line((-3.2,0.2), (-0.9,0.2),name: "ops", stroke: 0.5pt)
        line((-0.2,0.2), (2.18,0.2),name: "obs", stroke: 0.5pt)
        content(("ops.mid"), [Operations], anchor: "south", padding: .1)
        content(("obs.mid"), [Object], anchor: "south", padding: .1)
        line((-3.2,-0.2), (2.18,-0.2),name: "perm", stroke: 0.5pt)
        content(("perm.mid"), [Permission], anchor: "north", padding: .1)
        line((2.9,-0.2), (4.05,-0.2),name: "role", stroke: 0.5pt)
        content(("role.mid"), [Role], anchor: "north", padding: .1)
      })
      
      group({
        content((0,-1), [
          ```sql
          GRANT doctors TO alice;
          ```
        ])
        line((-0.95,-1.15), (0.25,-1.15), name: "role", stroke: 0.5pt)
        line((0.95,-1.15), (1.75,-1.15), name: "user", stroke: 0.5pt)
        content(("role.mid"), [Role], anchor: "north", padding: .1)
        content(("user.mid"), [User], anchor: "north", padding: .1)
      })
    }
  )
]<listing:sql-rbac>

In addition, Core RBAC also describes _sessions_.
A _session_ is a mapping of one user to a subset of the roles they are authorized for; i.e. a user "activates" one or more roles that have the necessary permissions, when they need to perform a specific operation on an object.
This allows for finer control of roles that are active in a given context, to prevent unnecessary access levels. 
Commonly, a hierarchy is introduced to allow for structuring roles which should inherit some base permissions; for example, a Doctor and Nurse role might inherit permissions from some base "Healthcare Worker" role.
This is referred to as "Hierarchical RBAC" #cite(<ferraiolo2001proposal>).

User membership is inherited top-down, and role permissions are inherited bottom-up.
That is, a "Doctor" is also a member of the "Healthcare Worker" role, and shares all the permissions of the role, including some of its own.
@fig:rbac shows the relationship of the entities in Hierarchical-, and by extension, Core RBAC.

#figure(
  placement: top,
  scope: "parent",
  caption: [The entity relationships in Hierarchical RBAC, as described by Ferraiolo et. al. 2001 @ferraiolo2001proposal. Arrows represent a many-to-many relation.]
)[
  #cetz.canvas({
    import cetz.draw: *
    circle((0,0))
    circle((4,0))
    circle((2,-2))
    circle((10, 0), radius: (100pt, 60pt))
    circle((8.5,0))
    circle((11.5,0))
    content((0,0), [Users])
    content((4,0), [Roles])
    content((2,-2), [Sessions])
    content((10,-1.5), [Permissions])
    content((8.5,0), [Objects])
    content((11.5,0), [Operations])
    line((1,0), (3,0), mark: (symbol:"straight"))
    line((0,-1), (1,-2), mark: (end: "straight"))
    line((3,-2), (4,-1), mark: (symbol: "straight"))
    line((5,0),(6.5,0), mark: (symbol: "straight"))
    line((9.5,0),(10.5,0), mark: (symbol: "straight"))
    line((4.6,0.8),(5,1.5), mark: (start: "straight"))
    line((3.4,0.8),(3,1.5), mark: (start: "straight"))
    line((3,1.5),(5,1.5))
    content((4,1.8), [Role Hierarchy])
  })
]
<fig:rbac>


