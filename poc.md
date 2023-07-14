# POC

## Plans

- Design & Planning
    - Documents in scope for the project
    - Overall flow of CRUD & state change information (draft & final versions)
    - Versioning approach for document changes across all services, paying attention to possible Azure service limits for the various components
    - Security considerations (network, keys, etc.)
    - Performance characteristics of all components
    - DR/HA requirements consistent with BST11 Core system
- Infrastructure Deployment
    - Deployment of Dev Environment and Dev infrastructure in a single region
    - API Management Developer Version
    - Azure Service Bus
    - Logic Apps Instance
- Azure Service Bus (ASB)
    - Rationalize the agreed-up versioning approach for ASB
    - Define consistent taxonomy and version implementation (namespace, topic, subscriptions) for both delivery approaches
    - Setup ASB with some process (ideally UI) to publish messages/events on demand
    - Capture data events from BST Core API and push them to ASB (3-5 events)
    - Capture Schema events from BST Core API and update subscription
    - Test for the scale of subscriptions
        - 3-5 API endpoints to load test using a standard SKU
- API Management (APIM)
    - Translate versioning to APIM Configuration structure
    - Decide on an API update approach
    - Setup APIM manually w/ basic security in place
    - Import subset of BST Core API and route through for validation
    - Create a code sample to respond to schema changes and spin up the next version of API, keeping the old one in place
- Logic Apps Connector
    - Create a certified, commercial-grade, Managed Logic Apps Connector for BST11 based upon the Microsoft official certification guidelines that can be consumed in Logic Apps, Power Apps, and Power Automate.
    - Design API versioning approach for this technology (Power Platform vs. Azure Integration Services)
    - Connect to mock ASB for validation (can manually push messages/events to ASB)
    - Build one (1) locally deployable connector
    - For one (1) object and one (1) trigger, implement one action
    - POC the schema update process
- Web Hooks
    - Rationalize versioning approach based on industry standards
    - Review MSFT architecture, compare with previous experience
    - Agree on an approach for continuous data relay mechanism and schema change
    - Connect to mock ASB for validation (can manually push messages/events to ASB)
    - Build unhardened code for publishing events, handle simple schema change
    - No registration UI; manually add registrations
- Testing and Validation
    - Baseline Performance
        – Benchmark response times and throughput for ASB and Web Hook Messaging, Logic Apps Connector Triggers, and Logic Apps Connector and APIM CRUD to baseline

performance, validate acceptance criteria (as defined in Build-out phase), and assess performance optimization.

## Goals

- Quick and thorough validation of basic requirements and viability for all 4 components.
- Focus on schema change/versioning logic
- Baseline performance
- Check-gate at end of POC for project management and re-alignment

## Notes

- D&O, Versioning, will need to verify
- D&O, Security considerations, will need to verify
- D&O, Performance characteristics, need measurements of all
- Infra, API Management Developer Version
- Infra, Azure Service Bus
- Capture data events from BST Core API and push them to ASB (3-5 events)
- Capture Schema events from BST Core API and update subscription
- Test for the scale of subscriptions
- Setup APIM manually w/ basic security in place
- Import subset of BST Core API and route through for validation
- Performance validation