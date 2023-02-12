SELECT c.name, model.name model, manuf1.name 
, c.contact login
, dm.size RAM
, disks.name disk, disks.device, round(disks.totalsize/1048576,0) total, round(disks.freesize/1048576,0) free
, os.Osname, os.OSversion
FROM glpi_db.glpi_computers c
left join lateral (
	select sum(idm.size) AS size
    from glpi_items_devicememories idm
    where idm.items_id = c.id
    /*where idm.items_id = 4024*/
    /*group by idm.id*/
    order by idm.size
    ) dm on 1=1
LEFT JOIN glpi_computermodels model ON model.id = c.computermodels_id
left join glpi_manufacturers manuf1 on manuf1.id = c.id
left join glpi_items_disks disks on disks.items_id = c.id
left join (
	select ios.items_id iosii, os1.name OSname, osv.name OSversion
    from glpi_items_operatingsystems ios
    left join glpi_operatingsystems  os1 on os1.id = ios.operatingsystems_id
    left join glpi_operatingsystemversions osv on osv.id = ios.operatingsystemversions_id
    ) os on os.iosii = c.id

where c.name = 'wsir-it-03'