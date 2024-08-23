import mysql from 'mysql'

export const mysqlPool = mysql.createPool({
    host: 'localhost',
    user: 'root',
    password: 'root',
    database: 'plastikoo2'
});

export default  mysqlPool;

