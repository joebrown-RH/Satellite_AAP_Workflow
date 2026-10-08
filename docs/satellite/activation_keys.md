# Activation Keys

Activation keys should be used to assign the initial Lifecycle Environment, Content View, and System Purpose. The can also be used to assign a Host Collection.

## Multiple Activation Keys
Since multiple activation keys can be used during the registration process, this allows us to break out some of the information that needs to be specified. Primarily, the patch group. Unfortunately, this can no longer be done with lifecycle environment and content view as those are now tied together when assigning them to an activation key.

## System Pupose
System purpose should be set on at least 1 of the activation key that each system will use. If your SLA is tied to specific lifecycle steps, the activation keys that set the lifecycle step can also be used to set the system purpose. If you SLA is not tied to something else that's being specified in an activation key, you can create separate activations key for the SLA.

## Repository Sets
Most repository sets are not enabled by default. When you are creating the activation key, make sure to go to the Repository Sets tab and enable all repositories that are available. Your Content Views will be responsible for disabling any repositories the machines should not see.

## Suggested Activation Keys
- *Composite Content View*-*Lifecycle Environment*
- PG1
- PG2
- PG3

*Composite Content View*-*Lifecycle Environment* will expand out to each combination of Composite Content Views and Lifecycle Environment. If you use the Content Views describe (earlier)[content_views.md] and the example (Lifecycle Environments)[lifecycle_environments.md], that would result in 16 activation keys:
| Name           | Content View         | Lifecycle Environment |
| -------------- | -------------------- | --------------------- |
| RHEL_Dev       | ccv_RHEL             | Dev                   |
| RHEL_Test      | ccv_RHEL             | Test                  |
| RHEL_QA        | ccv_RHEL             | QA                    |
| RHEL_Prod      | ccv_RHEL             | Prod                  |
| RHEL_EPEL_Dev  | ccv_RHEL_EPEL        | Dev                   |
| RHEL_EPEL_Test | ccv_RHEL_EPEL        | Test                  |
| RHEL_EPEL_QA   | ccv_RHEL_EPEL        | QA                    |
| RHEL_EPEL_Prod | ccv_RHEL_EPEL        | Prod                  |
| SAP_Sol_Dev    | ccv_SAP_Solutions    | Dev                   |
| SAP_Sol_Test   | ccv_SAP_Solutions    | Test                  |
| SAP_Sol_QA     | ccv_SAP_Solutions    | QA                    |
| SAP_Sol_Prod   | ccv_SAP_Solutions    | Prod                  |
| SAP_App_Dev    | ccv_SAP_Applications | Dev                   |
| SAP_App_Test   | ccv_SAP_Applications | Test                  |
| SAP_App_QA     | ccv_SAP_Applications | QA                    |
| SAP_App_Prod   | ccv_SAP_Applications | Prod                  |

PG1-3 are for the Patch Group Host Collections. For those you would **not** assign a content view or lifecycle step and instead would only assign a Host Collection for the corresponding Patch Group Host Collection.
