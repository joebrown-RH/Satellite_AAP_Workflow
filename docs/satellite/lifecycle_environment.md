# Lifecycle Environments

Lifecycle environments should, for the most part, be a single path. Everyone typically has their variation of `Dev -> Test -> QA -> Prod`. That should be created as a single path.

## Multiple patching schedules
If you have multiple patching schedules (ex: weekly and monthly) for different sets of machines that is where you should use multiple lifecycle paths. This will allow you to reuse the same content view with one of the lifecycle paths skipping over some of the versions.

Example:
```
Version 1.0 = Month 1 Week 1
Version 2.0 = Month 1 Week 2
Version 3.0 = Month 1 Week 3
Version 4.0 = Month 1 Week 4
Version 5.0 = Month 2 Week 1
```
```mermaid
gantt
    title Content View Promotion Schedule
    dateFormat YYYY-MM-DD
    section Version 1.0
        Weekly Dev        :active, weekly_dev1, 2026-01-01, 7d
        Weekly Test     :active, weekly_test1, 2026-01-02, 7d
        Weekly QA     :active, weekly_qa1, 2026-01-03, 7d
        Weekly Prod     :active, weekly_prod1, 2026-01-04, 7d
        Monthly Dev        :active, monthly_dev1, 2026-01-01, 30d
        Monthly Test     :active, monthly_test1, 2026-01-08, 30d
        Monthly QA     :active, monthly_qa1, 2026-01-15, 30d
        Monthly Prod     :active, monthly_prod1, 2026-01-22, 30d
    section Version 2.0
        Weekly Dev        :active, weekly_dev2, after weekly_dev1, 7d
        Weekly Test     :active, weekly_test2, after weekly_test1, 7d
        Weekly QA     :active, weekly_qa2, after weekly_qa1, 7d
        Weekly Prod     :active, weekly_prod2, after weekly_prod1, 7d
    section Version 3.0
        Weekly Dev        :active, weekly_dev3, after weekly_dev2, 7d
        Weekly Test     :active, weekly_test3, after weekly_test2, 7d
        Weekly QA     :active, weekly_qa3, after weekly_qa2, 7d
        Weekly Prod     :active, weekly_prod3, after weekly_prod2, 7d
     section Version 4.0
        Weekly Dev        :active, weekly_dev4, after weekly_dev3, 7d
        Weekly Test     :active, weekly_test4, after weekly_test3, 7d
        Weekly QA     :active, weekly_qa4, after weekly_qa3, 7d
        Weekly Prod     :active, weekly_prod4, after weekly_prod3, 7d
    section Version 5.0
        Weekly Dev        :active, weekly_dev5, after weekly_dev4, 7d
        Weekly Test     :active, weekly_test5, after weekly_test4, 7d
        Weekly QA     :active, weekly_qa5, after weekly_qa4, 7d
        Weekly Prod     :active, weekly_prod5, after weekly_prod4, 7d
        Monthly Dev        :active, monthly_dev2, after monthly_dev1, 30d
        Monthly Test     :active, monthly_test2, after monthly_test1, 30d
        Monthly QA     :active, monthly_qa2, after monthly_qa1, 30d
        Monthly Prod     :active, monthly_prod2, after monthly_prod1, 30d
```