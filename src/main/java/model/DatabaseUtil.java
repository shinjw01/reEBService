package model;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DatabaseUtil {
    private static final String URL = "jdbc:mysql://localhost:3306/schema";  // DB URL
    private static final String USER = "root";  // MySQL 사용자 이름
    private static final String PASSWORD = "vn3ew2iv5lzs4!";  // MySQL 비밀번호
    private static Connection connection = null;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");  // MySQL 드라이버 클래스
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("MySQL JDBC Driver not found.", e);
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
				e.printStackTrace();
			}
    	}
    }
}
