import mysql from "mysql2";
import "dotenv/config";

export const mysqlPool = mysql.createPool({
  host: process.env.DB_DEV_HOST,
  user: process.env.DB_DEV_USER,
  password: process.env.DB_DEV_PASSWORD,
  database: process.env.DB_DEV_NAME,
});

export default mysqlPool;
