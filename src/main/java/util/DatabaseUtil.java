package util;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseUtil {
    private static final String URL = "jdbc:oracle:thin:@localhost:1521:xe";;
    private static final String USER = "db1912339";
    private static final String PASSWORD = "oracle";
    private static Connection connection = null;

    static {
        try {
            Class.forName("oracle.jdbc.driver.OracleDriver");
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Oracle JDBC Driver not found.", e);
        }
    }

    public static Connection getConnection() throws SQLException {
    	connection = DriverManager.getConnection(URL, USER, PASSWORD);
        return connection;
    }
    
    public static void closeConnection() {
    	if (connection != null) {
    		try {
				connection.close();
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
    	}
    }
}