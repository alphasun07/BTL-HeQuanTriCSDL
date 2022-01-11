exec sp_addlogin 'connect_sa','123456'

drop login connect_sa

use thpt_vap

exec sp_grantdbaccess 'connect_sa','SA'

exec sp_addrolemember 'db_datawriter','SA'
