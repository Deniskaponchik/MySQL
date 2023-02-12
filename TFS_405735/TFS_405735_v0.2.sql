/*РЕАЛИЗАЦИЯ: БЕЗ CTE, БЕЗ LATERAL*/

SELECT 
  c.date_mod DateMod
, c.contact login, c.name PCname
, comptype.name PCtype, manuf1.name PCmanufacturer, model.name PCmodel, c.serial PCserial
, proc.procname Processor
/*, dm.size RAM*/
, ( select sum(idm.size) AS size
    from glpi_items_devicememories idm
    where idm.items_id = c.id
    ) RAM
    
/*, disks.name disk, disks.device, round(disks.totalsize/1048576,0) total, round(disks.freesize/1048576,0) free*/
, diskC.name DiskCmodel, diskC.total DiskCtotal, diskC.free DiskCfree
, diskD.name DiskDmodel, diskD.total DiskDtotal, diskD.free DiskDfree

, monit1.proizvod, monit1.model
, os.Osname, os.OSversion

FROM glpi_db.glpi_computers c
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
	select mon1.users_id usersid1, manuf2.name proizvod, mon1.name model
    from glpi_monitors mon1
    left join glpi_manufacturers manuf2 on manuf2.id = mon1.manufacturers_id
    Limit 1
    ) monit1 on monit1.usersid1 = c.users_id


left join (
	select ios.items_id iosii, os1.name OSname, osv.name OSversion
    from glpi_items_operatingsystems ios
    left join glpi_operatingsystems  os1 on os1.id = ios.operatingsystems_id
    left join glpi_operatingsystemversions osv on osv.id = ios.operatingsystemversions_id
    ) os on os.iosii = c.id

where 
/*c.name = 'wsir-it-03'*/
c.contact = 'Vladimir.Inchin'
ORDER by c.date_mod DESC





/*      
SELECT DISTINCT TABLE_NAME 
FROM INFORMATION_SCHEMA.COLUMNS
WHERE (COLUMN_NAME like '%proc' or COLUMN_NAME like 'proc%' or COLUMN_NAME like '%proc%')
        AND TABLE_SCHEMA='glpi_db';
*/
        
        
        
        