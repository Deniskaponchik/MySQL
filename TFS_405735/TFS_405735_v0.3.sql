/*РЕАЛИЗАЦИЯ: LATERAL */

USE glpi_db;

SELECT c.date_mod
, c.contact login, c.name
, comptype.name, model.name model, manuf1.name manufacturer
, proc.procname Processor
/*, dm.size RAM*/
, ( select sum(idm.size) AS size
    from glpi_items_devicememories idm
    where idm.items_id = c.id
    ) RAM
/*, disks.name disk, disks.device, round(disks.totalsize/1048576,0) total, round(disks.freesize/1048576,0) free*/
, diskC.device DiskC, diskC.name DiskCname, diskC.total DiskCtotal, diskC.free DiskCfree
, diskD.device DiskD, diskD.name DiskDname, diskD.total DiskDtotal, diskD.free DiskDfree
, manuf2.name
, os.Osname, os.OSversion

FROM glpi_db.glpi_computers c

/*left join  glpi_manufacturers manuf2 ON manuf2.id = (
    select mon1.manufacturers_id
    from glpi_monitors mon1
    where mon1.users_id = c.users_id
    Limit 1
    )*/
LEFT JOIN LATERAL (
	select monit.users_id mui, manuf.name proizvod1, monit.name serial1
    from glpi_monitors monit
    left join glpi_manufacturers dmanuf2 on manuf2.id = monit.manufacturers_id
    where monit.users_id = c.users_id
    order by mui
    LIMIT 1
    ) monitor1 ON TRUE

LEFT JOIN glpi_computertypes comptype ON comptype.id = c.computertypes_id
LEFT JOIN glpi_computermodels model ON model.id = c.computermodels_id
left join glpi_manufacturers manuf1 on manuf1.id = c.id

left join (
	select idp.items_id idpii, dp.designation PROCname
    from glpi_items_deviceprocessors idp
    left join glpi_deviceprocessors dp on dp.id = idp.deviceprocessors_id
    ) proc on proc.idpii = c.id

/*left join glpi_items_disks diskD on disks.items_id = c.id*/
left join (
	select items_id, device, name, round(totalsize/1048576,0) total, round(freesize/1048576,0) free
    from glpi_items_disks disk1
    where device = 'C:'
    ) diskC on diskC.items_id = c.id
left join (
	select items_id, device, name, round(totalsize/1048576,0) total, round(freesize/1048576,0) free
    from glpi_items_disks disk2
    where device = 'D:'
    ) diskD on diskD.items_id = c.id

left join (
	select ios.items_id iosii, os1.name OSname, osv.name OSversion
    from glpi_items_operatingsystems ios
    left join glpi_operatingsystems  os1 on os1.id = ios.operatingsystems_id
    left join glpi_operatingsystemversions osv on osv.id = ios.operatingsystemversions_id
    ) os on os.iosii = c.id

where c.name = 'wsir-it-03'
ORDER by c.date_mod DESC





/*      
select @@version


SELECT DISTINCT TABLE_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE (COLUMN_NAME like '%proc' or COLUMN_NAME like 'proc%' or COLUMN_NAME like '%proc%')
        AND TABLE_SCHEMA='glpi_db';
*/
        
        
        
        