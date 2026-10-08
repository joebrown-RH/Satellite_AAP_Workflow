# Sync Plans

It's usually best to just have a single Sync Plan with all products added that will run daily. This will decrease the delta that needs to sync. It is also recommended to pick a time that will be after any automations may run overnight (spreads out backend disk I/O) while still be early enough in the morning that you can check on the sync results as part of your morning routine.

## Recommended setup:
```
Name: Daily Sync
Interval: daily
Start Date: *current date*
Start Time: 05:00
Products: *Add all*
```