# Host Groups

Even though Host Groups and Host Collections can do similar things (group systems), they are separate and when used properly, they can make management much easier.

Host Groups only allow a system to be a part of a single host group, but since they can be nested together, they allow for easier organization.

## Suggested Structure
- Capsules
- General
  - *Department1*/
    - *App1*/
      - *Department1*-*App1*-Dev
      - *Department1*-*App1*-Test
      - *Department1*-*App1*-QA
      - *Department1*-*App1*-Prod
  - *Department2*/
    - *Department2*-Dev
    - *Department2*-Test
    - *Department2*-QA
    - *Department2*-Prod

Capsules = Capsule servers since they typically need to be treated separately
General = Top level host group that allows for variables that will apply to all systems
*Department1*/*Department2* = Department, group, or team that is the primary contact for the servers. Having this available makes it easy to coordinate actions that need to be done to a specific department's machines
*App1* = If a Department/Group/Team owns multiple applications (web servers, database server, etc), this optional level allows you separate those systems out. This allows you to target a subset of systems for various actions
*Department*-(*App*)-*lifecycle* = This level allows you to configure the lifecycle in the host group and makes filtering down to the department and lifecycle for patching much easier.
