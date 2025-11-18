package dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {
	
	private static Connection connection;

    public static Connection getConnection() {
        try {
            if (connection == null || connection.isClosed()) {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connection = DriverManager.getConnection(
                        "jdbc:mysql://localhost:3306/cinema_db",
                        "root",  
                        "Bishnu@068" 
                );
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return connection;
    }

}
