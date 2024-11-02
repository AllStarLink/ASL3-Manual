# Other Software Products

The following information relates to software components related to AllStarLink.

## Web Dashboards

The primary web dashboard supported by AllStarLink is [Allmon3](../allmon3/basics.md).

But, we know there are other dashboards available and everyone has their own personal favorite.
We also know that some of the other dashboards make use of database ("astdb.txt").
Typically, this DB has been downloaded by a PHP script ("astdb.php") and updated with the help of boot scripts and cron jobs.

To support these other dashboards we have included a systemd service to download and update the "astdb.txt" database.  By default, this service and its associated timer are disabled.  If you have installed a dashboard that is dependent on this database you will need to execute the following commands :

```bash
systemctl enable asl3-update-astdb.service
systemctl enable asl3-update-astdb.timer
systemctl start asl3-update-astdb.timer
```
