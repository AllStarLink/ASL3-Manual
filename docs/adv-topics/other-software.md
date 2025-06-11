# Other Software Products
The following information relates to software components related to AllStarLink.

## Web Dashboards
The primary web dashboard supported by AllStarLink is [Allmon3](../allmon3/index.md).

However, we know there are other dashboards available and everyone has their own personal favorite. We also know that some of the other dashboards make use of the database file, `astdb.txt`. Typically, this database has been downloaded by a PHP script (`astdb.php`) and updated with the help of boot scripts and cron jobs.

To support these other dashboards, we have included a `systemd` service to download and update the `astdb.txt` database. By default, this service and its associated timer are disabled. If you have installed a dashboard that is dependent on this database, you will need to execute the following commands:

```
sudo systemctl enable asl3-update-astdb.service
sudo systemctl enable asl3-update-astdb.timer
sudo systemctl start asl3-update-astdb.timer
```
