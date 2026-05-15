Create an onboarding guide as markdown file for <FEATURE/APPLICATION/SERVICE>.

Include details like as headings:
1. Feature Summary - summarize high-level feature/application/service
2. Mermaid Diagrams - provide ERDs, architecture diagrams for backend and frontend separately, and sequence diagrams relevant for the feature/application/service
3. Key Files & Symbols - links to code files, readmes, with descriptions on what they do
4. Actors & Capabilities - who are the users that use this feature/application/service (ie. instructor, learner, admin, developer)
5. Core Journeys (End-to-End) - especially helpful for user experiences, describe who the user is, how they get to the experiences, what URLs represent these experiencs (if any), and the result
6. Domain Models - the entities, models, and API definitions
7. Source of Truth - where data is stored, the type of database, kafka topics and schemas
8. Critical Semantics - described terms and flows used in the feature/application/service in plain english
9. Performance & Reliability - how does this feature/application/service manage its performance (ie. caching details, circuit breakers)
10. Observability & Debugging - what datadog metrics are emitted? what event-tracking kafka events are emitted? Are there any datadog, Sentry dashboards provided
11. Integration Points - For APIs or kafka - who are the clients, produces, and consumers of this application/feature/service
12. Failure Modes & Debugging Playbook - describe what could or has failed based on code changes in the feature/service/application
13. Safe-Change Checklist - provide a checklist of what a good change in this feature/service/application looks like to avoid failure modes
14. Open Questions - what open questions is there still after providing this guide. This is where the user can dive in further and fill-in the details
